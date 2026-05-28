# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "C:\\Temp\\246922\\MPC_PLD\\PC_10_template\\PC_10_template\\Vitis_workspace\\rp_top_platform\\microblaze_I\\standalone_microblaze_I\\bsp\\include\\sleep.h"
  "C:\\Temp\\246922\\MPC_PLD\\PC_10_template\\PC_10_template\\Vitis_workspace\\rp_top_platform\\microblaze_I\\standalone_microblaze_I\\bsp\\include\\xiltimer.h"
  "C:\\Temp\\246922\\MPC_PLD\\PC_10_template\\PC_10_template\\Vitis_workspace\\rp_top_platform\\microblaze_I\\standalone_microblaze_I\\bsp\\include\\xtimer_config.h"
  "C:\\Temp\\246922\\MPC_PLD\\PC_10_template\\PC_10_template\\Vitis_workspace\\rp_top_platform\\microblaze_I\\standalone_microblaze_I\\bsp\\lib\\libxiltimer.a"
  )
endif()
