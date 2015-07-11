unit HWSerial;

{
Simple class to manage Hardware serial ports, fully working Usart1 and Usart3
I'll investigate further why Usart2 doesn't work but only when SPI, I2C
and NokiaLCD will become ready
}




interface

uses
  stm32f103fw;

type

  { TSTM32Serial }

  TSTM32Serial = class
  private
    thisUsart: ^TUSARTRegisters;
    thisIRQChannel: word;

  public
    constructor Create(var ser: TUSARTRegisters; baudrate: longword);
    destructor Destroy; override;
    // procedure start(baudrate : longword);
    // procedure stop;
    procedure print(msg: string);
    procedure print(msg: longint);
    procedure print(msg: longint; base: word);
    procedure println(msg: string);
    procedure println;
    procedure Write(msd: byte);
    function Read: byte;
    function readBytes(var msg: string; length: word): word;
    procedure enableInterrupt(mode: TState);
  end;


var
  Serial1, Serial2, Serial3: TSTM32Serial;




implementation


//Class Serial
constructor TSTM32Serial.Create(var ser: TUSARTRegisters; baudrate: longword);
var
  USART_InitStructure: TUSART_InitTypeDef;
  GPIO_InitStructure: TGPIO_InitTypeDef;
  rxpin, txpin: longword;
  serport: ^TPortRegisters;
begin
  thisUsart := @ser;
  if thisUsart = @USART1 then
  begin
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1 or RCC_APB2Periph_AFIO, Enabled);
    thisIRQChannel := USART1_IRQChannel;
    rxpin := GPIO_Pin_10;
    txpin := GPIO_Pin_9;
    serport := @PortA;
  end;
  if thisUsart = @USART2 then
  begin
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART2, Enabled);
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA or RCC_APB2Periph_AFIO, Enabled);
    thisIRQChannel := USART2_IRQChannel;
    rxpin := GPIO_Pin_2;
    txpin := GPIO_Pin_3;
    serport := @PortA;
  end;
  if thisUsart = @USART3 then
  begin
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART3, Enabled);
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB or RCC_APB2Periph_AFIO, Enabled);
    thisIRQChannel := USART3_IRQChannel;
    rxpin := GPIO_Pin_11;
    txpin := GPIO_Pin_10;
    serport := @PortB;
  end;
  // Configure USART1 pins (Debug Interface)
  GPIO_InitStructure.GPIO_Pin := rxpin;                // (RX)
  GPIO_InitStructure.GPIO_Mode := GPIO_Mode_IN_FLOATING;
  GPIO_Init(serport^, GPIO_InitStructure);
  GPIO_InitStructure.GPIO_Pin := txpin;                // (TX)
  GPIO_InitStructure.GPIO_Speed := GPIO_Speed_50MHz;
  GPIO_InitStructure.GPIO_Mode := GPIO_Mode_AF_PP;
  GPIO_Init(serport^, GPIO_InitStructure);
  // UART init struct
  USART_Cmd(thisUsart^, Enabled);
  USART_StructInit(USART_InitStructure);
  USART_InitStructure.USART_WordLength := USART_WordLength_8b;
  USART_InitStructure.USART_StopBits := USART_StopBits_1;
  USART_InitStructure.USART_Parity := USART_Parity_No;
  USART_InitStructure.USART_Mode := USART_Mode_Rx or USART_Mode_Tx;
  USART_InitStructure.USART_HardwareFlowControl := USART_HardwareFlowControl_None;
  USART_InitStructure.USART_BaudRate := baudrate;
  USART_Init(thisUsart^, USART_InitStructure);

end;

destructor TSTM32Serial.Destroy;

begin
  USART_DeInit(thisUsart^);
end;

procedure TSTM32Serial.print(msg: string);
begin
  USART_SendString(thisUsart^, msg);
end;

procedure TSTM32Serial.print(msg: longint);
var
  tmpstr: string;
begin
  Str(msg, tmpstr);
  USART_SendString(thisUsart^, tmpstr);
end;


procedure TSTM32Serial.print(msg: longint; base: word);
var
  len, tmplen: word;
begin
  //get minimum length string needed to contain the number:

  len := 0;
  tmplen := msg;
  while (tmplen > 0) do
  begin
    tmplen := tmplen div base;
    Inc(len);
  end;

  case base of
    2:
    begin
      USART_SendString(thisUsart^, binstr(msg, len + 1));
    end;
    8:
    begin
      USART_SendString(thisUsart^, octstr(msg, len));
    end;
    16:
    begin
      USART_SendString(thisUsart^, hexstr(msg, len));
    end;
    else
    begin
      print(msg);
    end;
  end;

end;


procedure TSTM32Serial.println(msg: string);
begin
  USART_SendString(thisUsart^, msg + #13 + #10);
end;

procedure TSTM32Serial.println;
begin
  USART_SendString(thisUsart^, #13 + #10);
end;

procedure TSTM32Serial.Write(msd: byte);
begin
  USART_SendData(thisUsart^, msd);
end;

function TSTM32Serial.Read: byte;
begin
  Result := 0;
end;

function TSTM32Serial.readBytes(var msg: string; length: word): word;
begin
  Result := 0;
end;

procedure TSTM32Serial.enableInterrupt(mode: TState);
var
  NVIC_InitStructure: TNVIC_InitTypeDef;
begin
  // Enable interrupts
  //then manually go to unit interrupts and uncomment the requested interrupt routine
  //setup USARTx Interrupt
  //  NVIC_PriorityGroupConfig(NVIC_PriorityGroup_0);
  NVIC_InitStructure.NVIC_IRQChannel := thisIRQChannel;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority := 1;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority := 1;
  NVIC_InitStructure.NVIC_IRQChannelCmd := mode;
  NVIC_Init(NVIC_InitStructure);
  USART_ITConfig(thisUsart^, USART_IT_RXNE, mode);
end;

//End Class Serial

end.