{
    --------------------------------------------
    Filename: SSD1322-Demo.spin
    Author: Jesse Burt
    Description: Demo of the SSD1322 driver
    Copyright (c) 2024
    Started Jul 17, 2023
    Updated Jan 15, 2024
    See end of file for terms of use.
    --------------------------------------------
}

CON

    _clkmode    = cfg#_clkmode
    _xinfreq    = cfg#_xinfreq

' -- User-defined constants
    SER_BAUD    = 115_200
' --

OBJ

    cfg:    "boardcfg.flip"
    disp:   "display.oled.ssd1322" | CS=0, SCK=1, MOSI=2, DC=3, RST=4, WIDTH=256, HEIGHT=64

PUB setup() | i

    ser.start(SER_BAUD)
    time.msleep(30)
    ser.clear()
    ser.strln(@"Serial terminal started")

    if ( disp.start() )
        ser.strln(@"SSD1322 driver started")
        disp.set_font(fnt.ptr(), fnt.setup())
        disp.char_attrs(disp.TERMINAL)
    else
        ser.strln(@"SSD1322 driver failed to start - halting")
        repeat

    disp.defaults()

    _time := 5_000                              ' runtime of each demo (ms)

    demo()

DAT

    _drv_name   byte "SSD1322", 0

#include "GFXDemo-common.spinh"

CON

    WIDTH   = disp.WIDTH
    HEIGHT  = disp.HEIGHT

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

