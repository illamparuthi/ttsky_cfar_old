import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

def safe_bit(signal, bit):
try:
return int(signal.value[bit])
except:
return 0

async def reset_dut(dut):
dut.ena.value = 1
dut.ui_in.value = 0
dut.uio_in.value = 0
dut.rst_n.value = 0
await ClockCycles(dut.clk, 10)
dut.rst_n.value = 1
await ClockCycles(dut.clk, 5)

@cocotb.test()
async def test_detect_spike(dut):
clock = Clock(dut.clk, 10, unit="ns")
cocotb.start_soon(clock.start())


await reset_dut(dut)

# noise
for _ in range(20):
    dut.ui_in.value = 10
    await RisingEdge(dut.clk)

# spike
detected = False
for _ in range(10):
    dut.ui_in.value = 200
    await RisingEdge(dut.clk)
    if safe_bit(dut.uo_out, 0):
        detected = True

assert detected, "Spike not detected"


@cocotb.test()
async def test_no_false_alarm(dut):
clock = Clock(dut.clk, 10, unit="ns")
cocotb.start_soon(clock.start())


await reset_dut(dut)

false_alarm = False
for _ in range(40):
    dut.ui_in.value = 10
    await RisingEdge(dut.clk)
    if safe_bit(dut.uo_out, 0):
        false_alarm = True

assert not false_alarm, "False detection"

