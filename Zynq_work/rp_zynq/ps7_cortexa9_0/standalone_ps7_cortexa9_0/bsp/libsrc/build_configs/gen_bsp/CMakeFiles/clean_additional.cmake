# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "C:\\Temp\\246922\\MPC_PLD\\Zynq_work\\rp_zynq\\ps7_cortexa9_0\\standalone_ps7_cortexa9_0\\bsp\\include\\sleep.h"
  "C:\\Temp\\246922\\MPC_PLD\\Zynq_work\\rp_zynq\\ps7_cortexa9_0\\standalone_ps7_cortexa9_0\\bsp\\include\\xiltimer.h"
  "C:\\Temp\\246922\\MPC_PLD\\Zynq_work\\rp_zynq\\ps7_cortexa9_0\\standalone_ps7_cortexa9_0\\bsp\\include\\xtimer_config.h"
  "C:\\Temp\\246922\\MPC_PLD\\Zynq_work\\rp_zynq\\ps7_cortexa9_0\\standalone_ps7_cortexa9_0\\bsp\\lib\\libxiltimer.a"
  )
endif()
