/*
 * (C) Copyright 2007-2012
 * Allwinner Technology Co., Ltd. <www.allwinnertech.com>
 * Tom Cubie <tangliang@allwinnertech.com>
 *
 * Early uart print for debugging.
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>
#include <asm/io.h>
#include <asm/arch/cpu.h>
#include <asm/arch/early_print.h>
#include <asm/arch/gpio.h>
#include <asm/arch/sys_proto.h>

static int uart_initialized = 0;

#define UART	CONFIG_CONS_INDEX-1
void uart_init(void) {

	/* select dll dlh */
	writel(UART_LCR_DLAB, UART_LCR(UART));
	/* set baudrate */
	writel(0, UART_DLH(UART));
	writel(BAUD_115200, UART_DLL(UART));
	/* set line control */
	writel(LC_8_N_1, UART_LCR(UART));

	uart_initialized = 1;
}

#define TX_READY (readl(UART_LSR(UART)) & UART_LSR_TEMT)

void uart_putc(char c) {

	while (!TX_READY)
		;
	writel(c, UART_THR(UART));
}

void uart_puts(const char *s) {

	while (*s)
		uart_putc(*s++);
}


