{
----------------------------------------------------------------------------------------------------
    Filename:       display.oled.ssd1322.spin
    Description:    Driver for SSD1322 OLED displays
    Author:         Jesse Burt
    Started:        Jul 17, 2023
    Updated:        Feb 11, 2025
    Copyright (c) 2025 - See end of file for terms of use.
----------------------------------------------------------------------------------------------------
}

#define MEMMV_NATIVE bytemove

CON

' -- Default I/O configuration (can be overridden by parent object)
    WIDTH       = 256
    HEIGHT      = 64

    CS          = 0
    SCK         = 1
    MOSI        = 2
    DC          = 3
    RST         = -1
    SPI_FREQ    = 1_000_000                     ' not currently used
'--

    BPP         = 4                             ' bits per pixel/color depth of the display
    BYTESPERPX  = 1 #> (BPP/8)                  ' limit to minimum of 1
    BPPDIV      = BYTESPERPX #> (8 / BPP)       ' limit to range BYTESPERPX .. (8/BPP)
    BUFF_SZ     = (WIDTH * HEIGHT) / BPPDIV
    MAX_COLOR   = (1 << BPP)-1
    XMAX        = WIDTH-1
    YMAX        = HEIGHT-1
    CENTERX     = WIDTH/2
    CENTERY     = HEIGHT/2

    CMD         = 0
    DATA        = 1


OBJ

    core:   "core.con.ssd1322"                  ' hardware-specific constants
    spi:    "com.spi.20mhz"                     ' SPI engine
    time:   "time"                              ' timekeeping methods

VAR

    word _offs_x, _offs_y                       ' display panel-specific offsets
    byte _framebuffer[BUFF_SZ]                  ' display/framebuffer
    byte _CS, _DC, _RST

    ' shadow registers
    byte _remap[2]                              ' set re-map and dual COM line mode
    byte _clkdiv


PUB start(): s
' Start the driver using default I/O settings and internal framebuffer
    return startx(CS, SCK, MOSI, DC, RST, SPI_FREQ, WIDTH, HEIGHT, @_framebuffer)


PUB startx(CS_PIN, SCK_PIN, MOSI_PIN, DC_PIN, RES_PIN, SCK_FREQ, DISP_WID, DISP_HT, p_fb=0): s
' Start the driver using custom I/O settings and (optionally) external framebuffer
'   CS_PIN:             Chip Select, 0..31
'   SCK_PIN:            Serial Clock, 0..31
'   MOSI_PIN:           Master-Out/Slave-In, 0..31
'   DC_PIN:             Data/Command (sometimes known as RS or Register Select), 0..31
'   RES_PIN:            Reset (set to -1 if not used), 0..31
'   SCK_FREQ:           SPI bus speed (not currently used)
'   DISP_WID, DISP_HT:  display dimensions, in pixels
'   p_fb:               (optional) pointer to display buffer (leave blank or set to 0 to use
'                           the driver's internal framebuffer)
   if ( s := spi.init(SCK_PIN, MOSI_PIN, -1, core.SPI_MODE) )
        time.usleep(core.T_POR)
        outa[CS_PIN] := 1
        outa[DC_PIN] := 1
        dira[CS_PIN] := 1
        dira[DC_PIN] := 1
        _CS := CS_PIN
        _DC := DC_PIN
        _RST := RES_PIN
        reset()
        defaults()
        set_dims(DISP_WID, DISP_HT)
        set_address(p_fb)
        return s
    return FALSE


PUB stop()
' Stop the driver and reclaim/clear memory used
    bytefill(@_framebuffer, 0, BUFF_SZ)
    bytefill(@_CS, 0, 3)
    spi.deinit()


PUB defaults()
' Factory default settings
    _remap := $00
    command(core.SET_CMD_LOCK, $12, 1)
    powered(false)
    clk_freq(1876)
    clk_div(1)
    disp_lines(64)
    command(core.SET_DISP_OFFS, $00, 1)
    disp_start_line(0)
    mirror_h(false)
    mirror_v(false)
    nibble_remap(false)
    command(core.SET_GPIO, $00, 1)
    command(core.FUNC_SEL, $01, 1)
    command(core.DISP_ENH_A, $a0 | ($b5 << 8), 2)'$fd)
    contrast(127)
    command(core.MAST_CURR_CTRL, $0f, 1)
    command(core.DEF_LINEAR_GRAY)
    command(core.SET_PHASE_LEN, $e2, 1)
    command(core.DISP_ENH_B, $a2 | ($20 << 8), 2)'$82, $20)
    command(core.SET_PRECHG_VOLT, $1f, 1)
    command(core.SET_SEC_PRECHG_PER, $08, 1)
    command(core.SET_VCOMH, $07, 1)
    command(core.SET_DISP_MODE_NORM)
    command(core.DIS_PARTIAL_DISP)
    clear()
    show()
    powered(true)


PUB preset_newhaven_3p12_256x64()
' Preset settings: Newhaven NHD-3.12-25664UCW2
'   256x64
'   Panel offsets: 28, 0
    _offs_x := 28
    _offs_y := 0
    _remap := (1 << core.COM_REMAP) | (1 << core.NIBB_REMAP)
    disp_lines(64)
    command(core.SET_REMAP, _remap, 2)

PUB clear() | y, x'xxx need GFX_DIRECT case
' Clear the display
    bytefill(@_framebuffer, 0, BUFF_SZ)


PUB clk_div(d)
' Set clock frequency divider used by the display controller
'   Valid values: 1..16 (clamped to range)
    _clkdiv := ( (_clkdiv & core.CLK_DIV_CLR) | ( (1 #> d <# 16)-1) )
    command(core.SET_CLKDIV_OSCFREQ, _clkdiv, 1)


PUB clk_freq(f)
' Set display internal oscillator frequency, in kHz
'   Valid values: 1750..2130 (clamped to range; POR: 1876)
'   NOTE: Range is interpolated, based on the datasheet min/max values and
'   number of steps, so actual clock frequency may not be accurate.
'   Value set will be rounded to the nearest 25.33kHz
    f := ( ( ( ( (1750 #> f <# 2130) - 1750) * 100) / 25_33) << core.FOSCFREQ)
    _clkdiv := ( (_clkdiv & core.FOSCFREQ_CLR) | f)
    command(core.SET_CLKDIV_OSCFREQ, _clkdiv, 1)


PUB contrast(c)
' Set display contrast
'   c:  0..255
    command(core.SET_CONTR_CURR, c, 1)


PUB disp_lines(l)
' Set total number of display lines
'   l:  16..128 (clamped to range)
    command(core.SET_MUX_RATIO, 15 #> (l-1) <# 127, 1)


PUB disp_start_line(l)
' Set display start line
'   Valid values: 0..127 (clamped to range; POR: 0)
    command(core.SET_DISP_ST_LINE, 0 #> l <# 127, 1)


PUB disp_offset(x, y)
' Set display panel-specific offset
'   x, y:   offset in pixels
    _offs_x := x
    _offs_y := y


PUB draw_area(sx, sy, ex, ey)
' Set display position for next drawing operation
    command(core.SET_COL_ADDR, (_offs_x+sx) | ( (_offs_x+ex) << 8), 2)
    command(core.SET_ROW_ADDR, (_offs_y+sy) | ( (_offs_y+ey) << 8), 2)


PUB mirror_h(m)
' Mirror the display horizontally
'   m:
'       non-zero values:    enable
'       zero:               disable
    _remap[0] := (_remap[0] & core.SEGREMAP_CLR) | ( (m <> 0) & 1) << core.SEG_REMAP
    command(core.SET_REMAP, _remap[0] | (_remap[1] << 8), 2)


PUB mirror_v(m)
' Mirror the display vertically
'   m:
'       non-zero values:    enable
'       zero:               disable
    _remap[0] := (_remap[0] & core.COMREMAP_CLR) | ( (m <> 0) & 1) << core.COM_REMAP
    command(core.SET_REMAP, _remap[0] | (_remap[1] << 8), 2)


PUB nibble_remap(r)
' Remap pixel data nibbles (swap upper/lower 4 bits)
'   r:
'       non-zero values:    enable
'       zero:               disable (default)
    _remap[0] := (_remap[0] & core.NIBB_REMAP_CLR) | ( (r <> 0) & 1) << core.NIBB_REMAP
    command(core.SET_REMAP, _remap[0] | (_remap[1] << 8), 2)


PUB plot(x, y, c) | mask, p, b1'xxx need GFX_DIRECT case
' Draw a single pixel
'   (x, y): screen coordinates
'   c:      color
    if ( (x < 0) or (x > _disp_xmax) or (y < 0) or (y > _disp_ymax) )
        return
    if ( x.[0] )                                ' for odd-numbered columns,
        mask := c                               '   put the color data into the lower nibble
    else                                        ' for even-numbered columns,
        mask := (c << 4)                        '   put the color data into the upper nibble

'    mask := (x.[0]) ? c : (c << 4)'xxx alternate; evaluate timing & size

    p := @_framebuffer + ( (x >> 1) + (y * _bytesperln) )
    b1 := byte[p] & ( (x.[0]) ? $f0 : $0f )     ' grab pixel data from the upper or lower nibble,
                                                '   depending on whether x is even or odd

    byte[p] := b1 | mask


#ifndef GFX_DIRECT
PUB point(x, y): c
' Get the currently set color of a pixel
'   (x, y): screen coordinates
'   Returns: 4-bit color
    { find pixel address within framebuffer }
    c := byte[@_framebuffer[(x >> 1) + (y * (_disp_width / 2))]]
    if ( x.[0] )                                ' for odd-numbered columns,
        c &= $0f                                '   get the lower nibble
    else                                        ' for even-numbered columns,
        c >>= 4                                 '   get the upper nibble
#endif


PUB powered(p)
' Enable display power
'   p:
'       non-zero values:    on
'       false (0):          off
    if ( p )
        command(core.SLEEP_OFF)
    else
        command(core.SLEEP_ON)


PUB reset()
' Reset the device
    if ( lookdown(_RST: 0..31) )
        outa[_RST] := 1
        dira[_RST] := 1
        outa[_RST] := 0
#ifdef __OUTPUT_ASM__
        time.usleep(core.T_RES)
#endif
        outa[_RST] := 1


PUB show()
' Show the display buffer on the display
    command(core.SET_COL_ADDR, _offs_x | ( (_offs_x+(_disp_xmax/4) ) << 8), 2)
    command(core.SET_ROW_ADDR, _offs_y | (_disp_ymax << 8), 2)
    command(core.WR_RAM)
    outa[_DC] := DATA
    outa[_CS] := 0
        spi.wrblock_lsbf(@_framebuffer, BUFF_SZ)
    outa[_CS] := 1


PRI command(c, v=0, l=0)
' Issue simple command, no parameters
    outa[_DC] := CMD
    outa[_CS] := 0
        spi.wr_byte(c)
        if ( l > 0 )
            outa[_DC] := DATA
            spi.wrblock_lsbf(@v, l)
    outa[_CS] := 1


#ifndef GFX_DIRECT
PRI memfill(xs, ys, val, count)
' Fill region of display buffer memory
'   xs, ys: Start of region
'   val: Color
'   count: Number of consecutive memory locations to write
    bytefill(   _ptr_drawbuffer + (xs >> 1) + (ys * (_disp_width/2)), ...
                val | (val << 4), ...
                count / 2 )
#endif

#include "graphics.common.spinh"

DAT
{
Copyright 2025 Jesse Burt

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

