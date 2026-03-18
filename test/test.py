import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge


@cocotb.test()
async def test_cfar_detection(dut):

    # -------------------------------
    # Clock
    # -------------------------------
    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    # -------------------------------
    # Init
    # -------------------------------
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    # Reset
    for _ in range(5):
        await RisingEdge(dut.clk)

    dut.rst_n.value = 1

    # -------------------------------
    # Fill window (important)
    # -------------------------------
    for _ in range(10):
        dut.ui_in.value = 10
        await RisingEdge(dut.clk)

    # -------------------------------
    # Test pattern
    # -------------------------------
    samples = [10, 11, 9, 10, 12, 11, 10, 50, 11, 10]

    detected = False

    for i, s in enumerate(samples):
        dut.ui_in.value = s
        await RisingEdge(dut.clk)

        # Pipeline delay
        await RisingEdge(dut.clk)

        # -------------------------------
        # GL-safe detection check
        # -------------------------------
        bit0 = dut.uo_out.value[0]

        # Only check if valid (no X/Z)
        if bit0.is_resolvable and int(bit0) == 1:
            dut._log.info(f"Detection at index {i}, value={s}")
            detected = True

    # -------------------------------
    # Extra cycles (safety)
    # -------------------------------
    for _ in range(10):
        await RisingEdge(dut.clk)
        bit0 = dut.uo_out.value[0]
        if bit0.is_resolvable and int(bit0) == 1:
            detected = True

    # -------------------------------
    # Assertion
    # -------------------------------
    assert detected, "❌ CFAR detector failed to detect target"

    dut._log.info("✅ CFAR detection PASSED")
