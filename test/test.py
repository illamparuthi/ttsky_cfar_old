import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_cfar_detection(dut):

    dut._log.info("Starting CFAR test")

    # -------------------------------
    # Clock
    # -------------------------------
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # -------------------------------
    # Reset
    # -------------------------------
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 5)

    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

    # -------------------------------
    # Fill window
    # -------------------------------
    dut._log.info("Filling CFAR window")
    for _ in range(16):
        dut.ui_in.value = 10
        await ClockCycles(dut.clk, 1)

    # -------------------------------
    # Apply test pattern
    # -------------------------------
    samples = [10, 11, 9, 10, 12, 11, 10, 50, 11, 10]

    dut._log.info("Applying samples")

    for s in samples:
        dut.ui_in.value = s
        await ClockCycles(dut.clk, 1)

    # -------------------------------
    # WAIT FOR DETECTION (HELLO STYLE)
    # -------------------------------
    dut._log.info("Waiting for detection...")

    for _ in range(100):   # 🔥 large wait window
        await ClockCycles(dut.clk, 1)

        bit0 = dut.uo_out.value[0]

        if not bit0.is_resolvable:
            continue

        if int(bit0) == 1:
            dut._log.info("✅ DETECTED target!")
            return  # SUCCESS

    # -------------------------------
    # If we reach here → FAIL
    # -------------------------------
    dut._log.error("❌ No detection observed")
    assert False, "CFAR detector failed (GL)"
