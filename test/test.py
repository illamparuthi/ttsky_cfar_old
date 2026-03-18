import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge


@cocotb.test()
async def test_cfar_detection(dut):

    # Clock
    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    # Init
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    # Reset
    for _ in range(5):
        await RisingEdge(dut.clk)

    dut.rst_n.value = 1

    # Fill window
    for _ in range(10):
        dut.ui_in.value = 10
        await RisingEdge(dut.clk)

    # Test pattern
    samples = [10, 11, 9, 10, 12, 11, 10, 50, 11, 10]

    detected = False

    for i, s in enumerate(samples):
        dut.ui_in.value = s
        await RisingEdge(dut.clk)

        # pipeline delay
        await RisingEdge(dut.clk)

        # FIX: convert to int
        if int(dut.uo_out.value) & 0x1:
            dut._log.info(f"Detection at index {i}, value={s}")
            detected = True

    # extra cycles
    for _ in range(10):
        await RisingEdge(dut.clk)
        if int(dut.uo_out.value) & 0x1:
            detected = True

    assert detected, "❌ CFAR detector failed"

    dut._log.info("✅ CFAR detection PASSED")
