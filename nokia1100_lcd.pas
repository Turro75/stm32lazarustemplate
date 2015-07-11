{
    NOKIA 1100 Screen
    This is the driver of the LCD based on code by spiralbrain
    modified by:
    name:kuldeep singh dhaka
    email:kuldeepdhaka9@gmail.com
    date:17 May 2012
    Source: http://sunbizhosting.com/~spiral/

    Driver For  Arduino Dueminalove Atmega328
    Interfacing with the Nokia 1100 LCD, PCF8814 ( 96X65 )

    licence: gpl-v3 http://www.gnu.org/licenses/gpl.html [i just want to make its source available to every one]
   }
  {
    PIN configuration:

    to know the pins, view the screen from front, pin 1 is on right side
    read : http://www.circuitvalley.com/2011/09/nokia-1100-lcd-interfacing-with.html
    example
      |-----------------|
      |  screen         |
      |    front        |
      |_________________|
       | | | | | | | | |
       1 2 3 4 5 6 7 8 9

       PIN 1: XRES         Black
       PIN 2: XCS          White
       PIN 3: GND          Gray
       PIN 4: SDA          Violet
       PIN 5: SCLK         Green
       PIN 6: VDDI         Blue
       PIN 7: VDD          Blue
       PIN 8: LED+         Blue
       PIN 9: Unused

     WE shorted PIN 6,7,8
    the lcd needs 3v logic therefore we are using potentiometers
   }




unit Nokia1100_LCD;

interface

uses
  Arduino_compat;

const

  LCD_CONTRAST = $05;
  {
    contain the screen height and width in pixel
   }
  SCREEN_HEIGHT = 65;
  SCREEN_WIDTH = 96;
  {
    flags used to understand by lcd if the bits is taken as command or store in ram
   }
  FLAG_CMD = LOW;
  FLAG_DATA = HIGH;
  {
    some constants that will be ored with command to effect
     s ON : turn on the command
      OFF : turn off the command
      DISPLAY: turn display on/of used with LCD_MODE only, (LCD_MODE|DISPLAY|ON/OFF)
      ALL : turn on all , only used with LCD_MODE , (LCD_MODE|ALL|ON/OFF) use off for normal display
     tww INVERT : invert pixels, only used with LCD_MODE , (LCD_MODE|INVERT|ON/OFF) , it bring lcd into normal form use off
    *note: you can use (LCD_MODE|ALL/INVERT|OFF)  to bring lcd into normal mode
   }
  D_ON = $01;
  D_OFF = $00;
  ALL = $04;
  INVERT = $06;
  DISPLAY = $0E;
  {
    Command list of list
          LCD_NOP                                 : no operation
    LCD_MODE        : lcd  mode, LCD_MODE|(ALL/INVERT/DISPLAY|ON/OFF)
    LCD_VOB_MSB        : use LCD_VOB_MSB|0x04 ,the value after | is a mystery,dont mess(previos notice)
    LCD_VOB_LSB        : use LCD_VOB_LSB|(contrast value,0x00 to 0x1F)
    LCD_CHARGE_PUMP_ON     : read the datasheet , i couldn't understand
                  voltage muliplication          value
                       X2              0x00
                     X3              0x01
                     X4              0x02
                     X5              0x03
    LCD_RAM_ADDR_MODE    : use LCD_RAM_ADDR_MODE|(conditon ,OFF/ON),write in RAM,
                   OFF : write horizontally (by default)
                   ON : write vertically
    LCD_CHANGE_ROW_LSB        : accessed by LCD_ROW_LSB|(b3 b2 b1 b0), last four bits of the address
    LCD_CHANGE_ROW_MSB        : accessed by LCD_ROW_MSB|(b6 b5 b4),first 3 bits of the address; alias is 0x18
    LCD_CHANGE_COL          : move to col,LCD_COL|(b2 b1 b0)
    LCD_MIRROR_Y      : mirror on y axis , use(LCD_MIRROR_Y| condition 0x08 or OFF)
                  turn on/enable mirroring, conditon->0x08 , dont use ON because its 0x01
                  turn off/disable mirroring, conditon->OFF
    LCD_MIRROR_X      : turn on mirroring on x axis . this is a speical instruction &
                                            i couldt found|dont exists reset counter; its alias is 0xA0,didnt worked,
                                            and datasheet says , NOP: MX is pad selected?
    LCD_EXT_OSC        : use a external oscillator (LCD_EXT_OSC|ON / OFF)
    LCD_SOFT_RESET      : internal or software reset
   * special instruction: use 0x08 not ON for enabling LCD_MIRROR_X
   }
  LCD_NOP = $E3;
  LCD_MODE = $A0;
  LCD_VOB_MSB = $20;
  LCD_VOB_LSB = $80;
  LCD_CHARGE_PUMP_ON = $2F;
  LCD_RAM_ADDR_MODE = $AA;
  LCD_CHANGE_ROW_LSB = $00;
  LCD_CHANGE_ROW_MSB = $10;
  LCD_CHANGE_COL = $B0;
  LCD_MIRROR_Y = $C0;
  LCD_MIRROR_X = $A0;
  LCD_EXT_OSC = $3A;
  LCD_SOFT_RESET = $E2;
  CHAR_WIDTH = 6;
  CHAR_HEIGHT = 8;

  ASCII: array [$20..$7f, 1..CHAR_WIDTH] of byte = (
    ($00, $00, $00, $00, $00, $00) // 20
    , ($00, $00, $00, $5f, $00, $00) // 21 !
    , ($00, $00, $07, $00, $07, $00) // 22 "
    , ($00, $14, $7f, $14, $7f, $14) // 23 #
    , ($00, $24, $2a, $7f, $2a, $12) // 24 $
    , ($00, $23, $13, $08, $64, $62) // 25 %
    , ($00, $36, $49, $55, $22, $50) // 26 &
    , ($00, $00, $05, $03, $00, $00) // 27 '
    , ($00, $00, $1c, $22, $41, $00) // 28 (
    , ($00, $00, $41, $22, $1c, $00) // 29 )
    , ($00, $14, $08, $3e, $08, $14) // 2a *
    , ($00, $08, $08, $3e, $08, $08) // 2b +
    , ($00, $00, $50, $30, $00, $00) // 2c ,
    , ($00, $08, $08, $08, $08, $08) // 2d -
    , ($00, $00, $60, $60, $00, $00) // 2e .
    , ($00, $20, $10, $08, $04, $02) // 2f /
    , ($00, $3e, $51, $49, $45, $3e) // 30 0
    , ($00, $00, $42, $7f, $40, $00) // 31 1
    , ($00, $42, $61, $51, $49, $46) // 32 2
    , ($00, $21, $41, $45, $4b, $31) // 33 3
    , ($00, $18, $14, $12, $7f, $10) // 34 4
    , ($00, $27, $45, $45, $45, $39) // 35 5
    , ($00, $3c, $4a, $49, $49, $30) // 36 6
    , ($00, $01, $71, $09, $05, $03) // 37 7
    , ($00, $36, $49, $49, $49, $36) // 38 8
    , ($00, $06, $49, $49, $29, $1e) // 39 9
    , ($00, $00, $36, $36, $00, $00) // 3a :
    , ($00, $00, $56, $36, $00, $00) // 3b ;
    , ($00, $08, $14, $22, $41, $00) // 3c <
    , ($00, $14, $14, $14, $14, $14) // 3d =
    , ($00, $00, $41, $22, $14, $08) // 3e >
    , ($00, $02, $01, $51, $09, $06) // 3f ?
    , ($00, $32, $49, $79, $41, $3e) // 40 @
    , ($00, $7e, $11, $11, $11, $7e) // 41 A
    , ($00, $7f, $49, $49, $49, $36) // 42 B
    , ($00, $3e, $41, $41, $41, $22) // 43 C
    , ($00, $7f, $41, $41, $22, $1c) // 44 D
    , ($00, $7f, $49, $49, $49, $41) // 45 E
    , ($00, $7f, $09, $09, $09, $01) // 46 F
    , ($00, $3e, $41, $49, $49, $7a) // 47 G
    , ($00, $7f, $08, $08, $08, $7f) // 48 H
    , ($00, $00, $41, $7f, $41, $00) // 49 I
    , ($00, $20, $40, $41, $3f, $01) // 4a J
    , ($00, $7f, $08, $14, $22, $41) // 4b K
    , ($00, $7f, $40, $40, $40, $40) // 4c L
    , ($00, $7f, $02, $0c, $02, $7f) // 4d M
    , ($00, $7f, $04, $08, $10, $7f) // 4e N
    , ($00, $3e, $41, $41, $41, $3e) // 4f O
    , ($00, $7f, $09, $09, $09, $06) // 50 P
    , ($00, $3e, $41, $51, $21, $5e) // 51 Q
    , ($00, $7f, $09, $19, $29, $46) // 52 R
    , ($00, $46, $49, $49, $49, $31) // 53 S
    , ($00, $01, $01, $7f, $01, $01) // 54 T
    , ($00, $3f, $40, $40, $40, $3f) // 55 U
    , ($00, $1f, $20, $40, $20, $1f) // 56 V
    , ($00, $3f, $40, $38, $40, $3f) // 57 W
    , ($00, $63, $14, $08, $14, $63) // 58 X
    , ($00, $07, $08, $70, $08, $07) // 59 Y
    , ($00, $61, $51, $49, $45, $43) // 5a Z
    , ($00, $00, $7f, $41, $41, $00) // 5b [
    , ($00, $02, $04, $08, $10, $20) // 5c ¥
    , ($00, $00, $41, $41, $7f, $00) // 5d ]
    , ($00, $04, $02, $01, $02, $04) // 5e ^
    , ($00, $40, $40, $40, $40, $40) // 5f _
    , ($00, $00, $01, $02, $04, $00) // 60 `
    , ($00, $20, $54, $54, $54, $78) // 61 a
    , ($00, $7f, $48, $44, $44, $38) // 62 b
    , ($00, $38, $44, $44, $44, $20) // 63 c
    , ($00, $38, $44, $44, $48, $7f) // 64 d
    , ($00, $38, $54, $54, $54, $18) // 65 e
    , ($00, $08, $7e, $09, $01, $02) // 66 f
    , ($00, $0c, $52, $52, $52, $3e) // 67 g
    , ($00, $7f, $08, $04, $04, $78) // 68 h
    , ($00, $00, $44, $7d, $40, $00) // 69 i
    , ($00, $20, $40, $44, $3d, $00) // 6a j
    , ($00, $7f, $10, $28, $44, $00) // 6b k
    , ($00, $00, $41, $7f, $40, $00) // 6c l
    , ($00, $7c, $04, $18, $04, $78) // 6d m
    , ($00, $7c, $08, $04, $04, $78) // 6e n
    , ($00, $38, $44, $44, $44, $38) // 6f o
    , ($00, $7c, $14, $14, $14, $08) // 70 p
    , ($00, $08, $14, $14, $18, $7c) // 71 q
    , ($00, $7c, $08, $04, $04, $08) // 72 r
    , ($00, $48, $54, $54, $54, $20) // 73 s
    , ($00, $04, $3f, $44, $40, $20) // 74 t
    , ($00, $3c, $40, $40, $20, $7c) // 75 u
    , ($00, $1c, $20, $40, $20, $1c) // 76 v
    , ($00, $3c, $40, $30, $40, $3c) // 77 w
    , ($00, $44, $28, $10, $28, $44) // 78 x
    , ($00, $0c, $50, $50, $50, $3c) // 79 y
    , ($00, $44, $64, $54, $4c, $44) // 7a z
    , ($00, $00, $08, $36, $41, $00) // 7b (
    , ($00, $00, $00, $7f, $00, $00) // 7c |
    , ($00, $00, $41, $36, $08, $00) // 7d )
    , ($00, $10, $08, $08, $10, $08) // 7e ->
    , ($00, $78, $46, $41, $46, $78) // 7f <-
    );

type

  { TNokia1100LCD }

  TNokia1100LCD = class
  private
    LCD_PIN_SCE: board_pins;
    LCD_PIN_SDIN: board_pins;
    LCD_PIN_RESET: board_pins;
    LCD_PIN_SCLK: board_pins;


  public

    constructor Create(pinRESET, pinSCE, pinSDIN, pinSCLK: board_pins);
    destructor Destroy; override;
    procedure lcdString(str: string);
    procedure print(str:string);
    procedure lcdCharacter(ch: char);
    procedure lcdRow(addr: byte);
    procedure lcdCol(addr: byte);
    procedure lcdGotoyx(row: byte; col: byte);
    procedure setCursor(row: byte; col: byte);
    procedure lcdClear;
    procedure lcdRefresh;
    procedure lcdInit;
    procedure lcdWrite(dc: byte; Data: byte);
    procedure lcdAll;
    procedure lcdInvert;
    procedure lcdNormal;
    procedure lcdOffPartial;
    procedure lcdOff;
    procedure lcdOn;
    procedure lcdContrast(Value: byte);

  end;



implementation

{ TNokia1100LCD }



constructor TNokia1100LCD.Create(pinRESET, pinSCE, pinSDIN, pinSCLK: board_pins);
begin
  LCD_PIN_SCE := pinSCE;
  LCD_PIN_SDIN := pinSDIN;
  LCD_PIN_RESET := pinRESET;
  LCD_PIN_SCLK := pinSCLK;
  lcdInit;
end;

destructor TNokia1100LCD.Destroy;
begin
  inherited Destroy;
end;

procedure TNokia1100LCD.lcdString(str: string);
var
  index: byte;
begin
  for index := 1 to length(str) do
  begin
    lcdCharacter(str[index]);
  end;
end;

procedure TNokia1100LCD.print(str: string);
begin
     lcdString(str);
end;

procedure TNokia1100LCD.lcdCharacter(ch: char);
var
  index: byte;
begin
 {  /*
     LCD_CHARACTER():
       note:
         print character to lcd
       trick:
         CHARACTER - 0x20 is make is eligible for ascii array
         it print recursily CHAR_WIDTH no of times 8 bit to lcd
   */
   void lcd_character(char ch)}

  for index := 1 to CHAR_WIDTH do
    lcdWrite(FLAG_DATA, ASCII[byte(ch)][index]);

end;

procedure TNokia1100LCD.lcdRow(addr: byte);
begin
  {   /*
       LCD_ROW():
         note:
           set the x address or row number for lcd
           only 4 LSB's are send
           b7 | b6 | b5 | b4 | b3 | b2 | b1 | b0
                         |<-  only send  ->|
         tricks:
           LINE1:
             0x0F is used to remove the first 3 MSB's or only retain first 4 LSB's

     */
     void lcd_row(byte addr)}
  lcdWrite(FLAG_CMD, LCD_CHANGE_COL or (addr and $0F));
end;

procedure TNokia1100LCD.lcdCol(addr: byte);
begin
  {
     LCD_COL():
       note:
         set the X address or COLOUMN number for lcd
         it is send in two parts
           first the 4 LSB's
           second the 3 MSB's (exclude the 7 MSB)[first bit referenced as bit0]
           for example
             b7 | b6 | b5 | b4 | b3 | b2 | b1 | b0
                |<- 2nd CMD  ->|<-   1St CMD   ->|
       tricks:
                           since we are using horizontal addressing mode thats why we are multiplying character size
         LINE 1:
           0x0F is used to remove 3 MSB BITS
         LINE 2:
           ADDR>>4 is used to shift the 3 MSB to right so that they can be send[read datasheet for why?]
           0x07 is used to remove the 8Th bit (that is now at 4th place after shifting)
   */}
  addr := addr * CHAR_WIDTH;
  lcdWrite(FLAG_CMD, LCD_CHANGE_ROW_LSB or (addr and $0F));
  lcdWrite(FLAG_CMD, LCD_CHANGE_ROW_MSB or ((addr shr 4) and $07));
end;

procedure TNokia1100LCD.lcdGotoyx(row: byte; col: byte);
begin
  lcdRow(ROW);
  lcdCol(COL);
end;

procedure TNokia1100LCD.setCursor(row: byte; col: byte);
begin
     lcdRow(ROW);
     lcdCol(COL);
end;

procedure TNokia1100LCD.lcdClear;
var
  index: word;
begin
 {      /*
          LCD_CLEAR()
            note:
              every pixel is cleared by sending 0x00 for 864 times
              864 times because the their is a single pixel line at the last (65 pixel height)
        */
 }
  //*  date: 21/05/2012
  //  added lcd_gotoxy to reset at zero position
  //*/
  lcdGotoyx(0, 0);

  for index := 0 to 864 - 1 do
    lcdWrite(FLAG_DATA, $00);
  //*
  //  date: 21/05/2012
  //  added to wait a while after clearing lcd
  //*/
  delayMicroseconds(20000);

end;

procedure TNokia1100LCD.lcdRefresh;
begin
  {
            LCD_REFRESH()
              note:
                * you can or a 5 bit binary number with LCD_VOB_LSB to set contrast [see datasheet for more]
                  0x00 : lowest contrast
                  0x01 : heigher than 0x00
                  0x02 : heigher than 0x01
                  .
                  .
                  .
                  0x1F : heighest contrast
                * charge pump inbuild
                  i didnt understood it use here but in prevous code is was there so didnt want to mess
                *we have to reset the deivce beacuse it is required for initalisation [see datasheet]
          */
   }
  digitalWrite(LCD_PIN_RESET, LOW);
  // delayMicroseconds(1000);
  digitalWrite(LCD_PIN_RESET, HIGH);
  lcdWrite(FLAG_CMD, LCD_CHARGE_PUMP_ON);
  // (LCD_CONTRAST);['{14427589-9003-40AF-BA2B-F3CFC83FA080}']
  lcdOn;
end;

procedure TNokia1100LCD.lcdInit;
begin
  {
     LCD_INIT():
      note:
        this define how will the pins will be used
        for more reference also read LCD_REFRESH() & LCD_CLEAR()
  }
  pinMode(LCD_PIN_SCE, OUTPUT);
  pinMode(LCD_PIN_RESET, OUTPUT);
  pinMode(LCD_PIN_SDIN, OUTPUT);
  pinMode(LCD_PIN_SCLK, OUTPUT);
  digitalWrite(LCD_PIN_RESET, LOW);
  digitalWrite(LCD_PIN_SCE, HIGH);
  digitalWrite(LCD_PIN_SCLK, LOW);
  lcdRefresh;
  delayMicroseconds(200000);
  lcdClear;
end;

procedure TNokia1100LCD.lcdWrite(dc: byte; Data: byte);
begin
  {  LCD_WRITE()
    note:
      send/write data to LCD
    trick:
      dont mess with it, i have prevous comment are
      LINE 1:
        dc is sampled with the first rising SCLK edge
      LINE 2:
        LCD enable
      LINE 3:
        First rising SCLK edge
      LINE 5:
        SDIN is sampled at the rising edge of SCLK.
}

  digitalWrite(LCD_PIN_SDIN, dc);
  digitalWrite(LCD_PIN_SCE, LOW);
  digitalWrite(LCD_PIN_SCLK, HIGH);
  digitalWrite(LCD_PIN_SCLK, LOW);
  shiftOut(LCD_PIN_SDIN, LCD_PIN_SCLK, MSBFIRST, Data);
  digitalWrite(LCD_PIN_SCE, HIGH);
end;

procedure TNokia1100LCD.lcdAll;
begin
  {   /*
       start or re-initalise the lcd in all pixel mode
       see datasheet page number 29,table 11
     */
     void lcd_all()}
  lcdWrite(FLAG_CMD, LCD_MODE or DISPLAY or D_ON);
  lcdWrite(FLAG_CMD, LCD_MODE or ALL or D_ON);
end;

procedure TNokia1100LCD.lcdInvert;
begin
 {   /*
     start or re-initalise lcd in inverse vedio mode
     see datasheet page number 29,table 11
   */
   void lcd_invert()}
  lcdWrite(FLAG_CMD, LCD_MODE or DISPLAY or D_ON);
  lcdWrite(FLAG_CMD, LCD_MODE or ALL or D_OFF);
  lcdWrite(FLAG_CMD, LCD_MODE or INVERT or D_ON);
end;

procedure TNokia1100LCD.lcdNormal;
begin
        {   /*
             start or power on the lcd or power up
             see datasheet page number 29,table 11
           */
           void lcd_normal()}

  lcdWrite(FLAG_CMD, LCD_MODE or DISPLAY or D_ON);
  lcdWrite(FLAG_CMD, LCD_MODE or ALL or D_OFF);
  lcdWrite(FLAG_CMD, LCD_MODE or INVERT or D_OFF);
end;

procedure TNokia1100LCD.lcdOffPartial;
begin
        { /*
           turn off the lcd by power down some components
             display off, row/col at VSS, oscillator on, HVgen enabled
           see datasheet page number 29,table 11
         */
         void lcd_off_partial()}
  lcdWrite(FLAG_CMD, LCD_MODE or DISPLAY or D_OFF);
  lcdWrite(FLAG_CMD, LCD_MODE or ALL or D_OFF);
end;

procedure TNokia1100LCD.lcdOff;
begin
        {  /*
            turn off the lcd by power down all its component
              Power-down mode,display off, row/col at VSS, oscillator off, HVgen disabled
            see datasheet page number 29,table 11
          */
          void lcd_off()}
  lcdWrite(FLAG_CMD, LCD_MODE or DISPLAY or D_OFF);
  lcdWrite(FLAG_CMD, LCD_MODE or ALL or D_ON);
end;

procedure TNokia1100LCD.lcdOn;
begin
  lcdNormal;
end;

procedure TNokia1100LCD.lcdContrast(Value: byte);
begin
        {  /*
            LCD_CONTRAST():
              note:
                change contrast of lcd
              trick:
                LINE 1:
                  contrast value are feed into Vob register ,
                  only 5 LSB bits are send so AND'd with
                  0x1F to remove 3 MSB's
                  see datasheet for more
          */
          void lcd_contrast(byte value)}
  lcdWrite(FLAG_CMD, LCD_VOB_MSB or $04);
  lcdWrite(FLAG_CMD, LCD_VOB_LSB or (Value and $1F));
end;

end.

