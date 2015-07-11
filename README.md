# stm32lazarustemplate
copy the content of the folder in the ~/.lazarus_template
it should be available under the template form in lazarus.
Please be aware that You need to define a name and a directory when opening the new project.

This template contains:
- compiler settings for stm32f103 32bit cpu for both debug and release
- some ready to use units for simple periphery such as timer , serial, spi, lcd, etc....
- script for debug (only gdb-tui) through openocd
- the unit Arduino_compat.pas which aims to translates the Arduino environment to freepascal, 
  before to say "Shame!!!" consider that this helps a lot to port tons of library (as I did with ssd1306 graphic lcd)  
this is the base for all my new project based on this microcontroller under lazarus/freepascal

THIS IS NOT YET FINISHED, I'M A HOBBYIST PROGRAMMER SO DON'T EXPECT HIGH QUALITY INDUSTRIAL GRADE CODE 

