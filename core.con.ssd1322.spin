{
    --------------------------------------------
    Filename: core.con.ssd1322.spin
    Author: Jesse Burt
    Description: SSD1322-specific constants
    Copyright (c) 2024
    Started Jul 17, 2023
    Updated Jan 15, 2024
    See end of file for terms of use.
    --------------------------------------------
}

CON

' SPI Configuration
    SPI_MAX_FREQ        = 10_000_000            ' device max SPI bus freq
    SPI_MODE            = 0                     ' 0..3
    T_POR               = 1_000                 ' startup time (usecs)
    T_RES               = 100


{ Registers/commands }
    ENA_GRAYSCALE_TBL   = $00
    SET_COL_ADDR        = $15
    WR_RAM              = $5c
    RD_RAM              = $5d
    SET_ROW_ADDR        = $75

    SET_REMAP           = $a0
    SET_REMAP_MASK_A    = $37
    SET_REMAP_MASK_B    = $11
        { 1st parameter - A }
        COMSPLIT        = 5
        COMSPLIT_CLR    = (1 << COMSPLIT) ^ SET_REMAP_MASK_A
        COM_REMAP       = 4
        COMREMAP_CLR    = (1 << COM_REMAP) ^ SET_REMAP_MASK_A
        NIBB_REMAP      = 2
        NIBB_REMAP_SET  = (1 << NIBB_REMAP)
        NIBB_REMAP_CLR  = NIBB_REMAP_SET ^ SET_REMAP_MASK_A
        SEG_REMAP       = 1
        SEGREMAP_CLR    = (1 << SEG_REMAP) ^ SET_REMAP_MASK_A
        ADDR_INC        = 0
        ADDRINC_CLR     = 1 ^ SET_REMAP_MASK_A
        { 2nd parameter - B }
        DUAL_COM        = 4
        DUAL_COM_CLR    = (1 << DUAL_COM) ^ SET_REMAP_MASK_B

    SET_DISP_ST_LINE    = $a1
    SET_DISP_OFFS       = $a2

    SET_DISP_MODE_OFF   = $a4
    SET_DISP_MODE_ON    = $a5
    SET_DISP_MODE_NORM  = $a6
    SET_DISP_MODE_INV   = $a7

    ENA_PARTIAL_DISP    = $a8
    DIS_PARTIAL_DISP    = $a9

    FUNC_SEL            = $ab
        FUNC_SEL_MASK   = $01
        VDD_EXT         = 0
        VDD_INT         = 1

    SLEEP_ON            = $ae
    DISP_OFF            = SLEEP_ON
    SLEEP_OFF           = $af
    DISP_ON             = SLEEP_OFF

    SET_PHASE_LEN       = $b1
    PRECHG_MASK         = $FF
        PHASE2          = 4
        PHASE1          = 0
        PHASE2_BITS     = %1111
        PHASE1_BITS     = %1111
        PHASE2_CLR      = (PHASE2_BITS << PHASE2) ^ PRECHG_MASK
        PHASE1_CLR      = PHASE1_BITS ^ PRECHG_MASK

    SET_CLKDIV_OSCFREQ  = $b3
    CLKDIV_MASK         = $FF
        FOSCFREQ        = 4
        CLK_DIV         = 0
        FOSCFREQ_BITS   = %1111
        CLK_DIV_BITS    = %1111
        FOSCFREQ_CLR    = (FOSCFREQ_BITS << FOSCFREQ) ^ CLKDIV_MASK
        CLK_DIV_CLR     = CLK_DIV_BITS ^ CLKDIV_MASK

    DISP_ENH_A          = $b4

    SET_GPIO            = $b5
    SETGPIO_MASK        = $0F
        GPIO1           = 2
        GPIO0           = 0
        GPIO1_BITS      = %11
        GPIO0_BITS      = %11
        GPIO1_CLR       = (GPIO1_BITS << GPIO1) ^ SETGPIO_MASK
        GPIO0_CLR       = GPIO0_BITS ^ SETGPIO_MASK

    SET_SEC_PRECHG_PER  = $b6
    SET_GRAYSCALE_TBL   = $b8
    DEF_LINEAR_GRAY     = $b9
    SET_PRECHG_VOLT     = $bb
    SET_VCOMH           = $be
    SET_CONTR_CURR      = $c1
    MAST_CURR_CTRL      = $c7
    SET_MUX_RATIO       = $ca
    DISP_ENH_B          = $d1
    SET_CMD_LOCK        = $fd

PUB null()
' This is not a top-level object

DAT
{
Copyright 2024 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}

