unit ssd1306SPI;

{$mode objfpc}

interface

uses
  arduino_compat, stm32f103fw;

const
  SSD1306_LCDHEIGHT = 64;
  SSD1306_LCDWIDTH = 128;
  BLACK = 0;
  WHITE = 1;
  INVERSE = 2;
  SSD1306_SETCONTRAST = $81;
  SSD1306_DISPLAYALLON_RESUME = $A4;
  SSD1306_DISPLAYALLON = $A5;
  SSD1306_NORMALDISPLAY = $A6;
  SSD1306_INVERTDISPLAY = $A7;
  SSD1306_DISPLAYOFF = $AE;
  SSD1306_DISPLAYON = $AF;
  SSD1306_SETDISPLAYOFFSET = $D3;
  SSD1306_SETCOMPINS = $DA;
  SSD1306_SETVCOMDETECT = $DB;
  SSD1306_SETDISPLAYCLOCKDIV = $D5;
  SSD1306_SETPRECHARGE = $D9;
  SSD1306_SETMULTIPLEX = $A8;
  SSD1306_SETLOWCOLUMN = $00;
  SSD1306_SETHIGHCOLUMN = $10;
  SSD1306_SETSTARTLINE = $40;
  SSD1306_MEMORYMODE = $20;
  SSD1306_COLUMNADDR = $21;
  SSD1306_PAGEADDR = $22;
  SSD1306_COMSCANINC = $C0;
  SSD1306_COMSCANDEC = $C8;
  SSD1306_SEGREMAP = $A0;
  SSD1306_CHARGEPUMP = $8D;
  SSD1306_EXTERNALVCC = $1;
  SSD1306_SWITCHCAPVCC = $2;
  // Scrolling s
  SSD1306_ACTIVATE_SCROLL = $2F;
  SSD1306_DEACTIVATE_SCROLL = $2E;
  SSD1306_SET_VERTICAL_SCROLL_AREA = $A3;
  SSD1306_RIGHT_HORIZONTAL_SCROLL = $26;
  SSD1306_LEFT_HORIZONTAL_SCROLL = $27;
  SSD1306_VERTICAL_AND_RIGHT_HORIZONTAL_SCROLL = $29;
  SSD1306_VERTICAL_AND_LEFT_HORIZONTAL_SCROLL = $2A;

  //Rotation

  ROTATION000DEG = 0;
  ROTATION090DEG = 1;
  ROTATION180DEG = 2;
  ROTATION270DEG = 3;


var

  font: array [0..(256 * 5) - 1] of
  byte = ($00, $00, $00, $00, $00, $3E, $5B, $4F, $5B, $3E,
    $3E, $6B, $4F, $6B, $3E, $1C, $3E, $7C, $3E, $1C, $18,
    $3C, $7E, $3C, $18, $1C, $57, $7D, $57, $1C, $1C, $5E,
    $7F, $5E, $1C, $00, $18, $3C, $18, $00, $FF, $E7, $C3,
    $E7, $FF, $00, $18, $24, $18, $00, $FF, $E7, $DB, $E7,
    $FF, $30, $48, $3A, $06, $0E, $26, $29, $79, $29, $26,
    $40, $7F, $05, $05, $07, $40, $7F, $05, $25, $3F, $5A,
    $3C, $E7, $3C, $5A, $7F, $3E, $1C, $1C, $08, $08, $1C,
    $1C, $3E, $7F, $14, $22, $7F, $22, $14, $5F, $5F, $00,
    $5F, $5F, $06, $09, $7F, $01, $7F, $00, $66, $89, $95,
    $6A, $60, $60, $60, $60, $60, $94, $A2, $FF, $A2, $94,
    $08, $04, $7E, $04, $08, $10, $20, $7E, $20, $10, $08,
    $08, $2A, $1C, $08, $08, $1C, $2A, $08, $08, $1E, $10,
    $10, $10, $10, $0C, $1E, $0C, $1E, $0C, $30, $38, $3E,
    $38, $30, $06, $0E, $3E, $0E, $06, $00, $00, $00, $00,
    $00, $00, $00, $5F, $00, $00, $00, $07, $00, $07, $00,
    $14, $7F, $14, $7F, $14, $24, $2A, $7F, $2A, $12, $23,
    $13, $08, $64, $62, $36, $49, $56, $20, $50, $00, $08,
    $07, $03, $00, $00, $1C, $22, $41, $00, $00, $41, $22,
    $1C, $00, $2A, $1C, $7F, $1C, $2A, $08, $08, $3E, $08,
    $08, $00, $80, $70, $30, $00, $08, $08, $08, $08, $08,
    $00, $00, $60, $60, $00, $20, $10, $08, $04, $02, $3E,
    $51, $49, $45, $3E, $00, $42, $7F, $40, $00, $72, $49,
    $49, $49, $46, $21, $41, $49, $4D, $33, $18, $14, $12,
    $7F, $10, $27, $45, $45, $45, $39, $3C, $4A, $49, $49,
    $31, $41, $21, $11, $09, $07, $36, $49, $49, $49, $36,
    $46, $49, $49, $29, $1E, $00, $00, $14, $00, $00, $00,
    $40, $34, $00, $00, $00, $08, $14, $22, $41, $14, $14,
    $14, $14, $14, $00, $41, $22, $14, $08, $02, $01, $59,
    $09, $06, $3E, $41, $5D, $59, $4E, $7C, $12, $11, $12,
    $7C, $7F, $49, $49, $49, $36, $3E, $41, $41, $41, $22,
    $7F, $41, $41, $41, $3E, $7F, $49, $49, $49, $41, $7F,
    $09, $09, $09, $01, $3E, $41, $41, $51, $73, $7F, $08,
    $08, $08, $7F, $00, $41, $7F, $41, $00, $20, $40, $41,
    $3F, $01, $7F, $08, $14, $22, $41, $7F, $40, $40, $40,
    $40, $7F, $02, $1C, $02, $7F, $7F, $04, $08, $10, $7F,
    $3E, $41, $41, $41, $3E, $7F, $09, $09, $09, $06, $3E,
    $41, $51, $21, $5E, $7F, $09, $19, $29, $46, $26, $49,
    $49, $49, $32, $03, $01, $7F, $01, $03, $3F, $40, $40,
    $40, $3F, $1F, $20, $40, $20, $1F, $3F, $40, $38, $40,
    $3F, $63, $14, $08, $14, $63, $03, $04, $78, $04, $03,
    $61, $59, $49, $4D, $43, $00, $7F, $41, $41, $41, $02,
    $04, $08, $10, $20, $00, $41, $41, $41, $7F, $04, $02,
    $01, $02, $04, $40, $40, $40, $40, $40, $00, $03, $07,
    $08, $00, $20, $54, $54, $78, $40, $7F, $28, $44, $44,
    $38, $38, $44, $44, $44, $28, $38, $44, $44, $28, $7F,
    $38, $54, $54, $54, $18, $00, $08, $7E, $09, $02, $18,
    $A4, $A4, $9C, $78, $7F, $08, $04, $04, $78, $00, $44,
    $7D, $40, $00, $20, $40, $40, $3D, $00, $7F, $10, $28,
    $44, $00, $00, $41, $7F, $40, $00, $7C, $04, $78, $04,
    $78, $7C, $08, $04, $04, $78, $38, $44, $44, $44, $38,
    $FC, $18, $24, $24, $18, $18, $24, $24, $18, $FC, $7C,
    $08, $04, $04, $08, $48, $54, $54, $54, $24, $04, $04,
    $3F, $44, $24, $3C, $40, $40, $20, $7C, $1C, $20, $40,
    $20, $1C, $3C, $40, $30, $40, $3C, $44, $28, $10, $28,
    $44, $4C, $90, $90, $90, $7C, $44, $64, $54, $4C, $44,
    $00, $08, $36, $41, $00, $00, $00, $77, $00, $00, $00,
    $41, $36, $08, $00, $02, $01, $02, $04, $02, $3C, $26,
    $23, $26, $3C, $1E, $A1, $A1, $61, $12, $3A, $40, $40,
    $20, $7A, $38, $54, $54, $55, $59, $21, $55, $55, $79,
    $41, $22, $54, $54, $78, $42, // a-umlaut
    $21, $55, $54, $78, $40, $20, $54, $55, $79, $40, $0C,
    $1E, $52, $72, $12, $39, $55, $55, $55, $59, $39, $54,
    $54, $54, $59, $39, $55, $54, $54, $58, $00, $00, $45,
    $7C, $41, $00, $02, $45, $7D, $42, $00, $01, $45, $7C,
    $40, $7D, $12, $11, $12, $7D, // A-umlaut
    $F0, $28, $25, $28, $F0, $7C, $54, $55, $45, $00, $20,
    $54, $54, $7C, $54, $7C, $0A, $09, $7F, $49, $32, $49,
    $49, $49, $32, $3A, $44, $44, $44, $3A, // o-umlaut
    $32, $4A, $48, $48, $30, $3A, $41, $41, $21, $7A, $3A,
    $42, $40, $20, $78, $00, $9D, $A0, $A0, $7D, $3D, $42,
    $42, $42, $3D, // O-umlaut
    $3D, $40, $40, $40, $3D, $3C, $24, $FF, $24, $24, $48,
    $7E, $49, $43, $66, $2B, $2F, $FC, $2F, $2B, $FF, $09,
    $29, $F6, $20, $C0, $88, $7E, $09, $03, $20, $54, $54,
    $79, $41, $00, $00, $44, $7D, $41, $30, $48, $48, $4A,
    $32, $38, $40, $40, $22, $7A, $00, $7A, $0A, $0A, $72,
    $7D, $0D, $19, $31, $7D, $26, $29, $29, $2F, $28, $26,
    $29, $29, $29, $26, $30, $48, $4D, $40, $20, $38, $08,
    $08, $08, $08, $08, $08, $08, $08, $38, $2F, $10, $C8,
    $AC, $BA, $2F, $10, $28, $34, $FA, $00, $00, $7B, $00,
    $00, $08, $14, $2A, $14, $22, $22, $14, $2A, $14, $08,
    $55, $00, $55, $00, $55, // #176 (25% block) missing in old code
    $AA, $55, $AA, $55, $AA, // 50% block
    $FF, $55, $FF, $55, $FF, // 75% block
    $00, $00, $00, $FF, $00, $10, $10, $10, $FF, $00, $14,
    $14, $14, $FF, $00, $10, $10, $FF, $00, $FF, $10, $10,
    $F0, $10, $F0, $14, $14, $14, $FC, $00, $14, $14, $F7,
    $00, $FF, $00, $00, $FF, $00, $FF, $14, $14, $F4, $04,
    $FC, $14, $14, $17, $10, $1F, $10, $10, $1F, $10, $1F,
    $14, $14, $14, $1F, $00, $10, $10, $10, $F0, $00, $00,
    $00, $00, $1F, $10, $10, $10, $10, $1F, $10, $10, $10,
    $10, $F0, $10, $00, $00, $00, $FF, $10, $10, $10, $10,
    $10, $10, $10, $10, $10, $FF, $10, $00, $00, $00, $FF,
    $14, $00, $00, $FF, $00, $FF, $00, $00, $1F, $10, $17,
    $00, $00, $FC, $04, $F4, $14, $14, $17, $10, $17, $14,
    $14, $F4, $04, $F4, $00, $00, $FF, $00, $F7, $14, $14,
    $14, $14, $14, $14, $14, $F7, $00, $F7, $14, $14, $14,
    $17, $14, $10, $10, $1F, $10, $1F, $14, $14, $14, $F4,
    $14, $10, $10, $F0, $10, $F0, $00, $00, $1F, $10, $1F,
    $00, $00, $00, $1F, $14, $00, $00, $00, $FC, $14, $00,
    $00, $F0, $10, $F0, $10, $10, $FF, $10, $FF, $14, $14,
    $14, $FF, $14, $10, $10, $10, $1F, $00, $00, $00, $00,
    $F0, $10, $FF, $FF, $FF, $FF, $FF, $F0, $F0, $F0, $F0,
    $F0, $FF, $FF, $FF, $00, $00, $00, $00, $00, $FF, $FF,
    $0F, $0F, $0F, $0F, $0F, $38, $44, $44, $38, $44, $FC,
    $4A, $4A, $4A, $34, // sharp-s or beta
    $7E, $02, $02, $06, $06, $02, $7E, $02, $7E, $02, $63,
    $55, $49, $41, $63, $38, $44, $44, $3C, $04, $40, $7E,
    $20, $1E, $20, $06, $02, $7E, $02, $02, $99, $A5, $E7,
    $A5, $99, $1C, $2A, $49, $2A, $1C, $4C, $72, $01, $72,
    $4C, $30, $4A, $4D, $4D, $30, $30, $48, $78, $48, $30,
    $BC, $62, $5A, $46, $3D, $3E, $49, $49, $49, $00, $7E,
    $01, $01, $01, $7E, $2A, $2A, $2A, $2A, $2A, $44, $44,
    $5F, $44, $44, $40, $51, $4A, $44, $40, $40, $44, $4A,
    $51, $40, $00, $00, $FF, $01, $03, $E0, $80, $FF, $00,
    $00, $08, $08, $6B, $6B, $08, $36, $12, $36, $24, $36,
    $06, $0F, $09, $0F, $06, $00, $00, $18, $18, $00, $00,
    $00, $10, $10, $00, $30, $40, $FF, $01, $01, $00, $1F,
    $01, $01, $1E, $00, $19, $1D, $17, $12, $00, $3C, $3C,
    $3C, $3C, $00, $00, $00, $00, $00  // #255 NBSP
    );




  buffer: array[0..(SSD1306_LCDHEIGHT * SSD1306_LCDWIDTH div 8) - 1] of byte = (
    //first 8 rows
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $80, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80,
    $C0, $C0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    //rows 9-16
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $80, $C0, $E0, $F0, $F8, $FC, $F8, $E0,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $80, $80, $80, $80, $80, $00, $80, $80, $00, $00, $00,
    $00, $80, $80, $80, $80, $80, $00, $FF, $FF, $FF, $00, $00, $00, $00,
    $80, $80, $80, $80, $00, $00, $80, $80, $00, $00, $80, $FF, $FF, $80,
    $80, $00, $80, $80, $00, $80, $80, $80, $80, $00, $80, $80, $00, $00,
    $00, $00, $00, $80, $80, $00, $00, $8C, $8E, $84, $00, $00, $80,
    $F8, $F8, $F8, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0, $F0,
    $F0, $E0, $E0, $C0, $80, $00, $E0, $FC, $FE, $FF, $FF, $FF, $7F, $FF,
    $FF, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $FE, $FF, $C7, $01, $01, $01, $01, $83, $FF, $FF,
    $00, $00, $7C, $FE, $C7, $01, $01, $01, $01, $83, $FF, $FF, $FF, $00,
    $38, $FE, $C7, $83, $01, $01, $01, $83, $C7, $FF, $FF, $00, $00, $01,
    $FF, $FF, $01, $01, $00, $FF, $FF, $07, $01, $01, $01, $00, $00, $7F,
    $FF, $80, $00, $00, $00, $FF, $FF, $7F, $00, $00, $FF, $FF, $FF, $00,
    $00, $01, $FF, $FF, $FF, $01, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $03, $0F, $3F, $7F, $7F, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $E7, $C7, $C7, $8F, $8F, $9F, $BF, $FF, $FF, $C3, $C0,
    $F0, $FF, $FF, $FF, $FF, $FF, $FC, $FC, $FC, $FC, $FC, $FC, $FC, $FC,
    $F8, $F8, $F0, $F0, $E0, $C0, $00, $01, $03, $03, $03, $03, $03, $01,
    $03, $03, $00, $00, $00, $00, $01, $03, $03, $03, $03, $01, $01, $03,
    $01, $00, $00, $00, $01, $03, $03, $03, $03, $01, $01, $03, $03, $00,
    $00, $00, $03, $03, $00, $00, $00, $03, $03, $00, $00, $00, $00, $00,
    $00, $00, $01, $03, $03, $03, $03, $03, $01, $00, $00, $00, $01, $03,
    $01, $00, $00, $00, $03, $03, $01, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $C0, $E0, $F0,
    $F9, $FF, $FF, $FF, $FF, $FF, $3F, $1F, $0F, $87, $C7, $F7, $FF, $FF,
    $1F, $1F, $3D, $FC, $F8, $F8, $F8, $F8, $7C, $7D, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $7F, $3F, $0F, $07, $00, $30, $30, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $FE, $FE, $FC, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $E0, $C0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $30, $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $C0, $FE, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $7F, $7F, $3F, $1F, $0F, $07, $1F,
    $7F, $FF, $FF, $F8, $F8, $FF, $FF, $FF, $FF, $FF, $FE, $F8, $E0, $00,
    $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $FE, $FE, $00,
    $00, $00, $FC, $FE, $FC, $0C, $06, $06, $0E, $FC, $F8, $00, $00, $F0,
    $F8, $1C, $0E, $06, $06, $06, $0C, $FF, $FF, $FF, $00, $00, $FE, $FE,
    $00, $00, $00, $00, $FC, $FE, $FC, $00, $18, $3C, $7E, $66, $E6, $CE,
    $84, $00, $00, $06, $FF, $FF, $06, $06, $FC, $FE, $FC, $0C, $06, $06,
    $06, $00, $00, $FE, $FE, $00, $00, $C0, $F8, $FC, $4E, $46, $46, $46,
    $4E, $7C, $78, $40, $18, $3C, $76, $E6, $CE, $CC, $80, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $01, $07, $0F, $1F, $1F, $3F, $3F, $3F, $3F, $1F, $0F,
    $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0F,
    $0F, $00, $00, $00, $0F, $0F, $0F, $00, $00, $00, $00, $0F, $0F, $00,
    $00, $03, $07, $0E, $0C, $18, $18, $0C, $06, $0F, $0F, $0F, $00, $00,
    $01, $0F, $0E, $0C, $18, $0C, $0F, $07, $01, $00, $04, $0E, $0C, $18,
    $0C, $0F, $07, $00, $00, $00, $0F, $0F, $00, $00, $0F, $0F, $0F, $00,
    $00, $00, $00, $00, $00, $0F, $0F, $00, $00, $00, $07, $07, $0C, $0C,
    $18, $1C, $0C, $06, $06, $00, $04, $0E, $0C, $18, $0C, $0F, $07, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);



type

  { AdafruitGFX }

  AdafruitGFX = class
  private
    Width, Height: shortint;   // This is the 'raw' display w/h - never changes
    _width, _height, // Display w/h as modified by current rotation
    cursor_x, cursor_y: shortint;
    textcolor, textbgcolor: word;
    textsize, rotation: word;
    wrap,   // If set, 'wrap' text at right edge of display
    _cp437: boolean; // If set, use correct CP437 charset (default is off)
    sclk_pinset: longword;// =1;
    sclk_pinreset: longword;// = 1 shl 16;
    sdi_pinset: longword;// = 2;
    sdi_pinreset: longword;// = 2 shl 16;
  public

    constructor Create(_w: word; _h: word);
    destructor Destroy; override;
    procedure drawChar(x: integer; y: integer; c: char; color: word;
      bg: word; size: byte);
    procedure setCursor(x: integer; y: integer);
    procedure setTextColor(c: word);
    procedure setTextColor(c: word; bg: word);
    procedure setTextSize(s: byte);
    procedure setTextWrap(w: boolean);
    procedure setRotation(r: byte);
    procedure cp437(x: boolean = True);
    procedure drawPixel(x: longint; y: longint; color: word); dynamic;
    procedure drawLine(x0: integer; y0: integer; x1: integer; y1: integer; color: word);
    procedure drawFastVLine(x: integer; y: integer; h: integer; color: word);
    procedure drawFastHLine(x: integer; y: integer; w: integer; color: word);
    procedure drawRect(x: integer; y: integer; w: integer; h: integer; color: word);
    procedure fillRect(x: integer; y: integer; w: integer; h: integer; color: word);
    procedure fillScreen(color: word);
    function Write(c: byte): word;
    function f_height: integer;
    function f_width: integer;
    function getRotation: word;
    // get current cursor position (get rotation safe maximum values, using: width() for x, height() for y)
    function getCursorX: integer;
    function getCursorY: integer;
  end;



  { Adafruit_SSD1306 }

  Adafruit_SSD1306 = class(AdafruitGFX)
  private
    sid: board_pins;
    sclk: board_pins;
    dc: board_pins;
    rst: board_pins;
    cs: board_pins;
    _vccstate: integer;
  public

    constructor Create(_sid: board_pins; _sclk: board_pins;
      _dc: board_pins; _cs: board_pins);
    destructor Destroy; override;
    procedure _begin(vccstate: byte; i2caddr: byte; reset: boolean);
    procedure ssd1306_command(c: byte);
    procedure ssd1306_data(c: byte);
    procedure clearDisplay;
    procedure invertDisplay(i: byte);
    procedure invertDisplay(i: boolean);
    procedure display;
    procedure startscrollright(start: byte; stop: byte);
    procedure startscrollleft(start: byte; stop: byte);
    procedure startscrolldiagright(start: byte; stop: byte);
    procedure startscrolldiagleft(start: byte; stop: byte);
    procedure stopscroll;
    procedure dim(dim: boolean);
    procedure drawPixel(x: longint; y: longint; color: word); override;
    procedure fastSPIWrite(c: byte);
    procedure print(str: string);
    procedure print(str: string; _size: byte);
    procedure println(str: string);
    procedure println(str: string; _size: byte);
  end;

procedure _swap(var a: longint; var b: longint);

implementation

procedure _swap(var a: longint; var b: longint);
var
  t: int64;
begin
  t := a;
  a := b;
  b := t;
end;

{ AdafruitGFX }

constructor AdafruitGFX.Create(_w: word; _h: word);
begin
  _width := _w;
  _height := _h;
  rotation := 0;
  cursor_y := 0;
  cursor_x := 0;
  textsize := 1;
  textcolor := $FFFF;
  textbgcolor := $FFFF;
  wrap := True;
  _cp437 := False;
end;

destructor AdafruitGFX.Destroy;
begin
  inherited Destroy;
end;

procedure AdafruitGFX.drawChar(x: integer; y: integer; c: char;
  color: word; bg: word; size: byte);
var
  i, j, line: integer;
begin
   { if((x >= _width) or            // Clip right
     (y >= _height) or           // Clip bottom
     ((x + (6 * size) - 1) < 0) or // Clip left
     ((y + (8 * size) - 1) < 0)) then  // Clip top
    exit;  }

  if ((not _cp437) and (byte(c) >= 176)) then
  begin
    Inc(c);
  end; // Handle 'classic' charset behavior

  for  i := 0 to 5 do
  begin
    if (i = 5) then
    begin
      line := 0;
    end
    else
    begin
      line := font[(byte(c) * 5) + i];
    end;


    for j := 0 to 7 do
    begin
      if (line and $1) = 1 then
      begin
        if (size = 1) then// default size
        begin
          drawPixel(x + i, y + j, color);
        end
        else   // big size
        begin
          fillRect(x + (i * size), y + (j * size), size, size, color);
        end;
      end
      else if (bg <> color) then
      begin
        if (size = 1) then// default size
        begin
          drawPixel(x + i, y + j, bg);
        end
        else   // big size
        begin
          fillRect(x + i * size, y + j * size, size, size, bg);
        end;
      end;


      line := line shr 1;

    end;
  end;
  cursor_x := x + 6 * size;
  cursor_y := y;
end;

procedure AdafruitGFX.setCursor(x: integer; y: integer);
begin
  cursor_x := x;
  cursor_y := y;
end;

procedure AdafruitGFX.setTextColor(c: word);
begin
  textcolor := c;
end;

procedure AdafruitGFX.setTextColor(c: word; bg: word);
begin
  textcolor := c;
  textbgcolor := bg;
end;

procedure AdafruitGFX.setTextSize(s: byte);
begin
  textsize := 1;
  if s > 1 then
  begin
    textsize := s;
  end;
end;

procedure AdafruitGFX.setTextWrap(w: boolean);
begin
  wrap := w;
end;

procedure AdafruitGFX.setRotation(r: byte);
begin

  rotation := r and 3;
  case rotation of
    ROTATION000DEG:
    begin
      _width := Width;
      _height := Height;
    end;
    ROTATION090DEG:
    begin
      _width := Height;
      _height := Width;
    end;
    ROTATION180DEG:
    begin
      _width := Width;
      _height := Height;
    end;
    ROTATION270DEG:
    begin
      _width := Height;
      _height := Width;
    end;
  end;
end;

procedure AdafruitGFX.cp437(x: boolean);
begin
  _cp437 := x;
end;

procedure AdafruitGFX.drawPixel(x: longint; y: longint; color: word);
begin
  //do nothing only virtual
end;

procedure AdafruitGFX.drawLine(x0: integer; y0: integer; x1: integer;
  y1: integer; color: word);
var
  steep: boolean;
  ystep, dx, dy, err: integer;
begin
  steep := False;
  if (abs(y1 - y0) > abs(x1 - x0)) then
  begin
    steep := True;
  end;
  if (steep) then
  begin
    _swap(x0, y0);
    _swap(x1, y1);
  end;

  if (x0 > x1) then
  begin
    _swap(x0, x1);
    _swap(y0, y1);
  end;


  dx := x1 - x0;
  dy := abs(y1 - y0);

  err := dx div 2;


  if (y0 < y1) then
  begin
    ystep := 1;
  end
  else
  begin
    ystep := -1;
  end;

  while (x0 <= x1) do
  begin
    if (steep) then
    begin
      drawPixel(y0, x0, color);
    end
    else
    begin
      drawPixel(x0, y0, color);
    end;
    err := err - dy;
    if (err < 0) then
    begin
      y0 := y0 + ystep;
      err := err + dx;
    end;
    Inc(x0);
  end;
end;

procedure AdafruitGFX.drawFastVLine(x: integer; y: integer; h: integer; color: word);
begin
  // Update in subclasses if desired!
  drawLine(x, y, x, y + h - 1, color);
end;

procedure AdafruitGFX.drawFastHLine(x: integer; y: integer; w: integer; color: word);
begin
  // Update in subclasses if desired!
  drawLine(x, y, x + w - 1, y, color);
end;

procedure AdafruitGFX.drawRect(x: integer; y: integer; w: integer;
  h: integer; color: word);
begin
  drawFastHLine(x, y, w, color);
  drawFastHLine(x, y + h - 1, w, color);
  drawFastVLine(x, y, h, color);
  drawFastVLine(x + w - 1, y, h, color);
end;

procedure AdafruitGFX.fillRect(x: integer; y: integer; w: integer;
  h: integer; color: word);
var
  i: integer;
begin
  // Update in subclasses if desired!
  for i := x to x + w - 1 do
  begin
    drawFastVLine(i, y, h, color);
  end;

end;

procedure AdafruitGFX.fillScreen(color: word);
begin
  fillRect(0, 0, _width, _height, color);
end;

function AdafruitGFX.Write(c: byte): word;
begin
  if (c = 13) then
  begin
    cursor_y += textsize * 8;
    cursor_x := 0;
  end
  else if (c = 10) then
  begin
    // skip em
  end
  else
  begin
    drawChar(cursor_x, cursor_y, char(c), textcolor, textbgcolor, textsize);
    cursor_x := cursor_x + textsize * 6;
    if (wrap and (cursor_x > (_width - textsize * 6))) then
    begin
      cursor_y += textsize * 8;
      cursor_x := 0;
    end;
  end;
end;

function AdafruitGFX.f_height: integer;
begin
  Result := _height;
end;

function AdafruitGFX.f_width: integer;
begin
  Result := _width;
end;

function AdafruitGFX.getRotation: word;
begin
  Result := rotation;
end;

function AdafruitGFX.getCursorX: integer;
begin
  Result := cursor_x;
end;

function AdafruitGFX.getCursorY: integer;
begin
  Result := cursor_y;
end;

{ Adafruit_SSD1306 }

constructor Adafruit_SSD1306.Create(_sid: board_pins; _sclk: board_pins;
  _dc: board_pins; _cs: board_pins);
begin
  inherited Create(SSD1306_LCDWIDTH, SSD1306_LCDHEIGHT);
  cs := _CS;
  // rst := _RST;
  dc := _DC;
  sclk := _SCLK;
  sid := _SID;
  textsize := 1;
  textcolor := white;
  textbgcolor := black;
  cursor_x := 0;
  cursor_y := 0;
end;

destructor Adafruit_SSD1306.Destroy;
begin
  inherited Destroy;
end;

procedure Adafruit_SSD1306._begin(vccstate: byte; i2caddr: byte; reset: boolean);
begin
  _vccstate := vccstate;
  //_i2caddr := i2caddr;
  pinMode(dc, OUTPUT);
  if cs <> NC then
     pinMode(cs, OUTPUT);
  pinMode(sid, OUTPUT);
  pinMode(sclk, OUTPUT);
  sclk_pinset := GPIO_Pin_7;  //PB7
  sclk_pinreset := GPIO_Pin_7 shl 16;
  sdi_pinset := GPIO_Pin_6;   //PB6
  sdi_pinreset := GPIO_Pin_6 shl 16;
  if (reset) then
  begin
    // Setup reset pin direction (used by both SPI and I2C)
    pinMode(rst, OUTPUT);
    digitalWrite(rst, HIGH);
    // VDD (3.3V) goes high at start, lets just chill for a ms
    delay(1);
    // bring reset low
    digitalWrite(rst, LOW);
    // wait 10ms
    delay(10);
    // bring out of reset
   digitalWrite(rst, HIGH);
    // turn on VCC (9V?)
  end;


  // Init sequence for 128x64 OLED module
  ssd1306_command(SSD1306_DISPLAYOFF);                    // 0xAE
  ssd1306_command(SSD1306_SETDISPLAYCLOCKDIV);            // 0xD5
  ssd1306_command($80);                                  // the suggested ratio 0x80
  ssd1306_command(SSD1306_SETMULTIPLEX);                  // 0xA8
  ssd1306_command($3F);
  ssd1306_command(SSD1306_SETDISPLAYOFFSET);              // 0xD3
  ssd1306_command($0);                                   // no offset
  ssd1306_command(SSD1306_SETSTARTLINE or $0);            // line #0
  ssd1306_command(SSD1306_CHARGEPUMP);                    // 0x8D
  if (vccstate = SSD1306_EXTERNALVCC) then
  begin
    ssd1306_command($10);
  end
  else
  begin
    ssd1306_command($14);
  end;
  ssd1306_command(SSD1306_MEMORYMODE);                    // 0x20
  ssd1306_command($00);                                  // 0x0 act like ks0108
  ssd1306_command(SSD1306_SEGREMAP or $1);
  ssd1306_command(SSD1306_COMSCANDEC);
  ssd1306_command(SSD1306_SETCOMPINS);                    // 0xDA
  ssd1306_command($12);
  ssd1306_command(SSD1306_SETCONTRAST);                   // 0x81
  if (vccstate = SSD1306_EXTERNALVCC) then
  begin
    ssd1306_command($9F);
  end
  else
  begin
    ssd1306_command($CF);
  end;
  ssd1306_command(SSD1306_SETPRECHARGE);                  // 0xd9
  if (vccstate = SSD1306_EXTERNALVCC) then
  begin
    ssd1306_command($22);
  end
  else
  begin
    ssd1306_command($F1);
  end;
  ssd1306_command(SSD1306_SETVCOMDETECT);                 // 0xDB
  ssd1306_command($40);
  ssd1306_command(SSD1306_DISPLAYALLON_RESUME);           // 0xA4
  ssd1306_command(SSD1306_NORMALDISPLAY);                 // 0xA6

  ssd1306_command(SSD1306_DISPLAYON); //$AF

end;

procedure Adafruit_SSD1306.ssd1306_command(c: byte);
begin
  // SPI
  if cs <> NC then
    digitalWrite(cs, HIGH);
  // *csport |= cspinmask;
  digitalWrite(dc, LOW);
  //  *dcport &= ~dcpinmask;
  if cs <> NC then
    digitalWrite(cs, LOW);
  //*csport &= ~cspinmask;
  fastSPIwrite(c);
  if cs <> NC then
     digitalWrite(cs, HIGH);
  // *csport |= cspinmask;
end;

procedure Adafruit_SSD1306.ssd1306_data(c: byte);
begin
  // SPI
  if cs <> NC then
     digitalWrite(cs, HIGH);
  //*csport |= cspinmask;
  digitalWrite(dc, HIGH);
  //*dcport |= dcpinmask;
  if cs <> NC then
   digitalWrite(cs, LOW);
  //*csport &= ~cspinmask;
  fastSPIwrite(c);
  if cs <> NC then
    digitalWrite(cs, HIGH);
  // *csport |= cspinmask;
end;

procedure Adafruit_SSD1306.clearDisplay;
begin
  fillchar(buffer, sizeof(buffer), #0);
end;

procedure Adafruit_SSD1306.invertDisplay(i: byte);
begin
  if (i > 0) then
  begin
    ssd1306_command(SSD1306_INVERTDISPLAY);
  end
  else
  begin
    ssd1306_command(SSD1306_NORMALDISPLAY);
  end;
end;

procedure Adafruit_SSD1306.invertDisplay(i: boolean);
begin
  if i then
  begin
    ssd1306_command(SSD1306_INVERTDISPLAY);
  end
  else
  begin
    ssd1306_command(SSD1306_NORMALDISPLAY);
  end;
end;

procedure Adafruit_SSD1306.display;
var
  i: word;
begin
  ssd1306_command(SSD1306_COLUMNADDR);
  ssd1306_command(0);   // Column start address (0 = reset)
  ssd1306_command(SSD1306_LCDWIDTH - 1); // Column end address (127 = reset)

  ssd1306_command(SSD1306_PAGEADDR);
  ssd1306_command(0); // Page start address (0 = reset)
  ssd1306_command(7); // Page end address
  if cs <> NC then
    digitalWrite(cs, HIGH);
  digitalWrite(dc, HIGH);
  if cs <> NC then
   digitalWrite(cs, LOW);
  for i := 0 to (SSD1306_LCDWIDTH * SSD1306_LCDHEIGHT div 8) - 1 do
  begin
    fastSPIwrite(buffer[i]);
  end;
  if cs <> NC then
   digitalWrite(cs, HIGH);
end;

procedure Adafruit_SSD1306.startscrollright(start: byte; stop: byte);
begin
  ssd1306_command(SSD1306_RIGHT_HORIZONTAL_SCROLL);
  ssd1306_command($00);
  ssd1306_command(start);
  ssd1306_command($00);
  ssd1306_command(stop);
  ssd1306_command($00);
  ssd1306_command($FF);
  ssd1306_command(SSD1306_ACTIVATE_SCROLL);
end;

procedure Adafruit_SSD1306.startscrollleft(start: byte; stop: byte);
begin
  ssd1306_command(SSD1306_LEFT_HORIZONTAL_SCROLL);
  ssd1306_command($00);
  ssd1306_command(start);
  ssd1306_command($00);
  ssd1306_command(stop);
  ssd1306_command($00);
  ssd1306_command($FF);
  ssd1306_command(SSD1306_ACTIVATE_SCROLL);
end;

procedure Adafruit_SSD1306.startscrolldiagright(start: byte; stop: byte);
begin
  ssd1306_command(SSD1306_SET_VERTICAL_SCROLL_AREA);
  ssd1306_command($00);
  ssd1306_command(SSD1306_LCDHEIGHT);
  ssd1306_command(SSD1306_VERTICAL_AND_RIGHT_HORIZONTAL_SCROLL);
  ssd1306_command($00);
  ssd1306_command(start);
  ssd1306_command($00);
  ssd1306_command(stop);
  ssd1306_command($01);
  ssd1306_command(SSD1306_ACTIVATE_SCROLL);
end;

procedure Adafruit_SSD1306.startscrolldiagleft(start: byte; stop: byte);
begin
  ssd1306_command(SSD1306_SET_VERTICAL_SCROLL_AREA);
  ssd1306_command($00);
  ssd1306_command(SSD1306_LCDHEIGHT);
  ssd1306_command(SSD1306_VERTICAL_AND_LEFT_HORIZONTAL_SCROLL);
  ssd1306_command($00);
  ssd1306_command(start);
  ssd1306_command($00);
  ssd1306_command(stop);
  ssd1306_command($01);
  ssd1306_command(SSD1306_ACTIVATE_SCROLL);
end;

procedure Adafruit_SSD1306.stopscroll;
begin
  ssd1306_command(SSD1306_DEACTIVATE_SCROLL);
end;

procedure Adafruit_SSD1306.dim(dim: boolean);
var
  contrast: byte;
begin
  if (dim) then
  begin
    contrast := 0;
  end // Dimmed display
  else
  begin
    if (_vccstate = SSD1306_EXTERNALVCC) then
    begin
      contrast := $9F;
    end
    else
    begin
      contrast := $CF;
    end;
  end;
  // the range of contrast to too small to be really useful
  // it is useful to dim the display
  ssd1306_command(SSD1306_SETCONTRAST);
  ssd1306_command(contrast);
end;

procedure Adafruit_SSD1306.drawPixel(x: longint; y: longint; color: word);
begin
  // if ((x < 0) or (x >= f_width) or (y < 0) or (y >= f_height))  then
  //   exit;

  // check rotation, move pixel around if necessary
  case getRotation of
    1:
    begin
      _swap(longint(x), longint(y));
      x := Width - x - 1;
    end;
    2:
    begin
      x := Width - x - 1;
      y := Height - y - 1;
    end;
    3:
    begin
      _swap(x, y);
      y := Height - y - 1;
    end;
  end;


  // x is which column
  case color of
       {   WHITE  : buffer[x+((y * SSD1306_LCDWIDTH) div 8)] := buffer[x+((y * SSD1306_LCDWIDTH) div 8)] or (1 shl (y and 7));
          BLACK  : buffer[x+((y *SSD1306_LCDWIDTH) div 8)] := buffer[x+((y * SSD1306_LCDWIDTH) div 8)] and not(1 shl (y and 7));
          INVERSE : buffer[x+((y *SSD1306_LCDWIDTH) div 8)] := buffer[x+((y * SSD1306_LCDWIDTH) div 8)] xor (1 shl (y and 7));      }
    WHITE:
    begin
      buffer[x + ((y div 8) * SSD1306_LCDWIDTH)] :=
        buffer[x + ((y div 8) * SSD1306_LCDWIDTH)] or (1 shl (y and 7));
    end;
    BLACK:
    begin
      buffer[x + ((y div 8) * SSD1306_LCDWIDTH)] :=
        buffer[x + ((y div 8) * SSD1306_LCDWIDTH)] and not (1 shl (y and 7));
    end;
    INVERSE:
    begin
      buffer[x + ((y div 8) * SSD1306_LCDWIDTH)] :=
        buffer[x + ((y div 8) * SSD1306_LCDWIDTH)] xor (1 shl (y and 7));
    end;
  end;

end;

procedure Adafruit_SSD1306.fastSPIWrite(c: byte);
var
  bit: byte;
  i: byte;
begin
  bit := $80;
  for i := 0 to 7 do
  begin
    // digitalWrite(sclk, LOW);
    portb.BSRR := sclk_pinreset;
    if (c and bit) > 0 then
      // digitalWrite(sid, HIGH)
    begin
      Portb.BSRR := sdi_pinset;
    end
    else
      // digitalWrite(sid,LOW);
    begin
      Portb.BSRR := sdi_pinreset;
    end;
    // digitalWrite(sclk,HIGH);
    Portb.BSRR := sclk_pinset;
    bit := bit shr 1;
  end;

end;

procedure Adafruit_SSD1306.print(str: string);
var
  index_x: byte;
begin
  for index_x := 1 to length(str) do
  begin
    drawchar(cursor_x, cursor_y, str[index_x], textcolor, textbgcolor, textsize);
  end;
end;

procedure Adafruit_SSD1306.print(str: string; _size: byte);
var
  tmptxtsize: byte;
begin
  tmptxtsize := textsize;
  textsize := _size;
  print(str);
  textsize := tmptxtsize;
end;

procedure Adafruit_SSD1306.println(str: string);
begin
  print(str);
  cursor_y := cursor_y + 8 * textsize;
  cursor_x := 0;
end;

procedure Adafruit_SSD1306.println(str: string; _size: byte);
var
  tmptxtsize: byte;
begin
  tmptxtsize := textsize;
  textsize := _size;
  println(str);
  textsize := tmptxtsize;

end;

end.
