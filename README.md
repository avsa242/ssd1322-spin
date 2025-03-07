# ssd1322-spin
--------------

This is a P8X32A/Propeller, P2X8C4M64P/Propeller 2 driver object for SSD1322 OLED displays.

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.


## Salient Features

* SPI connection at 20MHz (P1), 20MHz+ (P2)
* Integration with generic graphics library
* Set display contrast and master current scaling
* Set number of displayed lines
* Set starting display line
* Set panel-specific display offset
* Set draw area for subsequent drawing operations
* Enable display mirroring (H, V)
* Enable display power/sleep
* Display mirroring (horizontal, vertical)
* Set display clock frequency, divider
* Swap pixel data nibble order
* Set GPIO 0, 1 state
* Set Vdd regulator internal or external
* Set Vsl internal/external reference
* Set low greyscale level quality
* Set timings: phase 1, 2, 3 period
* Set Vcom voltage reference level
* Set visibility mode (all pixels off/on, normal display, inverted display)
* Set partial (vertical) display area
* Pixel-doubled (horizontal; 2 display segment drive per pixel) support


## Requirements

P1/SPIN1:
* spin-standard-library
* graphics.common.spinh (provided by the spin-standard-library)


P2/SPIN2:
* p2-spin-standard-library
* graphics.common.spin2h (provided by the p2-spin-standard-library)


## Compiler Compatibility

| Processor | Language | Compiler               | Backend      | Status                |
|-----------|----------|------------------------|--------------|-----------------------|
| P1        | SPIN1    | FlexSpin (6.9.4)       | Bytecode     | OK                    |
| P1        | SPIN1    | FlexSpin (6.9.4)       | Native/PASM  | OK                    |
| P2        | SPIN2    | FlexSpin (6.9.4)       | NuCode       | Runtime issues        |
| P2        | SPIN2    | FlexSpin (6.9.4)       | Native/PASM2 | OK                    |

(other versions or toolchains not listed are __not supported__, and _may or may not_ work)


## Hardware Compatibility

* Tested with Newhaven Display 3.12" 256x64, NHD-3.12-25664UCW2
* Tested with Newhaven Display 2.7" 128x64, NHD-2.7-12864WDx3M (H pixel-doubled)


## Limitations

* Pixel-doubled display refresh is _slow_ on the P1; PASM build is recommended

