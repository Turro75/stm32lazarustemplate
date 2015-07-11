unit Arduino_compat;

{
try to simulate most used and useful arduino libs
this should speed up the productivity for anyone
who has to learn both STM32 and fpc....
moreover the 3thparty library translation should be faster

Most lines are freely taken from libmaple and arduino sources

I'll drop this unit when enough skilled on stm32 libs and
if the code size requirements for this layer will grow too much
}



interface

uses
  stm32f103fw;

const
  HIGH = 1;
  LOW = 0;
  INPUT = GPIO_Mode_IN_FLOATING;
  INPUT_PULLUP = GPIO_Mode_IPU;
  INPUT_PULLDOWN = GPIO_Mode_IPD;
  OUTPUT = GPIO_Mode_Out_PP;
  INPUT_ANALOG = GPIO_Mode_AIN;
  LSBFIRST = 1;
  MSBFIRST = 0;


type

  board_pins =
    (PA0, PA1, PA2, PA3, PA4, PA5, PA6, PA7, PA8, PA9, PA10, PA11,
    PA12, PA15,
    PB0, PB1, PB3, PB4, PB5, PB6, PB7, PB8, PB9, PB10, PB11,
    PB12, PB13, PB14, PB15,
    PC13, PC14, PC15, NC);


  board_pin_config = record

    Port: ^TPortRegisters;   //pointer to Gpio Port
    Pin: word;               //pin number
    RCCSource: word;         //relevant clock
    ADChannel: word;         //number of adc channel, $100 if not analog input
  end;




//Digital-Analog Standard Pin IO
procedure pinMode(pin: board_pins; mode: word);    //still analoginput to be fixed
procedure digitalWrite(pin: board_pins; Value: word);
function digitalRead(pin: board_pins): byte;
function analogRead12bit(pin: board_pins): word; //native 12bit
function analogRead8bit(pin: board_pins): word;  //8 bit..not native
function analogRead(pin: board_pins): word;  //10bit....not native
procedure analogWrite(pin: board_pins; Value: integer);
procedure togglePin(pin: board_pins);
procedure toggleLED;
procedure shiftOut(dataPin: board_pins; clockPin: board_pins; bitOrder: word; val: byte);
function shiftIn(dataPin: board_pins; clockPin: board_pins; bitOrder: word): byte;

//general purpose
function map(x, in_min, in_max, out_min, out_max: longword): longword;
function constrain(x, min, max: longword): longword;
function min(First, second: longword): longword;
function max(First, second: longword): longword;
function highbyte(Value: word): byte;
function lowbyte(Value: word): byte;

//Math
function Power(Base: longint; Expon: longint): longint;
function Power(Base: double; Expon: double): double;




//time
procedure delay(ms_delay: dword);
procedure delayMicroseconds(us_delay: longint);
//simple wrapper for stm32 libs delay_us(longint);


//helper functions
procedure init_ADC1;
function decstr(msg: longint; outLength: word): string;


const
  PIN_LED = PC13;   //pin led on minimum development board (STM32F103C8T6)
  // PIN_LED = PB1;  pin led on maple mini leaf/baite  (STM32F103CBT6)

var
  Pin_MAP: array [PA0..PC15] of board_pin_config;
  Pin_: array [PA0..PC15] of byte = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
    10, 11, 12, 15, 0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 13, 14, 15);
  ADC_: array [PA0..PC15] of word = ($000, $001, $002, $003, $004,       //defines which pin has input analog
    $005, $006, $007, $100, $100, $100, $100, $100, $100, $008, $009,
    $100, $100, $100, $100, $100, $100, $100, $100, $100, $100, $100,
    $100, $100, $100, $100, $100);
  numAdcChannels: word;   {//$0 no adc activated }
//$1 PA0 activated
//$2 PA1 activated



implementation




//Digital-Analog Standard Pin IO
procedure pinMode(pin: board_pins; mode: word);
var
  GPIO_InitStructure: TGPIO_InitTypeDef;
begin
  RCC_APB2PeriphClockCmd(RCC.APB2ENR or Pin_Map[pin].RCCSource, Enabled);

  GPIO_InitStructure.GPIO_Pin := Pin_Map[pin].Pin;
  GPIO_InitStructure.GPIO_Speed := GPIO_Speed_50MHz;

  if mode = INPUT then
  begin
    GPIO_InitStructure.GPIO_Mode := GPIO_Mode_IN_FLOATING;
  end
  else
  if mode = INPUT_PULLDOWN then
  begin
    GPIO_InitStructure.GPIO_Mode := GPIO_Mode_IPD;
  end
  else
  if mode = INPUT_PULLUP then
  begin
    GPIO_InitStructure.GPIO_Mode := GPIO_Mode_IPU;
  end
  else
  if mode = INPUT_ANALOG then
  begin
    Init_ADC1;   //Todo /> manage multiple channels
    GPIO_InitStructure.GPIO_Mode := GPIO_Mode_AIN;
  end
  else
  if mode = OUTPUT then
  begin
    GPIO_InitStructure.GPIO_Mode := GPIO_Mode_Out_PP;
  end
  else
  begin
    //wrong mode value
  end;
  GPIO_init(Pin_Map[pin].Port^, GPIO_InitStructure);
end;

procedure digitalWrite(pin: board_pins; Value: word);
begin
  Pin_Map[pin].Port^.BSRR := longword(Pin_Map[pin].Pin) shl (16 * Ord(not boolean(Value)));
  // if Value = 1 then
  //   GPIO_SetBits(Pin_Map[pin].Port^, Pin_Map[pin].Pin)
  // else
  //   GPIO_ResetBits(Pin_Map[pin].Port^, Pin_Map[pin].Pin);
end;


function digitalRead(pin: board_pins): byte;
begin
  digitalRead := GPIO_ReadInputDataBit(Pin_Map[pin].Port^, Pin_Map[pin].Pin);
end;

function analogRead12bit(pin: board_pins): word;
var
  adcvalue: word;
begin
  ADC_RegularChannelConfig(ADC1, Pin_Map[pin].ADChannel, 1, ADC_SampleTime_1Cycles5);
  // Start ADC1 Software Conversion */
  ADC_SoftwareStartConvCmd(ADC1, Enabled);

  while (not ADC_GetFlagStatus(ADC1, ADC_FLAG_EOC)) do
  begin
  end;

  adcvalue := ADC_GetConversionValue(ADC1);
  ADC_ClearFlag(ADC1, ADC_FLAG_EOC);
  Result := adcvalue;
end;

function analogRead(pin: board_pins): word;
begin
  Result := map(analogRead12bit(pin), 0, 4095, 0, 1023);
end;

function analogRead8bit(pin: board_pins): word;
begin
  Result := map(analogRead12bit(pin), 0, 4095, 0, 255);
end;

{ TODO : write PWM out function, not a big fun of this..... }
procedure analogWrite(pin: board_pins; Value: integer);
begin

end;

procedure togglePin(pin: board_pins);
begin
  //check if GPIOx.BSRR and Map_Pin[pin]
  if ((Pin_Map[pin].Port^.IDR and Pin_Map[pin].Pin) = Pin_Map[pin].Pin) then //pin is set
  begin
    GPIO_ResetBits(Pin_Map[pin].Port^, Pin_Map[pin].Pin);
  end
  else
  begin
    GPIO_SetBits(Pin_Map[pin].Port^, Pin_Map[pin].Pin);
  end;
end;

procedure toggleLED;
begin
  //PC13 is the led on maple mini clone
  togglePin(PC13);
end;


procedure shiftOut(dataPin: board_pins; clockPin: board_pins; bitOrder: word; val: byte);
var
  i: byte;
begin
  for i := 0 to 7 do
  begin
    if (bitOrder = LSBFIRST) then
    begin
      if (val and (1 shl i) > 0) then
      begin
        digitalWrite(dataPin, HIGH);
      end
      else
      begin
        digitalWrite(dataPin, LOW);
      end;
    end
    else
    begin
      if (val and (1 shl (7 - i)) > 0) then
      begin
        digitalWrite(dataPin, HIGH);
      end
      else
      begin
        digitalWrite(dataPin, LOW);
      end;
    end;
    digitalWrite(clockPin, HIGH);
    digitalWrite(clockPin, LOW);

  end;
end;

function shiftIn(dataPin: board_pins; clockPin: board_pins; bitOrder: word): byte;
var
  Value, i: byte;
begin
  Value := 0;
  for i := 0 to 7 do
  begin
    digitalWrite(clockPin, HIGH);
    if (bitOrder = LSBFIRST) then
    begin
      Value := Value or (digitalRead(dataPin) shl i);
    end
    else
    begin
      Value := Value or (digitalRead(dataPin) shl (7 - i));
    end;
    digitalWrite(clockPin, LOW);
  end;
  Result := Value;
end;

//general purpose

function map(x, in_min, in_max, out_min, out_max: longword): longword;
begin
  map := (x - in_min) * (out_max - out_min) div (in_max - in_min) + out_min;
end;

function constrain(x, min, max: longword): longword;
begin
  if (x <= min) then
  begin
    Result := min;
  end;
  if (x > min) and (x < max) then
  begin
    Result := x;
  end;
  if (x >= max) then
  begin
    Result := max;
  end;

end;

function min(First, second: longword): longword;
begin
  if (First > second) then
  begin
    Result := second;
  end
  else
  begin
    Result := First;
  end;
end;


//Math functions
function Power(Base: longint; Expon: longint): longint;
begin
  Result := round(exp(Expon * ln(Base)));
end;


function Power(Base: double; Expon: double): double;
begin
  Result := exp(Expon * ln(Base));
end;

//Time functions

function max(First, second: longword): longword;
begin
  if (First > second) then
  begin
    Result := First;
  end
  else
  begin
    Result := second;
  end;
end;

function highbyte(Value: word): byte;
begin
  Result := (Value shr 8) and $FF;
end;

function lowbyte(Value: word): byte;
begin
  Result := byte(Value and $FF);
end;

procedure delay(ms_delay: dword);
begin
  delay_ms(ms_delay);
end;

procedure delayMicroseconds(us_delay: longint);
begin
  delay_us(us_delay);
end;

procedure init_ADC1;
var
  GPIO_InitStructure: TGPIO_InitTypeDef;
  ADC_InitStructure: TADC_InitTypeDef;
begin
  RCC_ADCCLKConfig(RCC_PCLK2_Div6);
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_ADC1, Enabled);

  // ADC1 configuration ------------------------------------------------------*/
  ADC_InitStructure.ADC_Mode := ADC_Mode_Independent;
  ADC_InitStructure.ADC_ScanConvMode := DISABLED; // Single Channel
  ADC_InitStructure.ADC_ContinuousConvMode := DISABLED; // Scan on Demand
  ADC_InitStructure.ADC_ExternalTrigConv := ADC_ExternalTrigConv_None;
  ADC_InitStructure.ADC_DataAlign := ADC_DataAlign_Right;
  //I have to study a way to automatically manage the number of channel
  //involved, maybe an array of boolean?
  ADC_InitStructure.ADC_NbrOfChannel := 8;
  ADC_Init(ADC1, ADC_InitStructure);

  //* ADC1 regular channel1 configuration */


  //* Enable ADC1 */
  ADC_Cmd(ADC1, Enabled);

  //* Enable ADC1 reset calibaration register */
  ADC_ResetCalibration(ADC1);

  //* Check the end of ADC1 reset calibration register */
  while (ADC_GetResetCalibrationStatus(ADC1)) do
  begin
  end;

  //* Start ADC1 calibaration */
  ADC_StartCalibration(ADC1);

  //* Check the end of ADC1 calibration */
  while (ADC_GetCalibrationStatus(ADC1)) do
  begin
  end;
end;


function decstr(msg: longint; outLength: word): string;
var
  tmpstr: string;
begin
  Str(msg, tmpstr);
  if outLength > length(tmpstr) then
  begin
    while length(tmpstr) < outLength do
    begin
      tmpstr := '0' + tmpstr;
    end;
  end;
  Result := tmpstr;
end;

end.