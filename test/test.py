import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_cfar(dut):
    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Reset
    dut.rst_n.value = 0
    for _ in range(5):
        await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)  # one clean cycle after reset release

    # Enough background + spike to fill any reasonable CFAR window
    samples = [10, 11, 9, 10, 12, 11, 10,  # background (7 samples)
               200,                          # spike
               10, 11, 10, 9, 11, 10, 12]   # trailing background

    detected = False

    for s in samples:
        dut.ui_in.value = s
        await RisingEdge(dut.clk)
        await Timer(1, unit="ns")   # let combinational outputs settle after clock edge
        out = int(dut.uo_out.value)
        dut._log.info(f"input={s:3d}  uo_out=0b{out:08b}")
        if out & 0x01:
            detected = True

    # Extra drain cycles in case of pipeline latency
    dut.ui_in.value = 0
    for i in range(20):
        await RisingEdge(dut.clk)
        await Timer(1, unit="ns")
        out = int(dut.uo_out.value)
        dut._log.info(f"drain {i:2d}  uo_out=0b{out:08b}")
        if out & 0x01:
            detected = True

    assert detected, "CFAR failed to detect spike"
