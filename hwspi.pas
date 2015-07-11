unit HWSPI;



interface

uses
  stm32f103fw;

type
  TSPIMaster = class
  private
    thisSPI: ^TSPIRegisters;
    thisIRQChannel: word;
  public
    procedure setBitOrder(Value: byte);
    procedure setClockDivider(Value: byte);
    procedure setDataMode(Value: byte);
    function transfer(Data: word): word;
    constructor Create(var spi: TSPIRegisters);
    destructor Destroy; override;
  end;

const
  SPI_MODE0 = 0;
  SPI_MODE1 = 2;
  SPI_MODE2 = 2;
  SPI_MODE3 = 3;


  SPI_CLOCK_DIV2 = SPI_BaudRatePrescaler_2;
  SPI_CLOCK_DIV4 = SPI_BaudRatePrescaler_4;
  SPI_CLOCK_DIV8 = SPI_BaudRatePrescaler_8;
  SPI_CLOCK_DIV16 = SPI_BaudRatePrescaler_16;
  SPI_CLOCK_DIV32 = SPI_BaudRatePrescaler_32;
  SPI_CLOCK_DIV64 = SPI_BaudRatePrescaler_64;
  SPI_CLOCK_DIV128 = SPI_BaudRatePrescaler_128;
  SPI_CLOCK_DIV256 = SPI_BaudRatePrescaler_256;


var
  SPIA, SPIB: TSPIMaster;


implementation

procedure TSPIMaster.setBitOrder(Value: byte);
begin
  //dummy, all done in the Create method
  //  SPI_InitStructure.SPI_FirstBit := SPI_FirstBit_MSB;
end;

procedure TSPIMaster.setClockDivider(Value: byte);
begin
  //dummy, all done in the Create method
  //  SPI_InitStructure.SPI_BaudRatePrescaler := SPI_BaudRatePrescaler_16;
end;

procedure TSPIMaster.setDataMode(Value: byte);
begin
  //dummy, all done in the Create method
  //  SPI_InitStructure.SPI_Mode := SPI_Mode_Master;
end;

function TSPIMaster.transfer(Data: word): word;
var
  tmpdata: word;
begin
  thisSPI^.DR := Data;
  while (SPI_I2S_GetFlagStatus(thisSPI^, SPI_I2S_FLAG_RXNE) <> True) do
  begin
  end;
  tmpdata := thisSPI^.DR;
  while (SPI_I2S_GetFlagStatus(thisSPI^, SPI_I2S_FLAG_TXE) <> True) do
  begin
  end;
  while ((thisSPI^.SR and SPI_I2S_FLAG_BSY) <> 0) do
  begin
  end;
  Result := tmpdata;
end;

constructor TSPIMaster.Create(var spi: TSPIRegisters);
var
  SPI_InitStructure: TSPI_InitTypeDef;
  GPIO_InitStructure: TGPIO_InitTypeDef;
begin
  thisSPI := @spi;
  GPIO_InitStructure.GPIO_Speed := GPIO_Speed_50MHz;
  GPIO_InitStructure.GPIO_Mode := GPIO_Mode_AF_PP;
  if thisSPI = @SPI1 then
  begin
    //* Configure SPI1 pins: SCK, MISO and MOSI ---------------------------------*/
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA or RCC_APB2Periph_SPI1, Enabled);
    GPIO_InitStructure.GPIO_Pin := GPIO_Pin_5 or GPIO_Pin_6 or GPIO_Pin_7;
    GPIO_Init(PortA, GPIO_InitStructure);
  end;
  if thisSPI = @SPI2 then
  begin
    //* Configure SPI2 pins: SCK, MISO and MOSI ---------------------------------*/
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, Enabled);
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_SPI2, Enabled);
    GPIO_InitStructure.GPIO_Pin := GPIO_Pin_13 or GPIO_Pin_14 or GPIO_Pin_15;
    GPIO_Init(PortB, GPIO_InitStructure);
  end;

  //specific configuration for SPI, MASTER ONLY for now...

  SPI_InitStructure.SPI_Direction := SPI_Direction_2Lines_FullDuplex;
  SPI_InitStructure.SPI_Mode := SPI_Mode_Master;
  SPI_InitStructure.SPI_DataSize := SPI_DataSize_8b;
  SPI_InitStructure.SPI_CPOL := SPI_CPOL_Low;
  SPI_InitStructure.SPI_CPHA := SPI_CPHA_1Edge;
  SPI_InitStructure.SPI_NSS := SPI_NSS_Soft;
  SPI_InitStructure.SPI_BaudRatePrescaler := SPI_BaudRatePrescaler_32;
  SPI_InitStructure.SPI_FirstBit := SPI_FirstBit_MSB;
  SPI_InitStructure.SPI_CRCPolynomial := 7;
  SPI_Init(thisSPI^, SPI_InitStructure);

  SPI_Cmd(thisSPI^, Enabled);
end;

destructor TSPIMaster.Destroy;
begin
  SPI_I2S_DeInit(thisSPI^);
end;


end.
