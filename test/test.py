import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotb.types import Logic

@cocotb.test()
async def test_cfar(dut):
    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Reset — hold longer to allow GL flops to initialize
    dut.rst_n.value = 0
    for _ in range(10):          # was 5, increase to 10 to be safe
        await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    samples = [10, 11, 9, 10, 12, 11, 10,
               200,
               10, 11, 10, 9, 11, 10, 12]

    detected = False

    def is_detected(signal):
        """Safely read a signal that may contain X/Z in gate-level sim."""
        try:
            return (int(signal.value) & 0x01) == 1
        except ValueError:
            # Contains X or Z — not yet valid, treat as 0
            dut._log.warning(f"uo_out contains X/Z: {signal.value}")
            return False

    for s in samples:
        dut.ui_in.value = s
        await RisingEdge(dut.clk)
        await Timer(1, unit="ns")   # let GL outputs settle
        if is_detected(dut.uo_out):
            detected = True
            dut._log.info(f"Detection on input={s}")

    dut.ui_in.value = 0
    for i in range(20):
        await RisingEdge(dut.clk)
        await Timer(1, unit="ns")
        if is_detected(dut.uo_out):
            detected = True
            dut._log.info(f"Detection on drain cycle {i}")

    assert detected, "CFAR failed to detect spike"
