/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xgpio.h"        // Ovladač pro AXI GPIO
#include "sleep.h"        // Funkce pro prodlevu (usleep)

#define GPIO_DEVICE_ID XPAR_AXI_GPIO_0_BASEADDR
#define LED_CHANNEL     2  // Kanál GPIO, kde jsou připojeny LED
#define SW_CHANNEL      1
#define ADD_PIN         7
#define BLINKY_PIN      6
#define SUB_PIN         4
#define DISP_PINS       8
#define DELAY           10
#define DELAY_LARGE     1000
#define DELAY_SMALL     200


XGpio gpio_inst; // Instance struktury pro GPIO

int main()
{

    u32 outdata = 0;
    u32 read_data = 0;
    u32 cnt = 0;
    u32 tick = 0;
    u32 next_tick = 0;
    u32 next_blink = 0;
    
    init_platform();

    print("Hello World\n\r");
    
    XGpio_Initialize(&gpio_inst, GPIO_DEVICE_ID);

    while (1)
    {
        read_data = XGpio_DiscreteRead(&gpio_inst, SW_CHANNEL);
        
        outdata &= ~(0xFF) | (1 << BLINKY_PIN);
        outdata |= ((read_data) & ~(1 << BLINKY_PIN));

        if (tick > next_tick)
        {
            if ((read_data & (1 << ADD_PIN)))
            {
                print("UP\n\r");
                cnt += 1;
                outdata &= (0xFF);
                outdata |= cnt << DISP_PINS;
                next_tick = tick + DELAY;
            }
            else if ((read_data & (1 << SUB_PIN)))
            {
                print("DOWN\n\r");
                cnt -= 1;
                outdata &= (0xFF);
                outdata |= cnt << DISP_PINS;
                next_tick = tick + DELAY;
            }
        }

        if (tick > next_blink)
        {
            outdata ^= (1 << BLINKY_PIN);
            
            if ((read_data & (1 << BLINKY_PIN)))
            {
                next_blink = tick + DELAY_LARGE;
            }
            else
            {
                next_blink = tick + DELAY_SMALL;
            }
        }

        XGpio_DiscreteWrite(&gpio_inst, LED_CHANNEL, outdata);

        usleep(1000);
        tick += 1;
    }

    cleanup_platform();
    return 0;
}
