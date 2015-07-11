unit SWSPI;

//NEVER tested

interface

uses
  arduino_compat;

type
  { TSWSPI }
  //simple bit bamging class for managing simple spi commnunocation
  //at the moment only MODE=0 CPOL=0 CPHA=0 MSB_FIRST is implemented
  TSWSPI = class
  private
    miso_pin:board_pins;
    mosi_pin:board_pins;
    sclk_pin:board_pins;
    csn_pin:board_pins;
    sce_pin:board_pins;
    procedure SCK(value : byte);
    procedure MOSI(value : byte);
    function  MISO: byte;
  public
    constructor Create(_mosi: board_pins; _miso: board_pins; _sclk: board_pins;
      _csn: board_pins; _sce: board_pins);
    destructor Destroy; override;
    function write(command : byte):byte;
    function write_address(address, data: byte): byte;
    function read:byte;
    function read_address(address: byte): byte;
    procedure CSN(value : byte);
    procedure CE(value : byte);
  end;

implementation

{ TSWSPI }

procedure TSWSPI.CSN(value: byte);
begin
   if CSN_pin<>NC then
      digitalWrite(CSN_pin,value);
end;

procedure TSWSPI.SCK(value: byte);
begin
   if SCLK_pin <> NC then
      digitalWrite(SCLK_pin,value);
end;

procedure TSWSPI.CE(value: byte);
begin
   if SCE_pin <> NC then
     digitalWrite(SCE_pin,value);
end;

procedure TSWSPI.MOSI(value: byte);
begin
   if MOSI_pin <> NC then
    digitalWrite(MOSI_pin,value);
end;

function TSWSPI.MISO: byte;
begin
   if MISO_pin <> NC then
     result:=(ord((Pin_Map[MISO_pin].Port^.IDR and Pin_Map[MISO_pin].Pin) <> 0));
end;

constructor TSWSPI.Create(_mosi: board_pins; _miso: board_pins;
  _sclk: board_pins; _csn: board_pins; _sce: board_pins);
begin
    miso_pin:=_miso;
    mosi_pin:=_mosi;
    sclk_pin:=_sclk;
    csn_pin:=_csn;
    sce_pin:=_sce;
    if MOSI_pin <> NC then
      pinMode(mosi_pin,OUTPUT);
    if SCLK_pin <> NC then
      pinMode(sclk_pin,OUTPUT);
    if MISO_pin <> NC then
      pinMode(miso_pin,INPUT);
    if sce_pin <> NC then
      pinMode(sce_pin,OUTPUT);
    if csn_pin <> NC then
      pinMode(csn_pin,OUTPUT);
end;

destructor TSWSPI.Destroy;
begin
  inherited Destroy;
end;

function TSWSPI.write(command: byte): byte;
var
  i:byte;
begin
   SCK(LOW);
   MOSI(LOW);
   for i:=0 to 7 do
        begin
          if ((command and $80) = $80) then
              MOSI(HIGH)
            else
              MOSI(LOW);
           result:=(result shl 1) or MISO;
           SCK(HIGH);
           asm nop end;
           SCK(LOW);
           command:=command shl 1;
        end;
   MOSI(HIGH);
end;

function TSWSPI.write_address(address, data: byte): byte;
begin
   csn(low);
   self.write(address);
   asm nop end;
   self.write(data);
   csn(high);
end;

function TSWSPI.read: byte;
var
  i:byte;
begin
    result:=0;
    MOSI(LOW);
    asm nop end;
    for i:=0 to 7 do
        begin
            result:=(result shl 1) or MISO;
            SCK(HIGH);
            asm nop end;
            SCK(LOW);
            asm nop end;
        end;
    MOSI(HIGH);
end;

function TSWSPI.read_address(address: byte): byte;
begin
   csn(low);
   self.write(address);
   result:=self.read;
   csn(high);
end;


end.
