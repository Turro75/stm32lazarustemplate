unit interrupts;



{$mode objfpc}{$H+}

interface

uses
  Arduino_compat, HWSerial, HWTimer, stm32f103fw;

procedure setup_interrupts;

var
  globaltimervar: longint = 0;
  throttle: byte;



implementation

procedure setup_interrupts;
var
  NVIC_InitStructure: TNVIC_InitTypeDef;
begin
  //may be better to create a single procedure for every interrupt source,
  //i.e. enable_USART1_IT(bool);
  //reported there and the user can simply comment/uncomment the required interrupt source required
  //of course in case of over simple init sequence,
  DMA_ITConfig(DMA1.Channel[0], DMA_IT_TC, Enabled);
  //  NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2);
  //Enable DMA1 channel IRQ Channel */
  NVIC_InitStructure.NVIC_IRQChannel := DMAChannel1_IRQChannel;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority := 0;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority := 0;
  NVIC_InitStructure.NVIC_IRQChannelCmd := Enabled;
  NVIC_Init(NVIC_InitStructure);


  if sysTimer1 <> nil then
  begin
    sysTimer1.enableInterrupt(0);
  end;
  if sysTimer2 <> nil then
  begin
    sysTimer2.enableInterrupt(4);
  end;
  if sysTimer3 <> nil then
  begin
    sysTimer3.enableInterrupt(0);
  end;

  if Serial1 <> nil then
  begin
    Serial1.enableInterrupt(DISABLED);
  end;
  if Serial2 <> nil then
  begin
    Serial2.enableInterrupt(Enabled);
  end;
  if Serial3 <> nil then
  begin
    Serial3.enableInterrupt(Enabled);
  end;
end;

{
procedure NMI_interrupt; [public, alias: 'NMI_interrupt'];
begin
end;
}
{
procedure Hardfault_interrupt; [public, alias: 'Hardfault_interrupt'];
begin
end;
}
{
procedure MemManage_interrupt; [public, alias: 'MemManage_interrupt'];
begin
end;
}
{
procedure BusFault_interrupt; [public, alias: 'BusFault_interrupt'];
begin
end;
}
{
procedure UsageFault_interrupt; [public, alias: 'UsageFault_interrupt'];
begin
end;
}
{
procedure SWI_interrupt; [public, alias: 'SWI_interrupt'];
begin
end;
}
{
procedure DebugMonitor_interrupt; [public, alias: 'DebugMonitor_interrupt'];
begin
end;
}
{
procedure PendingSV_interrupt; [public, alias: 'PendingSV_interrupt'];
begin
end;
}

//This is in the file __PROJNAME__.lpr please modify it only if You know very well what are you doing!!
//procedure SysTick_interrupt; [public, alias: 'SysTick_interrupt'];
//begin
//   SysTickDelayCounter
//end;

{
procedure Window_watchdog_interrupt; [public, alias: 'Window_watchdog_interrupt'];
begin
end;
}
{
procedure PVD_through_EXTI_Line_detection_interrupt; [public, alias: 'PVD_through_EXTI_Line_detection_interrupt'];
begin
end;
}
{
procedure Tamper_interrupt; [public, alias: 'Tamper_interrupt'];
begin
end;
}
{
procedure RTC_global_interrupt; [public, alias: 'RTC_global_interrupt'];
begin
end;
}
{
procedure Flash_global_interrupt; [public, alias: 'Flash_global_interrupt'];
begin
end;
}
{
procedure RCC_global_interrupt; [public, alias: 'RCC_global_interrupt'];
begin
end;
}
{
procedure EXTI_Line0_interrupt; [public, alias: 'EXTI_Line0_interrupt'];
begin
end;
}
{
procedure EXTI_Line1_interrupt; [public, alias: 'EXTI_Line1_interrupt'];
begin
end;
}
{
procedure EXTI_Line2_interrupt; [public, alias: 'EXTI_Line2_interrupt'];
begin
end;
}
{
procedure EXTI_Line3_interrupt; [public, alias: 'EXTI_Line3_interrupt'];
begin
end;
}
{
procedure EXTI_Line4_interrupt; [public, alias: 'EXTI_Line4_interrupt'];
begin
end;
}
{
procedure DMA1_Channel1_global_interrupt; [public, alias: 'DMA1_Channel1_global_interrupt'];
begin


end;
}
{
procedure DMA1_Channel2_global_interrupt; [public, alias: 'DMA1_Channel2_global_interrupt'];
begin
end;
}
{
procedure DMA1_Channel3_global_interrupt; [public, alias: 'DMA1_Channel3_global_interrupt'];
begin
end;
}
{
procedure DMA1_Channel4_global_interrupt; [public, alias: 'DMA1_Channel4_global_interrupt'];
begin
end;
}
{
procedure DMA1_Channel5_global_interrupt; [public, alias: 'DMA1_Channel5_global_interrupt'];
begin
end;
}
{
procedure DMA1_Channel6_global_interrupt; [public, alias: 'DMA1_Channel6_global_interrupt'];
begin
end;
}
{
procedure DMA1_Channel7_global_interrupt; [public, alias: 'DMA1_Channel7_global_interrupt'];
begin
end;
}
{
procedure ADC1_and_ADC2_global_interrupt; [public, alias: 'ADC1_and_ADC2_global_interrupt'];
begin
end;
}
{
procedure USB_High_Priority_or_CAN_TX_interrupts; [public, alias: 'USB_High_Priority_or_CAN_TX_interrupts'];
begin
end;
}
{
procedure USB_Low_Priority_or_CAN_RX0_interrupts; [public, alias: 'USB_Low_Priority_or_CAN_RX0_interrupts'];
begin
end;
}
{
procedure CAN_RX1_interrupt; [public, alias: 'CAN_RX1_interrupt'];
begin
end;
}
{
procedure CAN_SCE_interrupt; [public, alias: 'CAN_SCE_interrupt'];
begin
end;
}
{
procedure EXTI_Line9_5_interrupts; [public, alias: 'EXTI_Line9_5_interrupts'];
begin
end;
}
{
procedure TIM1_Break_interrupt; [public, alias: 'TIM1_Break_interrupt'];
begin
end;
}
{
procedure TIM1_Update_interrupt; [public, alias: 'TIM1_Update_interrupt'];
begin
end;
}
{
procedure TIM1_Trigger_and_Commutation_interrupts; [public, alias: 'TIM1_Trigger_and_Commutation_interrupts'];
begin
end;
}
{
procedure TIM1_Capture_Compare_interrupt; [public, alias: 'TIM1_Capture_Compare_interrupt'];
begin
end;
}
{
procedure TIM2_global_interrupt; [public, alias: 'TIM2_global_interrupt'];
begin
   if (TIM_GetITStatus(Timer2, TIM_IT_Update) <> False) then
    begin
        TIM_ClearITPendingBit(Timer2, TIM_IT_Update);
       // ToggleLED;
       inc(globaltimervar);
       toggleLED;
    end;


end;
 }
{
procedure TIM3_global_interrupt; [public, alias: 'TIM3_global_interrupt'];
begin
end;
}
{
procedure TIM4_global_interrupt; [public, alias: 'TIM4_global_interrupt'];
begin
end;
}
{
procedure I2C1_event_interrupt; [public, alias: 'I2C1_event_interrupt'];
begin
end;
}
{
procedure I2C1_error_interrupt; [public, alias: 'I2C1_error_interrupt'];
begin
end;
}
{
procedure I2C2_event_interrupt; [public, alias: 'I2C2_event_interrupt'];
begin
end;
}
{
procedure I2C2_error_interrupt; [public, alias: 'I2C2_error_interrupt'];
begin
end;
}
{
procedure SPI1_global_interrupt; [public, alias: 'SPI1_global_interrupt'];
begin
end;
}
{
procedure SPI2_global_interrupt; [public, alias: 'SPI2_global_interrupt'];
begin
end;
}
{
procedure USART1_global_interrupt; [public, alias: 'USART1_global_interrupt'];
var
data : byte;
begin
  if USART_GetFlagStatus(USART1, USART_Flag_RXNE) > 0 then
  begin
    data := USART_ReceiveData(USART1);
    USART_SendData(USART1, data);
  end;
  USART_GetITStatus(USART1, USART_IT_RXNE);
end;
 }

{
procedure USART2_global_interrupt; [public, alias: 'USART2_global_interrupt'];
begin
end;
}
{
procedure USART3_global_interrupt; [public, alias: 'USART3_global_interrupt'];
begin
end;
}
{
procedure EXTI_Line15_10_interrupts; [public, alias: 'EXTI_Line15_10_interrupts'];
begin
end;
}
{
procedure RTC_alarm_through_EXTI_line_interrupt; [public, alias: 'RTC_alarm_through_EXTI_line_interrupt'];
begin
end;
}
{
procedure USB_wakeup_from_suspend_through_EXTI_line_interrupt; [public, alias: 'USB_wakeup_from_suspend_through_EXTI_line_interrupt'];
begin
end;
}
{
procedure TIM8_Break_interrupt; [public, alias: 'TIM8_Break_interrupt'];
begin
end;
}
{
procedure TIM8_Update_interrupt; [public, alias: 'TIM8_Update_interrupt'];
begin
end;
}
{
procedure TIM8_Trigger_and_Commutation_interrupts; [public, alias: 'TIM8_Trigger_and_Commutation_interrupts'];
begin
end;
}
{
procedure TIM8_Capture_Compare_interrupt; [public, alias: 'TIM8_Capture_Compare_interrupt'];
begin
end;
}
{
procedure ADC3_global_interrupt; [public, alias: 'ADC3_global_interrupt'];
begin
end;
}
{
procedure FSMC_global_interrupt; [public, alias: 'FSMC_global_interrupt'];
begin
end;
}
{
procedure SDIO_global_interrupt; [public, alias: 'SDIO_global_interrupt'];
begin
end;
}
{
procedure TIM5_global_interrupt; [public, alias: 'TIM5_global_interrupt'];
begin
end;
}
{
procedure SPI3_global_interrupt; [public, alias: 'SPI3_global_interrupt'];
begin
end;
}
{
procedure UART4_global_interrupt; [public, alias: 'UART4_global_interrupt'];
begin
end;
}
{
procedure UART5_global_interrupt; [public, alias: 'UART5_global_interrupt'];
begin
end;
}
{
procedure TIM6_global_interrupt; [public, alias: 'TIM6_global_interrupt'];
begin
end;
}
{
procedure TIM7_global_interrupt; [public, alias: 'TIM7_global_interrupt'];
begin
end;
}
{
procedure DMA2_Channel1_global_interrupt; [public, alias: 'DMA2_Channel1_global_interrupt'];
begin
end;
}
{
procedure DMA2_Channel2_global_interrupt; [public, alias: 'DMA2_Channel2_global_interrupt'];
begin
end;
}
{
procedure DMA2_Channel3_global_interrupt; [public, alias: 'DMA2_Channel3_global_interrupt'];
begin
end;
}
{
procedure DMA2_Channel4_and_DMA2_Channel5_global_interrupts; [public, alias: 'DMA2_Channel4_and_DMA2_Channel5_global_interrupts'];
begin
end;
}

end.