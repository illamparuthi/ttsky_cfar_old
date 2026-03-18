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
    # Fill window (VERY IMPORTANT)
    # -------------------------------
    for _ in range(12):
        dut.ui_in.value = 10
        await RisingEdge(dut.clk)

    # -------------------------------
    # Apply test pattern
    # -------------------------------
    samples = [10, 11, 9, 10, 12, 11, 10, 50, 11, 10]

    for s in samples:
        dut.ui_in.value = s
        await RisingEdge(dut.clk)

    # -------------------------------
    # Monitor detection (GL-safe)
    # -------------------------------
    detected = False

    for _ in range(60):   # 🔥 KEY: longer observation window
        await RisingEdge(dut.clk)

        bit0 = dut.uo_out.value[0]

        # Skip invalid (X/Z)
        if not bit0.is_resolvable:
            continue

        if int(bit0) == 1:
            dut._log.info("✅ Detection observed in simulation")
            detected = True
            break

    # -------------------------------
    # Assertion
    # -------------------------------
    assert detected, "❌ CFAR detector failed to detect target"

    dut._log.info("✅ CFAR detection PASSED")
