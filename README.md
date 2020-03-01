# stm32lazarustemplate
copy the content of the folder in the ~/.lazarus_template
then it will be available in the template form in lazarus.

Please be aware that You need to define a name and a directory when opening the new project.

In the main.pas unit You get setup and loop procedures (who said Arduino?)

In the project_name.lpr You get the main clock setup, the gpio setup and systick interrupt handler procedure.

This template contains:
- compiler settings for stm32f103 32bit cpu for both debug and release (you have to adjust units folder)
- some ready to use units for simple periphery such as timer , serial, spi, lcd, etc....
- script for debug (only gdb-tui) through openocd
- the unit Arduino_compat.pas which aims to translates the Arduino environment to freepascal, 
  before to say "Shame!!!" consider that this helps a lot to port tons of library (as I did with ssd1306 graphic lcd)  
this is the base for all my new project based on this microcontroller under lazarus/freepascal

THIS IS NOT YET FINISHED, I'M A HOBBYIST PROGRAMMER SO DON'T EXPECT HIGH QUALITY INDUSTRIAL GRADE CODE.


To Do:
- write down a tutorial/howto
- menu manager
- finish ssd1306spi unit (currently it does only basic text)
- hardware i2c
- eeprom emulation in flash
- improve/complete stm32f103fw unit
- usb stack for HID/serial/
- a way to use integrated debugger.......seems a lost war.....

credits: a lot!
the whole Arduino community
Jeppe and the fpc team which created a way to use my favourite programming language in the embedded world
Roger Clark for his port of libmaple to Arduino IDE
Deviation team who inspired me on the rc radio

