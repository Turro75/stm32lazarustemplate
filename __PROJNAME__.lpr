program __PROJNAME__;

{$mode objfpc}{$H+}

//======================================================================
uses
  main, stm32f103fw, heapmgr, Arduino_compat;


procedure init_RCC;
begin
   RCC_DeInit;

   RCC_HSEConfig(RCC_HSE_ON);

   // Wait till HSE is ready
   if RCC_WaitForHSEStartUp then
   begin
      // Enable Prefetch Buffer
      FLASH_PrefetchBufferCmd(FLASH_PrefetchBuffer_Enable);

      // Flash 2 wait state
      FLASH_SetLatency(FLASH_Latency_2);

      // HCLK = SYSCLK
      RCC_HCLKConfig(RCC_SYSCLK_Div1);

      // PCLK2 = HCLK
      RCC_PCLK2Config(RCC_HCLK_Div1);

      // PCLK1 = HCLK/2
      RCC_PCLK1Config(RCC_HCLK_Div2);



      // PLLCLK = 8MHz * 9 = 72 MHz
      RCC_PLLConfig(RCC_PLLSource_HSE_Div1, RCC_PLLMul_9);

      // Enable PLL
      RCC_PLLCmd(Enabled);

      // Wait till PLL is ready
      while RCC_GetFlagStatus(RCC_FLAG_PLLRDY) = RCC_RESET do;

      // Select PLL as system clock source
      RCC_SYSCLKConfig(RCC_SYSCLKSource_PLLCLK);

      // Wait till PLL is used as system clock source
      while RCC_GetSYSCLKSource() <> $08 do;
   end;
end;


procedure init_PINS;
var
i: board_pins;
begin
  for i:=PA0 to PA15 do
  begin
     Pin_Map[i].Port:=@PortA;
     Pin_Map[i].Pin:=1 shl Pin_[i];
     Pin_Map[i].RCCSource:=RCC_APB2Periph_GPIOA;
     Pin_Map[i].ADChannel:=ADC_[i];
  end;
  for i:=PB0 to PB15 do
  begin
     Pin_Map[i].Port:=@PortB;
     Pin_Map[i].Pin:=1 shl Pin_[i];
     Pin_Map[i].RCCSource:=RCC_APB2Periph_GPIOB;
     Pin_Map[i].ADChannel:=ADC_[i];
  end;

  for i:=PC13 to PC15 do
  begin
     Pin_Map[i].Port:=@PortC;
     Pin_Map[i].Pin:=1 shl Pin_[i];
     Pin_Map[i].RCCSource:=RCC_APB2Periph_GPIOC;
     Pin_Map[i].ADChannel:=ADC_[i];
  end;
end;


procedure SysTick_interrupt; [public, alias: 'SysTick_interrupt'];
begin
  if (SystemTick < $FFFFFFFFFFFFFFF) then
      SystemTick:=SystemTick+1
   else
      SystemTick:=0;
end;                         

//======================================================================
begin

    RegisterHeapBlock(pointer($20004000),$1000); //Heap config for STM32F103
    init_RCC;  //setup clocks
      //setup systick interrupt frequency
    Systick_Config(72000000 div 1000);   //one interrupt every ms
    //BE CAREFUL ON CHANGE IT!!!!! the delay procedures are adjusted
    //on clock 72MHz and for a SysTick interrupt every 1ms
    SystemTick:=0;
    init_PINS;  //fill the Pin_MAP array, depends on the board
                                            

    setup;
    while true do
    begin
	loop;
    end;
end.

