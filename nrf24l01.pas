unit NRF24L01;

{$mode objfpc}

interface

uses
  Arduino_compat, HWSPI;

const
  CONFIG = $00;
  EN_AA = $01;
  EN_RXADDR = $02;
  SETUP_AW = $03;
  SETUP_RETR = $04;
  RF_CH = $05;
  RF_SETUP = $06;
  STATUS = $07;
  OBSERVE_TX = $08;
  CD = $09;
  RX_ADDR_P0 = $0A;
  RX_ADDR_P1 = $0B;
  RX_ADDR_P2 = $0C;
  RX_ADDR_P3 = $0D;
  RX_ADDR_P4 = $0E;
  RX_ADDR_P5 = $0F;
  TX_ADDR = $10;
  RX_PW_P0 = $11;
  RX_PW_P1 = $12;
  RX_PW_P2 = $13;
  RX_PW_P3 = $14;
  RX_PW_P4 = $15;
  RX_PW_P5 = $16;
  FIFO_STATUS = $17;
  DYNPD = $1C;
  FEATURE = $1D;
  { Bit Mnemonics  }
  MASK_RX_DR = 6;
  MASK_TX_DS = 5;
  MASK_MAX_RT = 4;
  EN_CRC = 3;
  CRCO = 2;
  PWR_UP = 1;
  PRIM_RX = 0;
  ENAA_P5 = 5;
  ENAA_P4 = 4;
  ENAA_P3 = 3;
  ENAA_P2 = 2;
  ENAA_P1 = 1;
  ENAA_P0 = 0;
  ERX_P5 = 5;
  ERX_P4 = 4;
  ERX_P3 = 3;
  ERX_P2 = 2;
  ERX_P1 = 1;
  ERX_P0 = 0;
  AW = 0;
  ARD = 4;
  ARC = 0;
  PLL_LOCK = 4;
  RF_DR = 3;
  RF_PWR = 6;
  RX_DR = 6;
  TX_DS = 5;
  MAX_RT = 4;
  RX_P_NO = 1;
  TX_FULL = 0;
  PLOS_CNT = 4;
  ARC_CNT = 0;
  TX_REUSE = 6;
  FIFO_FULL = 5;
  TX_EMPTY = 4;
  RX_FULL = 1;
  RX_EMPTY = 0;
  DPL_P5 = 5;
  DPL_P4 = 4;
  DPL_P3 = 3;
  DPL_P2 = 2;
  DPL_P1 = 1;
  DPL_P0 = 0;
  EN_DPL = 2;
  EN_ACK_PAY = 1;
  EN_DYN_ACK = 0;
  { Instruction Mnemonics  }
  R_REGISTER = $00;
  W_REGISTER = $20;
  REGISTER_MASK = $1F;
  _ACTIVATE = $50;
  R_RX_PL_WID = $60;
  R_RX_PAYLOAD = $61;
  W_TX_PAYLOAD = $A0;
  W_ACK_PAYLOAD = $A8;
  FLUSH_TX = $E1;
  FLUSH_RX = $E2;
  REUSE_TX_PL = $E3;
  NOP = $FF;
  { Non-P omissions  }
  LNA_HCURR = 0;
  { P model memory Map  }
  RPD = $09;
  { P model bit Mnemonics  }
  RF_DR_LOW = 5;
  RF_DR_HIGH = 3;
  RF_PWR_LOW = 1;
  RF_PWR_HIGH = 2;

  //bitrate
  NRF24L01_BR_1M = $00;
  NRF24L01_BR_2M = $08;
  NRF24L01_BR_250K = $20;

  //rf power level
  NRF24L01_PWR_MIN = $00;  //1mW
  NRF24L01_PWR_LOW = $02;  //10mW
  NRF24L01_PWR_MID = $04;  //30mW
  NRF24L01_PWR_MAX = $06;  //100mW

  polynomial = $1021;
  initial = $b5d2;

type

  { TRF24 }

  TRF24 = class
  private

    ce_pin: board_pins;
    csn_pin: board_pins;
    payload_size: byte;
    dynamic_payloads_enabled: boolean;
    RF24Buffer: array [0..31] of byte;
  public
    SPI: TSPIMaster;
    constructor Create(cePin: board_pins; csnPin: board_pins; dynpayload: boolean);
    constructor Create(cePin: board_pins; csnPin: board_pins; payloadsize: byte);
    constructor Create(csnPin: board_pins; payloadsize: byte);
    constructor Create(csnPin: board_pins; dynpayload: boolean);
    destructor Destroy; override;
    procedure init;
    procedure csn(mode: word);
    procedure ce(level: word);
    function read_register(reg: byte; var buf: byte; len: byte): byte;
    function read_register(reg: byte): byte;
    function write_register(reg: byte; var buf: array of byte; len: byte): byte;
    function write_register(reg: byte; buf: string; len: byte): byte;
    function write_register(reg: byte; Value: byte): byte;
    function write_payload(var buf: array of byte; len: byte): byte;
    function write_payload(str: string; len: byte): byte;
    function read_payload(var buf: array of byte; len: byte): byte;
    function flushrx: byte;
    function flushtx: byte;
    procedure activate(code: byte);
    procedure settxmode;
    procedure setrxmode;
    procedure setrfoffmode;
    procedure XN297_SetTXAddr(addr: array of byte; len: word);
    procedure XN297_SetRXAddr(addr: array of byte; len: word);
    procedure XN297_Configure(flags: byte);
    function XN297_WritePayload(msg1: array of byte; len: word): byte;
    function XN297_ReadPayload(var msg: array of byte; len: word): byte;
    function crc16_update(crc1: word; a: byte): word;
    function bit_reverse(b_in: byte): byte;
  end;

var
  xn297_addr_len: word;
  xn297_tx_addr: array [0..4] of byte;
  xn297_rx_addr: array [0..4] of byte;
  xn297_crc: boolean = False;

  xn297_scramble: array [0..34] of
  byte = ($e3, $b1, $4b, $ea, $85, $bc, $e5, $66, $0d, $ae, $8c,
    $88, $12, $69, $ee, $1f, $c7, $62, $97, $d5, $0b, $79, $ca, $cc,
    $1b, $5d, $19, $10, $24, $d3, $dc, $3f, $8e, $c5, $2f);

  xn297_crc_xorout: array [0..27] of
  word = ($0000, $3448, $9BA7, $8BBB, $85E1, $3E8C, $451E,
    $18E6, $6B24, $E7AB, $3828, $814B, $D461, $F494, $2503, $691D,
    $FE8B, $9BA7, $8B17, $2920, $8B5F, $61B1, $D391, $7401, $2138,
    $129F, $B3A0, $2988);


implementation

{ TRF24 }

constructor TRF24.Create(cePin: board_pins; csnPin: board_pins; dynpayload: boolean);
begin
  ce_pin := cePin;
  csn_pin := csnPin;
  dynamic_payloads_enabled := dynpayload;
  payload_size := 32;
  init;
end;

constructor TRF24.Create(cePin: board_pins; csnPin: board_pins; payloadsize: byte);
begin
  ce_pin := cePin;
  csn_pin := csnPin;
  dynamic_payloads_enabled := False;
  payload_size := payloadsize;
  init;
end;

constructor TRF24.Create(csnPin: board_pins; payloadsize: byte);
begin
  ce_pin := NC;
  csn_pin := csnPin;
  dynamic_payloads_enabled := False;
  payload_size := payloadsize;
  init;
end;

constructor TRF24.Create(csnPin: board_pins; dynpayload: boolean);
begin
  ce_pin := NC;
  csn_pin := csnPin;
  dynamic_payloads_enabled := dynpayload;
  payload_size := 32;
  init;
end;

destructor TRF24.Destroy;
begin
  inherited Destroy;
  SPI.Free;
end;

procedure TRF24.init;
begin
  // Initialize SPI bus
  SPI := TSPIMaster.Create(SPI2); //be careful on pin assegnation

  // Initialize pins
  if ce_pin <> NC then
  begin
    pinMode(ce_pin, OUTPUT);
  end;
  pinMode(csn_pin, OUTPUT);

  digitalWrite(ce_pin, HIGH);
  digitalWrite(csn_pin, HIGH);

  delayMicroseconds(5000);

  SPI.setBitOrder(MSBFIRST);
  SPI.setDataMode(SPI_MODE0);
  SPI.setClockDivider(SPI_CLOCK_DIV128);
end;

procedure TRF24.csn(mode: word);
begin
  digitalWrite(csn_pin, mode);
end;

procedure TRF24.ce(level: word);
begin
  if ce_pin <> NC then
  begin
    digitalWrite(ce_pin, level);
  end;
end;

function TRF24.read_register(reg: byte; var buf: byte; len: byte): byte;
begin

end;

function TRF24.read_register(reg: byte): byte;
var
  res: byte;
begin
  csn(LOW);
  SPI.transfer(R_REGISTER or (REGISTER_MASK and reg));
  res := SPI.transfer($ff);
  csn(HIGH);
  Result := res;
end;

function TRF24.write_register(reg: byte; var buf: array of byte; len: byte): byte;
var
  status, index: byte;
begin
  csn(LOW);
  status := SPI.transfer(W_REGISTER or (REGISTER_MASK and reg));
  for index := 0 to len - 1 do
  begin
    SPI.transfer(buf[index]);
  end;
  csn(HIGH);
  Result := status;
end;

function TRF24.write_register(reg: byte; buf: string; len: byte): byte;
var
  status, index: byte;
begin
  csn(LOW);
  status := SPI.transfer(W_REGISTER or (REGISTER_MASK and reg));
  for index := 1 to len do
  begin
    SPI.transfer(byte(buf[index]));
  end;
  csn(HIGH);
  Result := status;
end;

function TRF24.write_register(reg: byte; Value: byte): byte;
var
  status: byte;
begin
  csn(LOW);
  status := SPI.transfer(W_REGISTER or (REGISTER_MASK and reg));
  SPI.transfer(Value);
  csn(HIGH);
  Result := status;
end;

function TRF24.write_payload(var buf: array of byte; len: byte): byte;
var
  status, index: byte;
begin
  ce(LOW);
  csn(LOW);
  status := SPI.transfer(W_TX_PAYLOAD);
  for index := 0 to len - 1 do
  begin
    SPI.transfer(buf[index]);
  end;
  csn(HIGH);
  ce(HIGH);
  Result := status;
end;

function TRF24.write_payload(str: string; len: byte): byte;
var
  status, index: byte;
begin
  // ce(LOW);
  csn(LOW);
  status := SPI.transfer(W_TX_PAYLOAD);
  for index := 1 to len do
  begin
    SPI.transfer(byte(str[index]));
  end;
  csn(HIGH);
  // ce(HIGH);
  Result := status;
end;

function TRF24.read_payload(var buf: array of byte; len: byte): byte;
var
  i: byte;
begin
  csn(LOW);
  spi.transfer(R_RX_PAYLOAD); // Read RX payload
  for i := 0 to len - 1 do
  begin
    buf[i] := spi.transfer($FF);
  end;
  csn(HIGH);
  Result := 1;
end;



function TRF24.flushrx: byte;
var
  status: byte;
begin
  csn(LOW);
  status := SPI.transfer(FLUSH_RX);
  csn(HIGH);
  Result := status;
end;

function TRF24.flushtx: byte;
var
  status: byte;
begin

  csn(LOW);
  status := SPI.transfer(FLUSH_TX);
  csn(HIGH);
  Result := status;
end;

procedure TRF24.activate(code: byte);
begin
  csn(LOW);
  SPI.transfer(_ACTIVATE);
  SPI.transfer(code);
  csn(HIGH);
end;

procedure TRF24.settxmode;
begin
  ce(LOW);
  write_register(STATUS, (1 shl RX_DR) or (1 shl TX_DS) or (1 shl MAX_RT));
  write_register(CONFIG, (1 shl EN_CRC) or (1 shl CRCO) or (1 shl PWR_UP));
  delaymicroseconds(130);
  ce(HIGH);
end;

procedure TRF24.setrxmode;
begin
  ce(LOW);
  write_register(STATUS, $70);
  write_register(CONFIG, $0F);
  write_register(STATUS, (1 shl RX_DR) or (1 shl TX_DS) or (1 shl MAX_RT));
  write_register(CONFIG, (1 shl EN_CRC) or (1 shl CRCO) or (1 shl PWR_UP) or
    (1 shl PRIM_RX));
  delaymicroseconds(130);
  ce(HIGH);
end;

procedure TRF24.setrfoffmode;
begin
  Write_Register(CONFIG, (1 shl EN_CRC)); //PowerDown
  ce(LOW);
end;

procedure TRF24.XN297_SetTXAddr(addr: array of byte; len: word);
var
  buf: array[0..4] of byte = ($55, $0F, $71, $0C, $00);
  i: byte;
begin
  if (len > 5) then
  begin
    len := 5;
  end;
  if (len < 3) then
  begin
    len := 3;
  end;
  xn297_addr_len := len;
  if xn297_addr_len < 4 then
  begin
    for i := 0 to 3 do
    begin
      buf[i] := buf[i + 1];
    end;
  end;
  Write_Register(SETUP_AW, len - 2);
  Write_Register(TX_ADDR, buf, 5);
  move(addr, xn297_tx_addr, len);

end;

procedure TRF24.XN297_SetRXAddr(addr: array of byte; len: word);
var

  buf: array[0..4] of byte = (0, 0, 0, 0, 0);
  i: byte;
begin
  if (len > 5) then
  begin
    len := 5;
  end;
  if (len < 3) then
  begin
    len := 3;
  end;
  move(addr, buf, len);
  move(addr, xn297_rx_addr, len);
  for i := 0 to xn297_addr_len - 1 do
  begin
    buf[i] := (xn297_rx_addr[i] xor xn297_scramble[xn297_addr_len - i - 1]);
  end;
  Write_Register(SETUP_AW, len - 2);
  Write_Register(RX_ADDR_P0, buf, 5);
end;

procedure TRF24.XN297_Configure(flags: byte);
begin
  if (flags and (1 shl EN_CRC)) <> 0 then
  begin
    xn297_crc := True;
  end
  else
  begin
    xn297_crc := False;
  end;
  flags := flags and not (byte((1 shl EN_CRC) or (1 shl CRCO)));
  Write_Register(CONFIG, flags);
end;

function TRF24.XN297_WritePayload(msg1: array of byte; len: word): byte;
var
  mypacket: array[0..31] of byte;
  offset, last, res, i, a, b_out: byte;
  crc: word;
begin
  last := 0;
  if (xn297_addr_len < 4) then
  begin
    mypacket[last] := $55;
    Inc(last);
  end;
  for i := 0 to xn297_addr_len - 1 do
  begin
    mypacket[last] := xn297_tx_addr[xn297_addr_len - i - 1] xor xn297_scramble[i];
    Inc(last);
  end;
  for i := 0 to len - 1 do
  begin
    // bit-reverse bytes in packet
    b_out := bit_reverse(msg1[i]);
    mypacket[last] := b_out xor xn297_scramble[xn297_addr_len + i];
    Inc(last);
  end;
  if xn297_crc = True then
  begin
    offset := 0;
    if xn297_addr_len < 4 then
    begin
      offset := 1;
    end;
    crc := initial;
    for i := offset to last - 1 do
    begin
      crc := crc16_update(crc, mypacket[i]);
    end;
    crc := crc xor xn297_crc_xorout[xn297_addr_len - 3 + len];
    mypacket[last] := highbyte(crc);
    Inc(last);
    mypacket[last] := lowbyte(crc);
    Inc(last);
  end;
  Result := Write_Payload(mypacket, last);
end;

function TRF24.XN297_ReadPayload(var msg: array of byte; len: word): byte;
var
  i: byte;
begin

  // TODO: if xn297_crc==1, check CRC before filling *msg
  Result := Read_Payload(msg, len);
  for i := 0 to len - 1 do
  begin
    msg[i] := bit_reverse(msg[i]) xor bit_reverse(xn297_scramble[i + xn297_addr_len]);
  end;
end;

function TRF24.crc16_update(crc1: word; a: byte): word;
var
  i: byte;
begin
  crc1 := crc1 xor (a shl 8);
  for i := 0 to 7 do
  begin
    if (crc1 and $8000) > 0 then
    begin
      crc1 := crc1 shl 1;
      crc1 := crc1 xor polynomial;
    end
    else
    begin
      crc1 := crc1 shl 1;
    end;

  end;

  Result := crc1;
end;

function TRF24.bit_reverse(b_in: byte): byte;
var
  b_out, i: byte;
begin
  b_out := 0;
  for i := 0 to 7 do
  begin
    b_out := (b_out shl 1) or (b_in and 1);
    b_in := b_in shr 1;
  end;
  Result := b_out;
end;

end.