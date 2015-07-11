unit HWTimer;


//simple class for simple hadware timer, please refer to standard periphery library to get advanced function


interface

uses
  stm32f103fw;

type

  { TTimer_STM32 }

  TTimer_STM32 = class
  private
    thisTimer: ^TTimerRegisters;
    thisTimerInitStructure: TIM_TimeBaseInitTypeDef;
    interrupt_enabled: TState;
    NVIC_InitStructure: TNVIC_InitTypeDef;
  public

    constructor Create(var TIMx: TTimerRegisters; interrupt_enable: TState);
    destructor Destroy; override;
    procedure setIntervalms(value_ms: longint);
    procedure setIntervalus(value_us: longint);
    procedure updateIntervalus(value_us: longint);
    procedure updateIntervalms(value_ms: longint);
    procedure enableInterrupt(prio: word);
    procedure start;
    procedure stop;
  end;

var
  sysTimer1, sysTimer2, sysTimer3: TTimer_STM32;

implementation


{ TTimer_STM32 }

constructor TTimer_STM32.Create(var TIMx: TTimerRegisters; interrupt_enable: TState);
begin
  thisTimer := @TIMx;
  TIM_DeInit(thisTimer^);
  if thisTimer = @Timer1 then
  begin
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_TIM1, Enabled);
  end;
  if thisTimer = @Timer2 then
  begin
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM2, Enabled);
  end;
  if thisTimer = @Timer3 then
  begin
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM3, Enabled);
  end;
  if thisTimer = @Timer4 then
  begin
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM4, Enabled);
  end;
  thisTimerInitStructure.TIM_ClockDivision := TIM_CKD_DIV1;
  thisTimerInitStructure.TIM_CounterMode := TIM_CounterMode_Up;
  thisTimerInitStructure.TIM_RepetitionCounter := 0;
  interrupt_enabled := interrupt_enable;
end;

destructor TTimer_STM32.Destroy;
begin
  stop;
  TIM_DeInit(thisTimer^);
  inherited Destroy;
end;

procedure TTimer_STM32.setIntervalms(value_ms: longint);
begin
  if value_ms > 0 then
  begin
    thisTimerInitStructure.TIM_Period := value_ms * 2 - 1;
  end
  else
  begin
    thisTimerInitStructure.TIM_Period := 0;
  end;
  thisTimerInitStructure.TIM_Prescaler := 36000;
end;

procedure TTimer_STM32.setIntervalus(value_us: longint);
begin
  thisTimerInitStructure.TIM_Period := value_us * 2 - 1;
  thisTimerInitStructure.TIM_Prescaler := 36;

  //SystemClock = 72000000
  //the value is SYSTEMCLOCK / PRESCALER * PERIOD
end;

procedure TTimer_STM32.updateIntervalus(value_us: longint);
begin
  thisTimer^.ARR := value_us * 2 - 1;
  thisTimer^.PSC := 36;
end;

procedure TTimer_STM32.updateIntervalms(value_ms: longint);
begin
  thisTimer^.ARR := value_ms * 2 - 1;
  thisTimer^.PSC := 36000;
end;

procedure TTimer_STM32.enableInterrupt(prio: word);
begin
  TIM_ITConfig(thisTimer^, TIM_IT_Update, interrupt_enabled);
  if thisTimer = @Timer1 then
  begin
    NVIC_InitStructure.NVIC_IRQChannel := TIM1_UP_IRQChannel;
  end;
  if thisTimer = @Timer2 then
  begin
    NVIC_InitStructure.NVIC_IRQChannel := TIM2_IRQChannel;
  end;
  if thisTimer = @Timer3 then
  begin
    NVIC_InitStructure.NVIC_IRQChannel := TIM3_IRQChannel;
  end;
  if thisTimer = @Timer4 then
  begin
    NVIC_InitStructure.NVIC_IRQChannel := TIM4_IRQChannel;
  end;

  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority := prio;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority := prio;
  NVIC_InitStructure.NVIC_IRQChannelCmd := interrupt_enabled;
  NVIC_Init(NVIC_InitStructure);
end;

procedure TTimer_STM32.start;
begin
  TIM_TimeBaseInit(thisTimer^, thisTimerInitStructure);
  TIM_Cmd(thisTimer^, Enabled);
  //  enableInterrupt(interrupt_enabled);
end;

procedure TTimer_STM32.stop;
begin
  interrupt_enabled := Disabled;
  enableInterrupt(0);
  TIM_Cmd(thisTimer^, Disabled);
end;



end.
