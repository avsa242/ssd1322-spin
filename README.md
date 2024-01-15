# ssd1322-spin
--------------

This is a P8X32A/Propeller, P2X8C4M64P/Propeller 2 driver object for SSD1322 OLED displays.

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.


## Salient Features

* SPI connection at 20MHz (P1)
* Integration with generic graphics library


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
| P1	    | SPIN1    | FlexSpin (6.8.0)	| Bytecode     | OK                    |
| P1	    | SPIN1    | FlexSpin (6.8.0)       | Native/PASM  | OK                    |
| P2	    | SPIN2    | FlexSpin (6.8.0)       | NuCode       | Not yet implemented   |
| P2        | SPIN2    | FlexSpin (6.8.0)       | Native/PASM2 | Not yet implemented   |

(other versions or toolchains not listed are __not supported__, and _may or may not_ work)


## Hardware Compatibility

* Tested with Newhaven Display 3.12" 256x64


## Limitations

* Very early in development - may malfunction, or outright fail to build

