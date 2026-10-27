# Primary references

Consulted 2026-10-27. Numeric circuit examples, pin allocation, firmware protocol
and operating thresholds in this folder are our proposed design, not vendor
reference designs or guaranteed instrument performance.

| Reference | Use |
| --- | --- |
| [ST DS5319: STM32F103x8/xB](https://www.st.com/resource/en/datasheet/stm32f103c8.pdf) | LQFP48 pinout, MCU capabilities and electrical constraints; Figure 8 / pin table, ADC and USB characteristics |
| [ST AN2586: STM32F10xxx hardware](https://www.st.com/resource/en/application_note/CD00164185.pdf) | Supply, reset, clock, boot and SWD support |
| [ST AN2606: System-memory boot mode](https://www.st.com/resource/en/application_note/an2606-stm32microcontroller-system-memory-boot-mode-stmicroelectronics.pdf) | STM32F10xxx section / Table 45: default USART1 pins and factory bootloader; Pattern 1: BOOT0 high, BOOT1 low |
| [ST AN3155: USART bootloader protocol](https://www.st.com/resource/en/application_note/cd00264342-usart-protocol-used-in-the-stm32-bootloader-stmicroelectronics.pdf) | Serial download framing, autobaud and commands |
| [ST AN4879: USB hardware](https://www.st.com/resource/en/application_note/dm00296349-usb-hardware-and-pcb-guidelines-using-stm32-mcus-stmicroelectronics.pdf) | External D+ pull-up and USB board guidance |
| [ST RM0008: F1 reference manual](https://www.st.com/resource/en/reference_manual/cd00171190-stm32f101xx-stm32f102xx-stm32f103xx-stm32f105xx-and-stm32f107xx-advanced-armbased-32bit-mcus-stmicroelectronics.pdf) | Firmware implementation reference; full register configuration remains to be implemented and checked |
| [TI SCHS209D: CD74HC4067](https://www.ti.com/lit/ds/symlink/cd74hc4067.pdf) | Switch pinout, enable polarity, analogue range and resistance limitations |
| [Microchip DS20001826F: MCP1700](https://ww1.microchip.com/downloads/aemDocuments/documents/APID/ProductDocuments/DataSheets/MCP1700-Data-Sheet-20001826F.pdf) | SOT23 regulator pinout and capacitor requirements |
| [ST DS4260: USBLC6-2](https://www.st.com/resource/en/datasheet/usblc6-2.pdf) | USB ESD device pinout and placement |
| [Nexperia BC856/BC857/BC858](https://assets.nexperia.com/documents/data-sheet/BC856_BC857_BC858.pdf) | BC857B PNP transistor pinout |

The exact crystal, Micro-B connector and backplane contact
footprint remain purchasing/mechanical selections. Their individual datasheets
must be checked before entering the final CAD symbols and footprints. No price
or stock guarantee is attached to this preliminary BOM.
