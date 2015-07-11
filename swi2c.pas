unit SWI2C;

//never tested


// #define SDA P0_0
// #define SCL P0_1

//void I2CInit()
{
	SDA = 1;
	SCL = 1;
}

//void I2CStart()
{
	SDA = 0;
	SCL = 0;
}

//void I2CRestart()
{
	SDA = 1;
	SCL = 1;
	SDA = 0;
	SCL = 0;
}

//void I2CStop()
{
	SCL = 0;
	SDA = 0;
	SCL = 1;
	SDA = 1;
}

// I2CAck()
{
	SDA = 0;
	SCL = 1;
	SCL = 0;
	SDA = 1;
}

//void I2CNak()
{
	SDA = 1;
	SCL = 1;
	SCL = 0;
	SDA = 1;
}

//unsigned char I2CSend(unsigned char Data)
{
	 unsigned char i, ack_bit;
	 for (i = 0; i < 8; i++) {
		if ((Data & 0x80) == 0)
			SDA = 0;
		else
			SDA = 1;
		SCL = 1;
	 	SCL = 0;
		Data<<=1;
	 }
	 SDA = 1;
	 SCL = 1;
	 ack_bit = SDA;
	 SCL = 0;
	 return ack_bit;
}

//unsigned char I2CRead()
{
	unsigned char i, Data=0;
	for (i = 0; i < 8; i++) {
		SCL = 1;
		if(SDA)
			Data |=1;
		if(i<7)
			Data<<=1;
		SCL = 0;
	}
	return Data;
}
//Using C code is very simple. Here is a smal

interface

uses
  arduino_compat;

type

  { TSWI2C }

  TSWI2C = class
  private
    sclpin:board_pins;
    sdapin:board_pins;
    address : byte;
    procedure NAK;
    procedure ACK;
    procedure Stop;
    procedure restart;
    procedure Start;
    procedure Init;
  public
    function write(data : byte): byte;
    function read: byte;
    constructor Create(_sclpin, _sdapin: board_pins);
    destructor Destroy; override;
  end;

implementation

{ TSWI2C }

procedure TSWI2C.NAK;
begin
   digitalwrite(SDApin, HIGH);
   digitalwrite(SCLpin, HIGH);
   digitalwrite(SCLpin, LOW);
   digitalwrite(SDApin, HIGH);
end;

procedure TSWI2C.ACK;
begin
   digitalwrite(SDApin, LOW);
   digitalwrite(SCLpin, HIGH);
   digitalwrite(SCLpin, LOW);
   digitalwrite(SDApin, HIGH);
end;

procedure TSWI2C.Stop;
begin
   digitalwrite(SCLpin, LOW);
   digitalwrite(SDApin, LOW);
   digitalwrite(SCLpin, HIGH);
   digitalwrite(SDApin, HIGH);
end;

procedure TSWI2C.restart;
begin
   digitalwrite(SDApin, HIGH);
   digitalwrite(SCLpin, HIGH);
   digitalwrite(SDApin, LOW);
   digitalwrite(SCLpin, LOW);
end;

procedure TSWI2C.Start;
begin
   digitalwrite(SDApin, LOW);
   digitalwrite(SCLpin, LOW);
end;

procedure TSWI2C.Init;
begin
   digitalwrite(SDApin, HIGH);
   digitalwrite(SCLpin, HIGH);
end;

function TSWI2C.write(data: byte): byte;
var
  i:byte;
begin
  for i:=0 to 7 do
  begin
     if (Data and $80) = 0 then
         digitalwrite(SDApin, HIGH)
       else
         digitalwrite(SDApin, LOW);
     digitalwrite(SCLpin, HIGH);
     digitalwrite(SCLpin, LOW);
     Data:=Data shl 1;
  end;
  digitalwrite(SDApin, HIGH);
  digitalwrite(SCLpin, HIGH);
  result:=digitalRead(SDApin);
  digitalwrite(SCLpin, LOW);
end;

function TSWI2C.read: byte;
var
  i,data:byte;
begin
   //	unsigned char i, Data=0;
  data:=0;
  for i:=0 to 7 do
  begin
     digitalwrite(SCLpin, HIGH);
     if digitalRead(SDApin)=HIGH then
         data:= data or 1;
     if i<7 then
         data:=data shl 1;
     digitalwrite(SCLpin, LOW);
  end;
  result:=data;
end;

constructor TSWI2C.Create(_sclpin, _sdapin: board_pins);
begin
   sclpin:=_sclpin;
   sdapin:=_sdapin;
end;

destructor TSWI2C.Destroy;
begin
  inherited Destroy;
end;

end.

    Status API Training Shop Blog About Help

    © 2015 GitHub, Inc. Terms Privacy Security Contact


