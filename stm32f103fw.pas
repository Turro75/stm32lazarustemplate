{
 Converted from STM FWlib

 Contributors:
  Jeppe Johansen
  Bernd Mueller
  Valerio Turrini with really small adjustments.....
}
unit stm32f103fw;


interface

uses
cortexm3;



const
 HSE_Value: longint = 8000000;
 HSI_Value: longint = 8000000;



 var
  cpuUniqueID0 : longword    absolute($1FFFF7E8);
  cpuUniqueID1 : longword    absolute($1FFFF7EC);
  cpuUniqueID2 : longword    absolute($1FFFF7F0);
  myflag:word=0;
{ RCC }
type
 TState = (Disabled, Enabled);

const
{ PLL entry clock source }
 RCC_PLLSource_HSI_Div2           = $00000000;
 RCC_PLLSource_HSE_Div1           = $00010000;
 RCC_PLLSource_HSE_Div2           = $00030000;

{ PLL multiplication factor }
 RCC_PLLMul_2                     = $00000000;
 RCC_PLLMul_3                     = $00040000;
 RCC_PLLMul_4                     = $00080000;
 RCC_PLLMul_5                     = $000C0000;
 RCC_PLLMul_6                     = $00100000;
 RCC_PLLMul_7                     = $00140000;
 RCC_PLLMul_8                     = $00180000;
 RCC_PLLMul_9                     = $001C0000;
 RCC_PLLMul_10                    = $00200000;
 RCC_PLLMul_11                    = $00240000;
 RCC_PLLMul_12                    = $00280000;
 RCC_PLLMul_13                    = $002C0000;
 RCC_PLLMul_14                    = $00300000;
 RCC_PLLMul_15                    = $00340000;
 RCC_PLLMul_16                    = $00380000;

{ System clock source }
 RCC_SYSCLKSource_HSI             = $00000000;
 RCC_SYSCLKSource_HSE             = $00000001;
 RCC_SYSCLKSource_PLLCLK          = $00000002;

{ AHB clock source }
 RCC_SYSCLK_Div1                  = $00000000;
 RCC_SYSCLK_Div2                  = $00000080;
 RCC_SYSCLK_Div4                  = $00000090;
 RCC_SYSCLK_Div8                  = $000000A0;
 RCC_SYSCLK_Div16                 = $000000B0;
 RCC_SYSCLK_Div64                 = $000000C0;
 RCC_SYSCLK_Div128                = $000000D0;
 RCC_SYSCLK_Div256                = $000000E0;
 RCC_SYSCLK_Div512                = $000000F0;

{ APB1/APB2 clock source }
 RCC_HCLK_Div1                    = $00000000;
 RCC_HCLK_Div2                    = $00000400;
 RCC_HCLK_Div4                    = $00000500;
 RCC_HCLK_Div8                    = $00000600;
 RCC_HCLK_Div16                   = $00000700;

{ RCC Interrupt source }
 RCC_IT_LSIRDY                    = $01;
 RCC_IT_LSERDY                    = $02;
 RCC_IT_HSIRDY                    = $04;
 RCC_IT_HSERDY                    = $08;
 RCC_IT_PLLRDY                    = $10;
 RCC_IT_CSS                       = $80;

{ USB clock source }
 RCC_USBCLKSource_PLLCLK_1Div5    = $00;
 RCC_USBCLKSource_PLLCLK_Div1     = $01;

{ ADC clock source }
 RCC_PCLK2_Div2                   = $00000000;
 RCC_PCLK2_Div4                   = $00004000;
 RCC_PCLK2_Div6                   = $00008000;
 RCC_PCLK2_Div8                   = $0000C000;

{ LSE configuration }
 RCC_LSE_OFF                      = $00;
 RCC_LSE_ON                       = $01;
 RCC_LSE_Bypass                   = $04;

{ RTC clock source }
 RCC_RTCCLKSource_LSE             = $00000100;
 RCC_RTCCLKSource_LSI             = $00000200;
 RCC_RTCCLKSource_HSE_Div128      = $00000300;

{ AHB peripheral }
 RCC_AHBPeriph_DMA1               = $00000001;
 RCC_AHBPeriph_DMA2               = $00000002;
 RCC_AHBPeriph_SRAM               = $00000004;
 RCC_AHBPeriph_FLITF              = $00000010;

{ APB2 peripheral }
 RCC_APB2Periph_AFIO              = $0001;
 RCC_APB2Periph_GPIOA             = $0004;
 RCC_APB2Periph_GPIOB             = $0008;
 RCC_APB2Periph_GPIOC             = $0010;
 RCC_APB2Periph_GPIOD             = $0020;
 RCC_APB2Periph_GPIOE             = $0040;
 RCC_APB2Periph_ADC1              = $0200;
 RCC_APB2Periph_ADC2              = $0400;
 RCC_APB2Periph_TIM1              = $0800;
 RCC_APB2Periph_SPI1              = $1000;
 RCC_APB2Periph_USART1            = $4000;
 RCC_APB2Periph_ALL               = $5E7D;

{ APB1 peripheral }
 RCC_APB1Periph_TIM2              = $00000001;
 RCC_APB1Periph_TIM3              = $00000002;
 RCC_APB1Periph_TIM4              = $00000004;
 RCC_APB1Periph_WWDG              = $00000800;
 RCC_APB1Periph_SPI2              = $00004000;
 RCC_APB1Periph_USART2            = $00020000;
 RCC_APB1Periph_USART3            = $00040000;
 RCC_APB1Periph_I2C1              = $00200000;
 RCC_APB1Periph_I2C2              = $00400000;
 RCC_APB1Periph_USB               = $00800000;
 RCC_APB1Periph_CAN               = $02000000;
 RCC_APB1Periph_BKP               = $08000000;
 RCC_APB1Periph_PWR               = $10000000;
 RCC_APB1Periph_DAC               = $20000000;
 RCC_APB1Periph_ALL               = $1AE64807;

{ Clock source to output on MCO pin }
 RCC_MCO_NoClock                  = $00;
 RCC_MCO_SYSCLK                   = $04;
 RCC_MCO_HSI                      = $05;
 RCC_MCO_HSE                      = $06;
 RCC_MCO_PLLCLK_Div2              = $07;

{ RCC Flag }
 RCC_FLAG_HSIRDY                  = $20;
 RCC_FLAG_HSERDY                  = $31;
 RCC_FLAG_PLLRDY                  = $39;
 RCC_FLAG_LSERDY                  = $41;
 RCC_FLAG_LSIRDY                  = $61;
 RCC_FLAG_PINRST                  = $7A;
 RCC_FLAG_PORRST                  = $7B;
 RCC_FLAG_SFTRST                  = $7C;
 RCC_FLAG_IWDGRST                 = $7D;
 RCC_FLAG_WWDGRST                 = $7E;
 RCC_FLAG_LPWRRST                 = $7F;

const
 RCC_RESET = 0;
 RCC_SET = 1;


type
 TRCC_ClocksTypeDef = record
  SYSCLK_Frequency,
  HCLK_Frequency,
  PCLK1_Frequency,
  PCLK2_Frequency,
  ADCCLK_Frequency: DWord;
 end;

type
 TRCCStatus = (RCC_HSE_OFF, RCC_HSE_ON, RCC_HSE_BYPASS);

procedure RCC_DeInit;
procedure RCC_HSEConfig(status: TRCCStatus);
function RCC_WaitForHSEStartUp: boolean;
procedure RCC_AdjustHSICalibrationValue(HSICalibrationValue: byte);
procedure RCC_HSICmd(NewState: TState);
function RCC_GetSYSCLKSource: byte;
procedure RCC_PLLConfig(RCC_PLLSource, RCC_PLLMul: longword);
procedure RCC_PLLCmd(NewState: TState);
procedure RCC_SYSCLKConfig(RCC_SYSCLKSource: longword);
procedure RCC_HCLKConfig(RCC_HCLK: longword);
procedure RCC_PCLK1Config(RCC_PCLK1: longword);
procedure RCC_PCLK2Config(RCC_PCLK2: longword);
function RCC_GetFlagStatus(RCC_FLAG: byte): longword;

procedure RCC_ITConfig(RCC_IT: byte; NewState: TState);
procedure RCC_USBCLKConfig(RCC_USBCLKSource: longword);
procedure RCC_ADCCLKConfig(RCC_ADCCLK: longword);
procedure RCC_LSEConfig(RCC_LSE: longword);
procedure RCC_LSICmd(NewState: TState);
procedure RCC_RTCCLKConfig(RCC_RTCCLKSource: longword);
procedure RCC_RTCCLKCmd(NewState: TState);
procedure RCC_GetClocksFreq(out RCC_Clocks: TRCC_ClocksTypeDef);

procedure RCC_AHBPeriphClockCmd(RCC_AHBPeriph: longword;   NewState: TState);
procedure RCC_APB2PeriphClockCmd(RCC_APB2Periph: longword; NewState: TState);
procedure RCC_APB1PeriphClockCmd(RCC_APB1Periph: longword; NewState: TState);
procedure RCC_APB2PeriphResetCmd(RCC_APB2Periph: longword; NewState: TState);
procedure RCC_APB1PeriphResetCmd(RCC_APB1Periph: longword; NewState: TState);
procedure RCC_BackupResetCmd(NewState: TState);
procedure RCC_ClockSecuritySystemCmd(NewState: TState);
procedure RCC_MCOConfig(RCC_MCO: byte);
procedure RCC_ClearFlag;
function RCC_GetITStatus(RCC_IT: byte): longword;
procedure RCC_ClearITPendingBit(RCC_IT: byte);

{ Flash }
const
 FLASH_Latency_0                = $00000000;  { FLASH Zero Latency cycle }
 FLASH_Latency_1                = $00000001;  { FLASH One Latency cycle }
 FLASH_Latency_2                = $00000002;  { FLASH Two Latency cycles }

 FLASH_HalfCycleAccess_Enable   = $00000008;  { FLASH Half Cycle Enable }
 FLASH_HalfCycleAccess_Disable  = $00000000;  { FLASH Half Cycle Disable }

 FLASH_PrefetchBuffer_Enable    = $00000010;  { FLASH Prefetch Buffer Enable }
 FLASH_PrefetchBuffer_Disable   = $00000000;  { FLASH Prefetch Buffer Disable }

procedure FLASH_SetLatency(FLASH_Latency: longword);
procedure FLASH_HalfCycleAccessCmd(FLASH_HalfCycleAccess: longword);
procedure FLASH_PrefetchBufferCmd(FLASH_PrefetchBuffer: longword);
{Timer}
type


TIM_TimeBaseInitTypeDef = record
   TIM_Prescaler: word;        { /*!< Specifies the prescaler value used to divide the TIM clock.
                                       This parameter can be a number between 0x0000 and 0xFFFF */   }

  TIM_CounterMode : word;       {/*!< Specifies the counter mode.
                                       This parameter can be a value of @ref TIM_Counter_Mode */        }

  TIM_Period :word;           { /*!< Specifies the period value to be loaded into the active
                                       Auto-Reload Register at the next update event.
                                       This parameter must be a number between 0x0000 and 0xFFFF.  */  }

  TIM_ClockDivision :word;     {/*!< Specifies the clock division.
                                      This parameter can be a value of @ref TIM_Clock_Division_CKD */ }

  TIM_RepetitionCounter : byte;  { /*!< Specifies the repetition counter value. Each time the RCR downcounter
                                       reaches zero, an update event is generated and counting restarts
                                       from the RCR value (N).
                                       This means in PWM mode that (N+1) corresponds to:
                                          - the number of PWM periods in edge-aligned mode
                                          - the number of half PWM period in center-aligned mode
                                       This parameter must be a number between 0x00 and 0xFF.
                                       @note This parameter is valid only for TIM1 and TIM8. */ }
 end;
{/**
  * @brief  TIM Output Compare Init structure definition
  */
 }
TIM_OCInitTypeDef = record

  TIM_OCMode,        {/*!< Specifies the TIM mode.
                                   This parameter can be a value of @ref TIM_Output_Compare_and_PWM_modes */
                               }
  TIM_OutputState,   {/*!< Specifies the TIM Output Compare state.
                                   This parameter can be a value of @ref TIM_Output_Compare_state */
                               }
  TIM_OutputNState,  {/*!< Specifies the TIM complementary Output Compare state.
                                   This parameter can be a value of @ref TIM_Output_Compare_N_state
                                   @note This parameter is valid only for TIM1 and TIM8. */
                               }
  TIM_Pulse,         {/*!< Specifies the pulse value to be loaded into the Capture Compare Register.
                                   This parameter can be a number between 0x0000 and 0xFFFF */
                               }
  TIM_OCPolarity,    {/*!< Specifies the output polarity.
                                   This parameter can be a value of @ref TIM_Output_Compare_Polarity */
                              }
  TIM_OCNPolarity,   {/*!< Specifies the complementary output polarity.
                                   This parameter can be a value of @ref TIM_Output_Compare_N_Polarity
                                   @note This parameter is valid only for TIM1 and TIM8. */
                               }
  TIM_OCIdleState,   {/*!< Specifies the TIM Output Compare pin state during Idle state.
                                   This parameter can be a value of @ref TIM_Output_Compare_Idle_State
                                   @note This parameter is valid only for TIM1 and TIM8. */
                               }
  TIM_OCNIdleState :word;  {/*!< Specifies the TIM Output Compare pin state during Idle state.
                                   This parameter can be a value of @ref TIM_Output_Compare_N_Idle_State
                                   @note This parameter is valid only for TIM1 and TIM8. */
                                   }

end;




{/**
  * @brief  TIM Input Capture Init structure definition
  */}

TIM_ICInitTypeDef = record


  TIM_Channel : word;      //*!< Specifies the TIM channel.
                            //      This parameter can be a value of @ref TIM_Channel */

  TIM_ICPolarity: word;   //*!< Specifies the active edge of the input signal.
                           //       This parameter can be a value of @ref TIM_Input_Capture_Polarity */

  TIM_ICSelection : word;  ///*!< Specifies the input.
                                  //This parameter can be a value of @ref TIM_Input_Capture_Selection */

  TIM_ICPrescaler : word;  //*!< Specifies the Input Capture Prescaler.
                            //      This parameter can be a value of @ref TIM_Input_Capture_Prescaler */

  TIM_ICFilter : word;     //*!< Specifies the input capture filter.
                            //      This parameter can be a number between 0x0 and 0xF */
end;


 const
   TIM_CCER_CC1E                     =$0001;            //*!< Capture/Compare 1 output enable */
   TIM_CCER_CC1P                       =$0002;            //*!< Capture/Compare 1 output Polarity */
   TIM_CCER_CC1NE                      =$0004;            //*!< Capture/Compare 1 Complementary output enable */
   TIM_CCER_CC1NP                      =$0008;            //*!< Capture/Compare 1 Complementary output Polarity */
   TIM_CCER_CC2E                       =$0010;            //*!< Capture/Compare 2 output enable */
   TIM_CCER_CC2P                       =$0020;            //*!< Capture/Compare 2 output Polarity */
   TIM_CCER_CC2NE                      =$0040;            //*!< Capture/Compare 2 Complementary output enable */
   TIM_CCER_CC2NP                      =$0080;            //*!< Capture/Compare 2 Complementary output Polarity */
   TIM_CCER_CC3E                       =$0100;            //*!< Capture/Compare 3 output enable */
   TIM_CCER_CC3P                       =$0200;            //*!< Capture/Compare 3 output Polarity */
   TIM_CCER_CC3NE                      =$0400;            //*!< Capture/Compare 3 Complementary output enable */
   TIM_CCER_CC3NP                      =$0800;            //*!< Capture/Compare 3 Complementary output Polarity */
   TIM_CCER_CC4E                       =$1000;            //*!< Capture/Compare 4 output enable */
   TIM_CCER_CC4P                       =$2000;            //*!< Capture/Compare 4 output Polarity */
   TIM_CCER_CC4NP                      =$8000;            //*!< Capture/Compare 4 Complementary output Polarity */

   //*****************  Bit definition for TIM_CCMR1 register  *******************/
   TIM_CCMR1_CC1S                      =$0003;             //!< CC1S[1:0] bits (Capture/Compare 1 Selection;  */
   TIM_CCMR1_CC1S_0                    =$0001;             //!< Bit 0 */
   TIM_CCMR1_CC1S_1                    =$0002;             //!< Bit 1 */

   TIM_CCMR1_OC1FE                     =$0004;             //!< Output Compare 1 Fast enable */
   TIM_CCMR1_OC1PE                     =$0008;             //!< Output Compare 1 Preload enable */

   TIM_CCMR1_OC1M                      =$0070;             //!< OC1M[2:0] bits (Output Compare 1 Mode;  */
   TIM_CCMR1_OC1M_0                    =$0010;             //!< Bit 0 */
   TIM_CCMR1_OC1M_1                    =$0020;             //!< Bit 1 */
   TIM_CCMR1_OC1M_2                    =$0040;             //!< Bit 2 */

   TIM_CCMR1_OC1CE                     =$0080;             //!< Output Compare 1Clear Enable */

   TIM_CCMR1_CC2S                      =$0300;             //!< CC2S[1:0] bits (Capture/Compare 2 Selection;  */
   TIM_CCMR1_CC2S_0                    =$0100;             //!< Bit 0 */
   TIM_CCMR1_CC2S_1                    =$0200;             //!< Bit 1 */

   TIM_CCMR1_OC2FE                     =$0400;             //!< Output Compare 2 Fast enable */
   TIM_CCMR1_OC2PE                     =$0800;             //!< Output Compare 2 Preload enable */

   TIM_CCMR1_OC2M                      =$7000;             //!< OC2M[2:0] bits (Output Compare 2 Mode;  */
   TIM_CCMR1_OC2M_0                    =$1000;             //!< Bit 0 */
   TIM_CCMR1_OC2M_1                    =$2000;             //!< Bit 1 */
   TIM_CCMR1_OC2M_2                    =$4000;             //!< Bit 2 */

   TIM_CCMR1_OC2CE                     =$8000;             //!< Output Compare 2 Clear Enable */

//----------------------------------------------------------------------------*/

   TIM_CCMR1_IC1PSC                    =$000C;             //!< IC1PSC[1:0] bits (Input Capture 1 Prescaler;  */
   TIM_CCMR1_IC1PSC_0                  =$0004;             //!< Bit 0 */
   TIM_CCMR1_IC1PSC_1                  =$0008;             //!< Bit 1 */

   TIM_CCMR1_IC1F                      =$00F0;             //!< IC1F[3:0] bits (Input Capture 1 Filter;  */
   TIM_CCMR1_IC1F_0                    =$0010;             //!< Bit 0 */
   TIM_CCMR1_IC1F_1                    =$0020;             //!< Bit 1 */
   TIM_CCMR1_IC1F_2                    =$0040;             //!< Bit 2 */
   TIM_CCMR1_IC1F_3                    =$0080;             //!< Bit 3 */

   TIM_CCMR1_IC2PSC                    =$0C00;             //!< IC2PSC[1:0] bits (Input Capture 2 Prescaler;  */
   TIM_CCMR1_IC2PSC_0                  =$0400;             //!< Bit 0 */
   TIM_CCMR1_IC2PSC_1                  =$0800;             //!< Bit 1 */

   TIM_CCMR1_IC2F                      =$F000;             //!< IC2F[3:0] bits (Input Capture 2 Filter;  */
   TIM_CCMR1_IC2F_0                    =$1000;             //!< Bit 0 */
   TIM_CCMR1_IC2F_1                    =$2000;             //!< Bit 1 */
   TIM_CCMR1_IC2F_2                    =$4000;             //!< Bit 2 */
   TIM_CCMR1_IC2F_3                    =$8000;             //!< Bit 3 */

   //*****************  Bit definition for TIM_CCMR2 register  *******************/
   TIM_CCMR2_CC3S                      =$0003;             //!< CC3S[1:0] bits (Capture/Compare 3 Selection;  */
   TIM_CCMR2_CC3S_0                    =$0001;             //!< Bit 0 */
   TIM_CCMR2_CC3S_1                    =$0002;             //!< Bit 1 */

   TIM_CCMR2_OC3FE                     =$0004;             //!< Output Compare 3 Fast enable */
   TIM_CCMR2_OC3PE                     =$0008;             //!< Output Compare 3 Preload enable */

   TIM_CCMR2_OC3M                      =$0070;             //!< OC3M[2:0] bits (Output Compare 3 Mode;  */
   TIM_CCMR2_OC3M_0                    =$0010;             //!< Bit 0 */
   TIM_CCMR2_OC3M_1                    =$0020;             //!< Bit 1 */
   TIM_CCMR2_OC3M_2                    =$0040;             //!< Bit 2 */

   TIM_CCMR2_OC3CE                     =$0080;             //!< Output Compare 3 Clear Enable */

   TIM_CCMR2_CC4S                      =$0300;             //!< CC4S[1:0] bits (Capture/Compare 4 Selection;  */
   TIM_CCMR2_CC4S_0                    =$0100;             //!< Bit 0 */
   TIM_CCMR2_CC4S_1                    =$0200;             //!< Bit 1 */

   TIM_CCMR2_OC4FE                     =$0400;             //!< Output Compare 4 Fast enable */
   TIM_CCMR2_OC4PE                     =$0800;             //!< Output Compare 4 Preload enable */

   TIM_CCMR2_OC4M                      =$7000;             //!< OC4M[2:0] bits (Output Compare 4 Mode;  */
   TIM_CCMR2_OC4M_0                    =$1000;             //!< Bit 0 */
   TIM_CCMR2_OC4M_1                    =$2000;             //!< Bit 1 */
   TIM_CCMR2_OC4M_2                    =$4000;             //!< Bit 2 */

   TIM_CCMR2_OC4CE                     =$8000;             //!< Output Compare 4 Clear Enable */

//----------------------------------------------------------------------------*/

   TIM_CCMR2_IC3PSC                    =$000C;             //!< IC3PSC[1:0] bits (Input Capture 3 Prescaler;  */
   TIM_CCMR2_IC3PSC_0                  =$0004;             //!< Bit 0 */
   TIM_CCMR2_IC3PSC_1                  =$0008;             //!< Bit 1 */

   TIM_CCMR2_IC3F                      =$00F0;             //!< IC3F[3:0] bits (Input Capture 3 Filter;  */
   TIM_CCMR2_IC3F_0                    =$0010;             //!< Bit 0 */
   TIM_CCMR2_IC3F_1                    =$0020;             //!< Bit 1 */
   TIM_CCMR2_IC3F_2                    =$0040;             //!< Bit 2 */
   TIM_CCMR2_IC3F_3                    =$0080;             //!< Bit 3 */

   TIM_CCMR2_IC4PSC                    =$0C00;             //!< IC4PSC[1:0] bits (Input Capture 4 Prescaler;  */
   TIM_CCMR2_IC4PSC_0                  =$0400;             //!< Bit 0 */
   TIM_CCMR2_IC4PSC_1                  =$0800;             //!< Bit 1 */

   TIM_CCMR2_IC4F                      =$F000;             //!< IC4F[3:0] bits (Input Capture 4 Filter;  */
   TIM_CCMR2_IC4F_0                    =$1000;             //!< Bit 0 */
   TIM_CCMR2_IC4F_1                    =$2000;             //!< Bit 1 */
   TIM_CCMR2_IC4F_2                    =$4000;             //!< Bit 2 */
   TIM_CCMR2_IC4F_3                    =$8000;             //!< Bit 3 */


   //******************  Bit definition for TIM_CR1 register  ********************/
   TIM_CR1_CEN                         =$0001;             //!< Counter enable */
   TIM_CR1_UDIS                        =$0002;             //!< Update disable */
   TIM_CR1_URS                         =$0004;             //!< Update request source */
   TIM_CR1_OPM                         =$0008;             //!< One pulse mode */
   TIM_CR1_DIR                         =$0010;             //!< Direction */

   TIM_CR1_CMS                         =$0060;             //!< CMS[1:0] bits (Center-aligned mode selection;  */
   TIM_CR1_CMS_0                       =$0020;             //!< Bit 0 */
   TIM_CR1_CMS_1                       =$0040;             //!< Bit 1 */

   TIM_CR1_ARPE                        =$0080;             //!< Auto-reload preload enable */

   TIM_CR1_CKD                         =$0300;             //!< CKD[1:0] bits (clock division;  */
   TIM_CR1_CKD_0                       =$0100;             //!< Bit 0 */
   TIM_CR1_CKD_1                       =$0200;             //!< Bit 1 */

//******************  Bit definition for TIM_CR2 register  ********************/
   TIM_CR2_CCPC                        =$0001;             //!< Capture/Compare Preloaded Control */
   TIM_CR2_CCUS                        =$0004;             //!< Capture/Compare Control Update Selection */
   TIM_CR2_CCDS                        =$0008;             //!< Capture/Compare DMA Selection */

   TIM_CR2_MMS                         =$0070;             //!< MMS[2:0] bits (Master Mode Selection;  */
   TIM_CR2_MMS_0                       =$0010;             //!< Bit 0 */
   TIM_CR2_MMS_1                       =$0020;             //!< Bit 1 */
   TIM_CR2_MMS_2                       =$0040;             //!< Bit 2 */

   TIM_CR2_TI1S                        =$0080;             //!< TI1 Selection */
   TIM_CR2_OIS1                        =$0100;             //!< Output Idle state 1 (OC1 output;  */
   TIM_CR2_OIS1N                       =$0200;             //!< Output Idle state 1 (OC1N output;  */
   TIM_CR2_OIS2                        =$0400;             //!< Output Idle state 2 (OC2 output;  */
   TIM_CR2_OIS2N                       =$0800;             //!< Output Idle state 2 (OC2N output;  */
   TIM_CR2_OIS3                        =$1000;             //!< Output Idle state 3 (OC3 output;  */
   TIM_CR2_OIS3N                       =$2000;             //!< Output Idle state 3 (OC3N output;  */
   TIM_CR2_OIS4                        =$4000;             //!< Output Idle state 4 (OC4 output;  */

 TIM_OCMode_Timing                = $0000;
 TIM_OCMode_Active                 = $0010;
 TIM_OCMode_Inactive               = $0020;
 TIM_OCMode_Toggle                  = $0030;
 TIM_OCMode_PWM1                    = $0060;
 TIM_OCMode_PWM2                    = $0070;
 TIM_OPMode_Single            = $0008;
 TIM_OPMode_Repetitive        = $0000;
 TIM_Channel_1                      = $0000;
 TIM_Channel_2                      = $0004;
 TIM_Channel_3                      = $0008;
 TIM_Channel_4                      = $000C;
 TIM_CounterMode_Up          =      $0000;
 TIM_CounterMode_Down               =$0010;
 TIM_CounterMode_CenterAligned1    = $0020;
 TIM_CounterMode_CenterAligned2     = $0040;
 TIM_CounterMode_CenterAligned3    =$0060;
 TIM_OCPolarity_High             = $0000;
 TIM_OCPolarity_Low              = $0002;
 TIM_OCNPolarity_High             = $0000;
 TIM_OCNPolarity_Low              = $0008;
 TIM_OutputState_Disable          = $0000;
 TIM_OutputState_Enable     = $0001;
 TIM_OutputNState_Disable          = $0000;
 TIM_OutputNState_Enable     = $0004;
 TIM_CCx_Enable                      = $0001;
 TIM_CCx_Disable             = $0000;
 TIM_CCxN_Enable                      = $0004;
 TIM_CCxN_Disable             = $0000;
 TIM_Break_Enable                =$1000;
 TIM_Break_Disable               =$0000;
TIM_OCIdleState_Set              =$0100;
TIM_OCIdleState_Reset             =$0000;
TIM_OCNIdleState_Set              =$0200;
TIM_OCNIdleState_Reset             =$0000;
 TIM_ICPolarity_Rising            = $0000;
TIM_ICPolarity_Falling            =$0002;
TIM_ICPolarity_BothEdge           =$000A;
TIM_ICSelection_DirectTI         =$0001; //) /*!< TIM Input 1, 2, 3 or 4 is selected to be
                                          //                         connected to IC1, IC2, IC3 or IC4, respectively */
 TIM_ICSelection_IndirectTI       =$0002; //*!< TIM Input 1, 2, 3 or 4 is selected to be
                                                        //           connected to IC2, IC1, IC4 or IC3, respectively. */
TIM_ICSelection_TRC                =$0003; //*!< TIM Input 1, 2, 3 or 4 is selected to be connected to TRC. */
TIM_ICPSC_DIV1             = $0000;
 TIM_ICPSC_DIV2              = $0004;
 TIM_ICPSC_DIV4               = $0008;
 TIM_ICPSC_DIV8               = $000C;
 TIM_CKD_DIV1             = $0000;
 TIM_CKD_DIV2              = $0100;
 TIM_CKD_DIV4               = $0200;

TIM_DMA_Update                     = $0100;
TIM_DMA_CC1                        = $0200;
TIM_DMA_CC2                        = $0400;
TIM_DMA_CC3                        = $0800;
TIM_DMA_CC4                        = $1000;
TIM_DMA_COM                        = $2000;
TIM_DMA_Trigger                    = $4000;


 TIM_PSCReloadMode_Update    = $0000;
 TIM_PSCReloadMode_Immediate  = $0001;

 TIM_IT_Update                      =$0001;
 TIM_IT_CC1                         =$0002;
 TIM_IT_CC2                         =$0004;
 TIM_IT_CC3                         =$0008;
 TIM_IT_CC4                         =$0010;
 TIM_IT_COM                         =$020;
 TIM_IT_Trigger                     =$0040;
 TIM_IT_Break                       =$0080;


TIM_EventSource_Update             =$0001;
TIM_EventSource_CC1               =$0002;
TIM_EventSource_CC2               =$0004;
TIM_EventSource_CC3               =$0008;
TIM_EventSource_CC4               =$0010;
TIM_EventSource_COM               =$0020;
TIM_EventSource_Trigger           =$0040;
TIM_EventSource_Break             =$0080;

TIM_OCPreload_Enable               =$0008;
TIM_OCPreload_Disable              =$0000;
TIM_OCFast_Enable                 =$0004;
TIM_OCFast_Disable                 =$0000;

  TIM_OCClear_Enable                =$0080;
  TIM_OCClear_Disable               =$0000;
  TIM_TRGOSource_Reset              =$0000;
  TIM_TRGOSource_Enable             =$0010;
  TIM_TRGOSource_Update             =$0020;
  TIM_TRGOSource_OC1                =$0030;
  TIM_TRGOSource_OC1Ref             =$0040;
  TIM_TRGOSource_OC2Ref             =$0050;
  TIM_TRGOSource_OC3Ref             =$0060;
  TIM_TRGOSource_OC4Ref             =$0070;
  TIM_FLAG_Update                   =$0001;
  TIM_FLAG_CC1                      =$0002;
  TIM_FLAG_CC2                      =$0004;
  TIM_FLAG_CC3                      =$0008;
  TIM_FLAG_CC4                      =$0010;
  TIM_FLAG_COM                      =$0020;
  TIM_FLAG_Trigger                  =$0040;
  TIM_FLAG_Break                    =$0080;
  TIM_FLAG_CC1OF                    =$0200;
  TIM_FLAG_CC2OF                    =$0400;
  TIM_FLAG_CC3OF                    =$0800;
  TIM_FLAG_CC4OF                    =$1000;


  ///******************  Bit definition for TIM_BDTR register  *******************/
   TIM_BDTR_DTG                        =$00FF;             //!< DTG[0:7] bits (Dead-Time Generator set-up;  */
   TIM_BDTR_DTG_0                      =$0001;             //!< Bit 0 */
   TIM_BDTR_DTG_1                      =$0002;             //!< Bit 1 */
   TIM_BDTR_DTG_2                      =$0004;             //!< Bit 2 */
   TIM_BDTR_DTG_3                      =$0008;             //!< Bit 3 */
   TIM_BDTR_DTG_4                      =$0010;             //!< Bit 4 */
   TIM_BDTR_DTG_5                      =$0020;             //!< Bit 5 */
   TIM_BDTR_DTG_6                      =$0040;             //!< Bit 6 */
   TIM_BDTR_DTG_7                      =$0080;             //!< Bit 7 */

   TIM_BDTR_LOCK                       =$0300;             //!< LOCK[1:0] bits (Lock Configuration;  */
   TIM_BDTR_LOCK_0                     =$0100;             //!< Bit 0 */
   TIM_BDTR_LOCK_1                     =$0200;             //!< Bit 1 */

   TIM_BDTR_OSSI                       =$0400;             //!< Off-State Selection for Idle mode */
   TIM_BDTR_OSSR                       =$0800;             //!< Off-State Selection for Run mode */
   TIM_BDTR_BKE                        =$1000;             //!< Break enable */
   TIM_BDTR_BKP                        =$2000;             //!< Break Polarity */
   TIM_BDTR_AOE                        =$4000;             //!< Automatic Output enable */
   TIM_BDTR_MOE                        =$8000;             //!< Main Output enable */

///******************  Bit definition for TIM_DCR register  ********************/
   TIM_DCR_DBA                         =$001F;             //!< DBA[4:0] bits (DMA Base Address;  */
   TIM_DCR_DBA_0                       =$0001;             //!< Bit 0 */
   TIM_DCR_DBA_1                       =$0002;             //!< Bit 1 */
   TIM_DCR_DBA_2                       =$0004;             //!< Bit 2 */
   TIM_DCR_DBA_3                       =$0008;             //!< Bit 3 */
   TIM_DCR_DBA_4                       =$0010;             //!< Bit 4 */

   TIM_DCR_DBL                         =$1F00;             //!< DBL[4:0] bits (DMA Burst Length;  */
   TIM_DCR_DBL_0                       =$0100;             //!< Bit 0 */
   TIM_DCR_DBL_1                       =$0200;             //!< Bit 1 */
   TIM_DCR_DBL_2                       =$0400;             //!< Bit 2 */
   TIM_DCR_DBL_3                       =$0800;             //!< Bit 3 */
   TIM_DCR_DBL_4                       =$1000;             //!< Bit 4 */

 procedure TIM_DeInit(var TIMx :TTimerRegisters);
 procedure TIM_Cmd(var TIMx : TTimerRegisters; NewState: TState);
 procedure TIM_TimeBaseInit(var TIMx :TTimerRegisters; var TIM_TimeBaseInitStruct: TIM_TimeBaseInitTypeDef);
 function  TIM_GetITStatus(var TIMx :TTimerRegisters; TIM_IT : word): boolean;
 procedure TIM_ClearITPendingBit(var TIMx :TTimerRegisters; TIM_IT : word);
 procedure TIM_ICInit(var  TIMx : TTimerRegisters ; var TIM_ICInitStruct : TIM_ICInitTypeDef);
 procedure TIM_ITConfig(var TIMx :TTimerRegisters; TIM_IT : word; NewState :TState);
 procedure TIM_DMACmd(var TIMx :TTimerRegisters; TIM_DMASource : word;  NewState: TState);
 procedure TIM_OC1Init(var TIMx :TTimerRegisters; var TIM_OCInitStruct :TIM_OCInitTypeDef);
procedure TIM_OC2Init(var TIMx :TTimerRegisters; var TIM_OCInitStruct :TIM_OCInitTypeDef);
procedure TIM_OC3Init(var TIMx :TTimerRegisters; var TIM_OCInitStruct :TIM_OCInitTypeDef);
procedure TIM_OC4Init(var TIMx :TTimerRegisters; var TIM_OCInitStruct :TIM_OCInitTypeDef);
procedure TIM_OC1PreloadConfig(var TIMx :TTimerRegisters; TIM_OCPreload : word);
procedure TIM_OC2PreloadConfig(var TIMx :TTimerRegisters; TIM_OCPreload : word);
procedure TIM_OC3PreloadConfig(var TIMx :TTimerRegisters; TIM_OCPreload : word);
procedure TIM_OC4PreloadConfig(var TIMx :TTimerRegisters; TIM_OCPreload : word);
procedure TIM_ARRPreloadConfig(var TIMx: TTimerRegisters; NewState : TState);
procedure TIM_CCxCmd( var  TIMx:TTimerRegisters ;TIM_Channel : word; TIM_CCx : word);
procedure TIM_CCxNCmd( var  TIMx:TTimerRegisters ; TIM_Channel : word;TIM_CCxN :word);
procedure TIM_CtrlPWMOutputs( var  TIMx:TTimerRegisters ;NewState : TState);
{ GPIO }
type
 TGPIOSpeed_TypeDef = (GPIO_Speed_10MHz = 1, GPIO_Speed_2MHz, GPIO_Speed_50MHz);

 TGPIOMode_TypeDef = byte;

 TGPIO_InitTypeDef = record
  GPIO_Pin: Word;
  GPIO_Speed: TGPIOSpeed_TypeDef;
  GPIO_Mode: TGPIOMode_TypeDef;
 end;

 TBitAction = (Bit_RESET, Bit_SET);

const
 GPIO_Mode_AIN = $0;
 GPIO_Mode_IN_FLOATING = $04;
 GPIO_Mode_Out_PP = $10;
 GPIO_Mode_Out_OD = $14;
 GPIO_Mode_AF_PP = $18;
 GPIO_Mode_AF_OD = $1C;
 GPIO_Mode_IPD = $28;
 GPIO_Mode_IPU = $48;

const
 GPIO_Pin_0                 = $0001;  { Pin 0 selected }
 GPIO_Pin_1                 = $0002;  { Pin 1 selected }
 GPIO_Pin_2                 = $0004;  { Pin 2 selected }
 GPIO_Pin_3                 = $0008;  { Pin 3 selected }
 GPIO_Pin_4                 = $0010;  { Pin 4 selected }
 GPIO_Pin_5                 = $0020;  { Pin 5 selected }
 GPIO_Pin_6                 = $0040;  { Pin 6 selected }
 GPIO_Pin_7                 = $0080;  { Pin 7 selected }
 GPIO_Pin_8                 = $0100;  { Pin 8 selected }
 GPIO_Pin_9                 = $0200;  { Pin 9 selected }
 GPIO_Pin_10                = $0400;  { Pin 10 selected }
 GPIO_Pin_11                = $0800;  { Pin 11 selected }
 GPIO_Pin_12                = $1000;  { Pin 12 selected }
 GPIO_Pin_13                = $2000;  { Pin 13 selected }
 GPIO_Pin_14                = $4000;  { Pin 14 selected }
 GPIO_Pin_15                = $8000;  { Pin 15 selected }
 GPIO_Pin_All               = $FFFF;  { All pins selected }

 GPIO_Remap_SPI1            = $00000001;  { SPI1 Alternate Function mapping }
 GPIO_Remap_I2C1            = $00000002;  { I2C1 Alternate Function mapping }
 GPIO_Remap_USART1          = $00000004;  { USART1 Alternate Function mapping }
 GPIO_Remap_USART2          = $00000008;  { USART2 Alternate Function mapping }
 GPIO_PartialRemap_USART3   = $00140010;  { USART3 Partial Alternate Function mapping }
 GPIO_FullRemap_USART3      = $00140030;  { USART3 Full Alternate Function mapping }
 GPIO_PartialRemap_TIM1     = $00160040;  { TIM1 Partial Alternate Function mapping }
 GPIO_FullRemap_TIM1        = $001600C0;  { TIM1 Full Alternate Function mapping }
 GPIO_PartialRemap1_TIM2    = $00180100;  { TIM2 Partial1 Alternate Function mapping }
 GPIO_PartialRemap2_TIM2    = $00180200;  { TIM2 Partial2 Alternate Function mapping }
 GPIO_FullRemap_TIM2        = $00180300;  { TIM2 Full Alternate Function mapping }
 GPIO_PartialRemap_TIM3     = $001A0800;  { TIM3 Partial Alternate Function mapping }
 GPIO_FullRemap_TIM3        = $001A0C00;  { TIM3 Full Alternate Function mapping }
 GPIO_Remap_TIM4            = $00001000;  { TIM4 Alternate Function mapping }
 GPIO_Remap1_CAN            = $001D4000;  { CAN Alternate Function mapping }
 GPIO_Remap2_CAN            = $001D6000;  { CAN Alternate Function mapping }
 GPIO_Remap_PD01            = $00008000;  { PD01 Alternate Function mapping }
 GPIO_Remap_SWJ_NoJTRST     = $00300100;  { Full SWJ Enabled (JTAG-DP + SW-DP; but without JTRST }
 GPIO_Remap_SWJ_JTAGDisable = $00300200;  { JTAG-DP Disabled and SW-DP Enabled }
 GPIO_Remap_SWJ_Disable     = $00300400;  { Full SWJ Disabled (JTAG-DP + SW-DP; }

 GPIO_PortSourceGPIOA       = $00;
 GPIO_PortSourceGPIOB       = $01;
 GPIO_PortSourceGPIOC       = $02;
 GPIO_PortSourceGPIOD       = $03;
 GPIO_PortSourceGPIOE       = $04;

 GPIO_PinSource0            = $00;
 GPIO_PinSource1            = $01;
 GPIO_PinSource2            = $02;
 GPIO_PinSource3            = $03;
 GPIO_PinSource4            = $04;
 GPIO_PinSource5            = $05;
 GPIO_PinSource6            = $06;
 GPIO_PinSource7            = $07;
 GPIO_PinSource8            = $08;
 GPIO_PinSource9            = $09;
 GPIO_PinSource10           = $0A;
 GPIO_PinSource11           = $0B;
 GPIO_PinSource12           = $0C;
 GPIO_PinSource13           = $0D;
 GPIO_PinSource14           = $0E;
 GPIO_PinSource15           = $0F;

procedure GPIO_DeInit(var GPIOx: TPortRegisters);
procedure GPIO_AFIODeInit;
procedure GPIO_Init(var GPIOx: TPortRegisters; const GPIO_InitStruct: TGPIO_InitTypeDef);
procedure TIM_TimeBaseStructInit(var TIM_TimeBaseInitStruct : TIM_TimeBaseInitTypeDef);
procedure GPIO_StructInit(out GPIO_InitStruct: TGPIO_InitTypeDef);
function GPIO_ReadInputDataBit(var GPIOx: TPortRegisters; GPIO_Pin: word): byte;
function GPIO_ReadInputData(var GPIOx: TPortRegisters): word;
function GPIO_ReadOutputDataBit(var GPIOx: TPortRegisters; GPIO_Pin: word): byte;
function GPIO_ReadOutputData(var GPIOx: TPortRegisters): word;
procedure GPIO_SetBits(var GPIOx: TPortRegisters; GPIO_Pin: word);
procedure GPIO_ResetBits(var GPIOx: TPortRegisters; GPIO_Pin: word);
procedure GPIO_WriteBit(var GPIOx: TPortRegisters; GPIO_Pin: Word; BitVal: TBitAction);
procedure GPIO_Write(var GPIOx: TPortRegisters; PortVal: word);
procedure GPIO_PinLockConfig(var GPIOx: TPortRegisters; GPIO_Pin: word);
procedure GPIO_EventOutputConfig(GPIO_PortSource, GPIO_PinSource: byte);
procedure GPIO_EventOutputCmd(NewState: TState);
procedure GPIO_PinRemapConfig(GPIO_Remap: longword; NewState: TState);
procedure GPIO_EXTILineConfig(GPIO_PortSource, GPIO_PinSource: byte);

{ USART }
type
 TUSART_InitTypeDef = record
  USART_BaudRate: dword;
  USART_WordLength,
  USART_StopBits,
  USART_Parity,
  USART_HardwareFlowControl,
  USART_Mode,
  USART_Clock,
  USART_CPOL,
  USART_CPHA,
  USART_LastBit: word;
 end;

const
   USART_WordLength_8b                  = $0000;
    USART_WordLength_9b                  = $1000;

    USART_StopBits_1                     = $0000;
    USART_StopBits_0_5                   = $1000;
    USART_StopBits_2                     = $2000;
    USART_StopBits_1_5                   = $3000;

    USART_Parity_No                      = $0000;
    USART_Parity_Even                    = $0400;
    USART_Parity_Odd                     = $0600;

    USART_HardwareFlowControl_None       = $0000;
    USART_HardwareFlowControl_RTS        = $0100;
    USART_HardwareFlowControl_CTS        = $0200;
    USART_HardwareFlowControl_RTS_CTS    = $0300;

    USART_Mode_Rx                        = $0004;
    USART_Mode_Tx                        = $0008;

    USART_Clock_Disable                  = $0000;
    USART_Clock_Enable                   = $0800;

    USART_CPOL_Low                       = $0000;
    USART_CPOL_High                      = $0400;

    USART_CPHA_1Edge                     = $0000;
    USART_CPHA_2Edge                     = $0200;

    USART_LastBit_Disable                = $0000;
    USART_LastBit_Enable                 = $0100;

    USART_IT_PE                          = $0028;
    USART_IT_TXE                         = $0727;
    USART_IT_TC                          = $0626;
    USART_IT_RXNE                        = $0525;
    USART_IT_IDLE                        = $0424;
    USART_IT_LBD                         = $0846;
    USART_IT_CTS                         = $096A;
    USART_IT_ERR                         = $0060;
    USART_IT_ORE                         = $0360;
    USART_IT_NE                          = $0260;
    USART_IT_FE                          = $0160;

    USART_DMAReq_Tx                      = $0080;
    USART_DMAReq_Rx                      = $0040;

    USART_WakeUp_IdleLine                = $0000;
    USART_WakeUp_AddressMark             = $0800;

    USART_LINBreakDetectLength_10b      = $0000;
    USART_LINBreakDetectLength_11b      = $0020;

    USART_IrDAMode_LowPower              = $0004;
    USART_IrDAMode_Normal                = $0000;

    USART_FLAG_CTS                       = $0200;
    USART_FLAG_LBD                       = $0100;
    USART_FLAG_TXE                       = $0080;
    USART_FLAG_TC                        = $0040;
    USART_FLAG_RXNE                      = $0020;
    USART_FLAG_IDLE                      = $0010;
    USART_FLAG_ORE                       = $0008;
    USART_FLAG_NE                        = $0004;
    USART_FLAG_FE                        = $0002;
    USART_FLAG_PE                        = $0001;


  {

procedure USART_DeInit(var USARTx: TUSARTRegisters);
procedure USART_Init(var USARTx: TUSARTRegisters; var USART_InitStruct: TUSART_InitTypeDef);
procedure USART_StructInit(var USART_InitStruct: TUSART_InitTypeDef);
procedure USART_Cmd(var USARTx: TUSARTRegisters; NewState: TState);
procedure USART_ITConfig(var USARTx: TUSARTRegisters; USART_IT: word; NewState: TState);
procedure USART_DMACmd(var USARTx: TUSARTRegisters; USART_DMAReq: word; NewState: TState);
procedure USART_SetAddress(var USARTx: TUSARTRegisters; USART_Address: byte);
procedure USART_WakeUpConfig(var USARTx: TUSARTRegisters; USART_WakeUp: word);
procedure USART_ReceiverWakeUpCmd(var USARTx: TUSARTRegisters; NewState: TState);
procedure USART_LINBreakDetectLengthConfig(var USARTx: TUSARTRegisters; USART_LINBreakDetectLength: word);
procedure USART_LINCmd(var USARTx: TUSARTRegisters; NewState: TState);
procedure USART_SendString(var USARTx: TUSARTRegisters; Data: String);
procedure USART_SendData(var USARTx: TUSARTRegisters; Data: Word);
function USART_ReceiveData(var USARTx: TUSARTRegisters): Word;
procedure USART_SendBreak(var USARTx: TUSARTRegisters);
procedure USART_SetGuardTime(var USARTx: TUSARTRegisters; USART_GuardTime: byte);
procedure USART_SetPrescaler(var USARTx: TUSARTRegisters; USART_Prescaler: byte);
procedure USART_SmartCardCmd(var USARTx: TUSARTRegisters; NewState: TState);
procedure USART_SmartCardNACKCmd(var USARTx: TUSARTRegisters; NewState: TState);
procedure USART_HalfDuplexCmd(var USARTx: TUSARTRegisters; NewState: TState);
procedure USART_IrDAConfig(var USARTx: TUSARTRegisters; USART_IrDAMode: word);
procedure USART_IrDACmd(var USARTx: TUSARTRegisters; NewState: TState);
function USART_GetFlagStatus(var USARTx: TUSARTRegisters; USART_FLAG: word):boolean;
procedure USART_ClearFlag(var USARTx: TUSARTRegisters; USART_FLAG: word);
function USART_GetITStatus(var USARTx: TUSARTRegisters; USART_IT: word): boolean;
procedure USART_ClearITPendingBit(var USARTx: TUSARTRegisters; USART_IT: word);
 }


 procedure USART_DeInit(var USARTx: TUSARTRegisters);
procedure USART_Init(var USARTx: TUSARTRegisters; var USART_InitStruct: TUSART_InitTypeDef);
procedure USART_StructInit(var USART_InitStruct: TUSART_InitTypeDef);
procedure USART_Cmd(var USARTx: TUSARTRegisters; NewState: TState);
procedure USART_ITConfig(var USARTx: TUSARTRegisters; USART_IT: word; NewState: TState);
procedure USART_DMACmd(var USARTx: TUSARTRegisters; USART_DMAReq: word; NewState: TState);
procedure USART_SetAddress(var USARTx: TUSARTRegisters; USART_Address: byte);
procedure USART_WakeUpConfig(var USARTx: TUSARTRegisters; USART_WakeUp: word);
procedure USART_ReceiverWakeUpCmd(var USARTx: TUSARTRegisters; NewState: TState);
procedure USART_LINBreakDetectLengthConfig(var USARTx: TUSARTRegisters; USART_LINBreakDetectLength: word);
procedure USART_LINCmd(var USARTx: TUSARTRegisters; NewState: TState);
procedure USART_SendData(var USARTx: TUSARTRegisters; Data: Word);
procedure USART_SendString(var USARTx: TUSARTRegisters; Data: String);
function USART_ReceiveData(var USARTx: TUSARTRegisters): Word;
procedure USART_SendBreak(var USARTx: TUSARTRegisters);
procedure USART_SetGuardTime(var USARTx: TUSARTRegisters; USART_GuardTime: byte);
procedure USART_SetPrescaler(var USARTx: TUSARTRegisters; USART_Prescaler: byte);
procedure USART_SmartCardCmd(var USARTx: TUSARTRegisters; NewState: TState);
procedure USART_SmartCardNACKCmd(var USARTx: TUSARTRegisters; NewState: TState);
procedure USART_HalfDuplexCmd(var USARTx: TUSARTRegisters; NewState: TState);
procedure USART_IrDAConfig(var USARTx: TUSARTRegisters; USART_IrDAMode: word);
procedure USART_IrDACmd(var USARTx: TUSARTRegisters; NewState: TState);
function USART_GetFlagStatus(var USARTx: TUSARTRegisters; USART_FLAG: word): longword;
procedure USART_ClearFlag(var USARTx: TUSARTRegisters; USART_FLAG: word);
function USART_GetITStatus(var USARTx: TUSARTRegisters; USART_IT: word): longword;
procedure USART_ClearITPendingBit(var USARTx: TUSARTRegisters; USART_IT: word);






{ NVIC }
const
 NVIC_VectTab_RAM             = $20000000;
 NVIC_VectTab_FLASH           = $08000000;

 NVIC_LP_SEVONPEND            = $10;
 NVIC_LP_SLEEPDEEP            = $04;
 NVIC_LP_SLEEPONEXIT          = $02;

 NVIC_PriorityGroup_0         = $700;
 NVIC_PriorityGroup_1         = $600;
 NVIC_PriorityGroup_2         = $500;
 NVIC_PriorityGroup_3         = $400;
 NVIC_PriorityGroup_4         = $300;

type
 TNVIC_InitTypeDef = record
  NVIC_IRQChannel,
  NVIC_IRQChannelPreemptionPriority,
  NVIC_IRQChannelSubPriority: byte;
  NVIC_IRQChannelCmd: TState;
 end;

const
  WWDG_IRQChannel = $00;  (* Window WatchDog Interrupt  *)
  PVD_IRQChannel = $01;  (* PVD through EXTI Line detection Interrupt  *)
  TAMPER_IRQChannel = $02;  (* Tamper Interrupt  *)
  RTC_IRQChannel = $03;  (* RTC global Interrupt  *)
  FLASH_IRQChannel = $04;  (* FLASH global Interrupt  *)
  RCC_IRQChannel = $05;  (* RCC global Interrupt  *)
  EXTI0_IRQChannel = $06;  (* EXTI Line0 Interrupt  *)
  EXTI1_IRQChannel = $07;  (* EXTI Line1 Interrupt  *)
  EXTI2_IRQChannel = $08;  (* EXTI Line2 Interrupt  *)
  EXTI3_IRQChannel = $09;  (* EXTI Line3 Interrupt  *)
  EXTI4_IRQChannel = $0A;  (* EXTI Line4 Interrupt  *)
  DMAChannel1_IRQChannel = $0B;  (* DMA Channel 1 global Interrupt  *)
  DMAChannel2_IRQChannel = $0C;  (* DMA Channel 2 global Interrupt  *)
  DMAChannel3_IRQChannel = $0D;  (* DMA Channel 3 global Interrupt  *)
  DMAChannel4_IRQChannel = $0E;  (* DMA Channel 4 global Interrupt  *)
  DMAChannel5_IRQChannel = $0F;  (* DMA Channel 5 global Interrupt  *)
  DMAChannel6_IRQChannel = $10;  (* DMA Channel 6 global Interrupt  *)
  DMAChannel7_IRQChannel = $11;  (* DMA Channel 7 global Interrupt  *)
  ADC_IRQChannel = $12;  (* ADC global Interrupt  *)
  USB_HP_CAN_TX_IRQChannel = $13;  (* USB High Priority or CAN TX Interrupts  *)
  USB_LP_CAN_RX0_IRQChannel = $14;  (* USB Low Priority or CAN RX0 Interrupts  *)
  CAN_RX1_IRQChannel = $15;  (* CAN RX1 Interrupt  *)
  CAN_SCE_IRQChannel = $16;  (* CAN SCE Interrupt  *)
  EXTI9_5_IRQChannel = $17;  (* External Line[9:5] Interrupts  *)
  TIM1_BRK_IRQChannel = $18;  (* TIM1 Break Interrupt  *)
  TIM1_UP_IRQChannel = $19;  (* TIM1 Update Interrupt  *)
  TIM1_TRG_COM_IRQChannel = $1A;  (* TIM1 Trigger and Commutation Interrupt  *)
  TIM1_CC_IRQChannel = $1B;  (* TIM1 Capture Compare Interrupt  *)
  TIM2_IRQChannel = $1C;  (* TIM2 global Interrupt  *)
  TIM3_IRQChannel = $1D;  (* TIM3 global Interrupt  *)
  TIM4_IRQChannel = $1E;  (* TIM4 global Interrupt  *)
  I2C1_EV_IRQChannel = $1F;  (* I2C1 Event Interrupt  *)
  I2C1_ER_IRQChannel = $20;  (* I2C1 Error Interrupt  *)
  I2C2_EV_IRQChannel = $21;  (* I2C2 Event Interrupt  *)
  I2C2_ER_IRQChannel = $22;  (* I2C2 Error Interrupt  *)
  SPI1_IRQChannel = $23;  (* SPI1 global Interrupt  *)
  SPI2_IRQChannel = $24;  (* SPI2 global Interrupt  *)
  USART1_IRQChannel = $25;  (* USART1 global Interrupt  *)
  USART2_IRQChannel = $26;  (* USART2 global Interrupt  *)
  USART3_IRQChannel = $27;  (* USART3 global Interrupt  *)
  EXTI15_10_IRQChannel = $28;  (* External Line[15:10] Interrupts  *)
  RTCAlarm_IRQChannel = $29;  (* RTC Alarm through EXTI Line Interrupt  *)
  USBWakeUp_IRQChannel = $2A;  (* USB WakeUp from suspend through EXTI Line Interrupt  *)

  SystemHandler_NMI = $00001F;  (* NMI Handler  *)
  SystemHandler_HardFault = $000000;  (* Hard Fault Handler  *)
  SystemHandler_MemoryManage = $043430;  (* Memory Manage Handler  *)
  SystemHandler_BusFault = $547931;  (* Bus Fault Handler  *)
  SystemHandler_UsageFault = $24C232;  (* Usage Fault Handler  *)
  SystemHandler_SVCall = $01FF40;  (* SVCall Handler  *)
  SystemHandler_DebugMonitor = $0A0080;  (* Debug Monitor Handler  *)
  SystemHandler_PSV = $02829C;  (* PSV Handler  *)
  SystemHandler_SysTick = $02C39A;  (* SysTick Handler  *)

procedure NVIC_PriorityGroupConfig(PriorityGroup: longword);
procedure NVIC_Init(const NVIC_InitStruct: TNVIC_InitTypeDef);
procedure NVIC_SetVectorTable(NVIC_VectTab, Offset: Longword);
procedure NVIC_SystemLPConfig(LowPowerMode: byte; NewState: TState);
procedure NVIC_SystemHandlerConfig(SystemHandler: longword; NewState: TState);
procedure NVIC_SystemHandlerPriorityConfig(SystemHandler: longword; SystemHandlerPreemptionPriority, SystemHandlerSubPriority: byte);
function NVIC_GetCurrentPendingIRQChannel: word;
function NVIC_GetSystemHandlerActiveBitStatus(SystemHandler: longword): boolean;
procedure NVIC_SetSystemHandlerPendingBit(SystemHandler: longword);
function NVIC_GetSystemHandlerPendingBit(SystemHandler: longword): boolean;

{ SysTick }
const
 SysTick_CLKSource_HCLK_Div8  = $FFFFFFFB;
 SysTick_CLKSource_HCLK       = $00000004;

 SysTick_Counter_Disable      = $FFFFFFFE;
 SysTick_Counter_Enable       = $00000001;
 SysTick_Counter_Clear        = $00000000;

 SysTick_FLAG_COUNT           = $00000010;
 SysTick_FLAG_SKEW            = $0000001E;
 SysTick_FLAG_NOREF           = $0000001F;
var
  SystemTick : int64;

procedure SysTick_CLKSourceConfig(SysTick_CLKSource: longword);
procedure SysTick_SetReload(Reload: LongWord);
procedure SysTick_CounterCmd(SysTick_Counter: Longword);
procedure SysTick_ITConfig(NewState: TState);
function SysTick_GetCounter: LongWord;
function SysTick_GetFlagStatus(SysTick_FLAG: byte): boolean;
function SysTick_Config(ticks:longword):integer;
function Millis:int64;
function Micros:int64;

procedure delay_ms(ms_delay : dword);
procedure delay_us(us_delay : dword);

{ SPI }

type
 TSPI_InitTypeDef = record
  SPI_Direction,
  SPI_Mode,
  SPI_DataSize,
  SPI_CPOL,
  SPI_CPHA,
  SPI_NSS,
  SPI_BaudRatePrescaler,
  SPI_FirstBit,
  SPI_CRCPolynomial: word;
 end;

  (* I2S Init structure definition  *)

 TI2S_InitTypeDef = record
  I2S_Mode,
  I2S_Standard,
  I2S_DataFormat,
  I2S_MCLKOutput,
  I2S_AudioFreq,
  I2S_CPOL: Word;
 end;

(* SPI data direction mode  *)

const
  SPI_Direction_2Lines_FullDuplex = $0000;
  SPI_Direction_2Lines_RxOnly = $0400;
  SPI_Direction_1Line_Rx = $8000;
  SPI_Direction_1Line_Tx = $C000;
  (* SPI master/slave mode  *)

  SPI_Mode_Master = $0104;
  SPI_Mode_Slave = $0000;
  (* SPI data size  *)

  SPI_DataSize_16b = $0800;
  SPI_DataSize_8b = $0000;
  (* SPI Clock Polarity  *)

  SPI_CPOL_Low = $0000;
  SPI_CPOL_High = $0002;
  (* SPI Clock Phase  *)

  SPI_CPHA_1Edge = $0000;
  SPI_CPHA_2Edge = $0001;
  (* SPI Slave Select management  *)

  SPI_NSS_Soft = $0200;
  SPI_NSS_Hard = $0000;
  (* SPI BaudRate Prescaler   *)

  SPI_BaudRatePrescaler_2 = $0000;
  SPI_BaudRatePrescaler_4 = $0008;
  SPI_BaudRatePrescaler_8 = $0010;
  SPI_BaudRatePrescaler_16 = $0018;
  SPI_BaudRatePrescaler_32 = $0020;
  SPI_BaudRatePrescaler_64 = $0028;
  SPI_BaudRatePrescaler_128 = $0030;
  SPI_BaudRatePrescaler_256 = $0038;
  (* SPI MSB/LSB transmission  *)

  SPI_FirstBit_MSB = $0000;
  SPI_FirstBit_LSB = $0080;
  (* I2S Mode  *)

  I2S_Mode_SlaveTx = $0000;
  I2S_Mode_SlaveRx = $0100;
  I2S_Mode_MasterTx = $0200;
  I2S_Mode_MasterRx = $0300;
  (* I2S Standard  *)

  I2S_Standard_Phillips = $0000;
  I2S_Standard_MSB = $0010;
  I2S_Standard_LSB = $0020;
  I2S_Standard_PCMShort = $0030;
  I2S_Standard_PCMLong = $00B0;
  (* I2S Data Format  *)

  I2S_DataFormat_16b = $0000;
  I2S_DataFormat_16bextended = $0001;
  I2S_DataFormat_24b = $0003;
  I2S_DataFormat_32b = $0005;
  (* I2S MCLK Output  *)

  I2S_MCLKOutput_Enable = $0200;
  I2S_MCLKOutput_Disable = $0000;
  (* I2S Audio Frequency  *)

  I2S_AudioFreq_48k = 48000;
  I2S_AudioFreq_44k = 44100;
  I2S_AudioFreq_22k = 22050;
  I2S_AudioFreq_16k = 16000;
  I2S_AudioFreq_8k = 8000;
  I2S_AudioFreq_Default = 2;
  (* I2S Clock Polarity  *)

  I2S_CPOL_Low = $0000;
  I2S_CPOL_High = $0008;
  (* SPI_I2S DMA transfer requests  *)

  SPI_I2S_DMAReq_Tx = $0002;
  SPI_I2S_DMAReq_Rx = $0001;
  (* SPI NSS internal software mangement  *)

  SPI_NSSInternalSoft_Set = $0100;
  SPI_NSSInternalSoft_Reset = $FEFF;
  (* SPI CRC Transmit/Receive  *)

  SPI_CRC_Tx = $00;
  SPI_CRC_Rx = $01;
  (* SPI direction transmit/receive  *)

  SPI_Direction_Rx = $BFFF;
  SPI_Direction_Tx = $4000;
  (* SPI_I2S interrupts definition  *)

  SPI_I2S_IT_TXE = $71;
  SPI_I2S_IT_RXNE = $60;
  SPI_I2S_IT_ERR = $50;
  SPI_I2S_IT_OVR = $56;
  SPI_IT_MODF = $55;
  SPI_IT_CRCERR = $54;
  I2S_IT_UDR = $53;
  (* SPI_I2S flags definition  *)

  SPI_I2S_FLAG_RXNE = $0001;
  SPI_I2S_FLAG_TXE = $0002;
  I2S_FLAG_CHSIDE = $0004;
  I2S_FLAG_UDR = $0008;
  SPI_FLAG_CRCERR = $0010;
  SPI_FLAG_MODF = $0020;
  SPI_I2S_FLAG_OVR = $0040;
  SPI_I2S_FLAG_BSY = $0080;

procedure SPI_I2S_DeInit(var SPIx: TSPIRegisters);
procedure SPI_Init(var SPIx: TSPIRegisters; const SPI_InitStruct: TSPI_InitTypeDef);
procedure I2S_Init(var SPIx: TSPIRegisters; const I2S_InitStruct: TI2S_InitTypeDef);
procedure SPI_StructInit(out SPI_InitStruct: TSPI_InitTypeDef);
procedure I2S_StructInit(out I2S_InitStruct: TI2S_InitTypeDef);
procedure SPI_Cmd(var SPIx: TSPIRegisters; NewState: TState);
procedure I2S_Cmd(var SPIx: TSPIRegisters; NewState: TState);
procedure SPI_I2S_ITConfig(var SPIx: TSPIRegisters; SPI_I2S_IT: byte; NewState: TState);
procedure SPI_I2S_DMACmd(var SPIx: TSPIRegisters; SPI_I2S_DMAReq: word; NewState: TState);
procedure SPI_I2S_SendData(var SPIx: TSPIRegisters; Data: word);
function SPI_I2S_ReceiveData(var SPIx: TSPIRegisters): word;
procedure SPI_NSSInternalSoftwareConfig(var SPIx: TSPIRegisters; SPI_NSSInternalSoft: word);
procedure SPI_SSOutputCmd(var SPIx: TSPIRegisters; NewState: TState);
procedure SPI_DataSizeConfig(var SPIx: TSPIRegisters; SPI_DataSize: word);
procedure SPI_TransmitCRC(var SPIx: TSPIRegisters);
procedure SPI_CalculateCRC(var SPIx: TSPIRegisters; NewState: TState);
function SPI_GetCRC(var SPIx: TSPIRegisters; SPI_CRC: byte): word;
function SPI_GetCRCPolynomial(var SPIx: TSPIRegisters): word;
procedure SPI_BiDirectionalLineConfig(var SPIx: TSPIRegisters; SPI_Direction: word);
function SPI_I2S_GetFlagStatus(var SPIx: TSPIRegisters; SPI_I2S_FLAG: word): boolean;
procedure SPI_I2S_ClearFlag(var SPIx: TSPIRegisters; SPI_I2S_FLAG: word);
function SPI_I2S_GetITStatus(var SPIx: TSPIRegisters; SPI_I2S_IT: byte): Boolean;
procedure SPI_I2S_ClearITPendingBit(var SPIx: TSPIRegisters; SPI_I2S_IT: byte);

{ ADC }

type
 TADC_InitTypeDef = record
  ADC_Mode: longword;
  ADC_ScanConvMode,
  ADC_ContinuousConvMode: TState;
  ADC_ExternalTrigConv,
  ADC_DataAlign: longword;
  ADC_NbrOfChannel: byte;
 end;

  (* ADC dual mode ------------------------------------------------------------- *)

const
  ADC_Mode_Independent = $00000000;
  ADC_Mode_RegInjecSimult = $00010000;
  ADC_Mode_RegSimult_AlterTrig = $00020000;
  ADC_Mode_InjecSimult_FastInterl = $00030000;
  ADC_Mode_InjecSimult_SlowInterl = $00040000;
  ADC_Mode_InjecSimult = $00050000;
  ADC_Mode_RegSimult = $00060000;
  ADC_Mode_FastInterl = $00070000;
  ADC_Mode_SlowInterl = $00080000;
  ADC_Mode_AlterTrig = $00090000;
  (* ADC extrenal trigger sources for regular channels conversion -------------- *)

  (* for ADC1 and ADC2  *)

  ADC_ExternalTrigConv_T1_CC1 = $00000000;
  ADC_ExternalTrigConv_T1_CC2 = $00020000;
  ADC_ExternalTrigConv_T2_CC2 = $00060000;
  ADC_ExternalTrigConv_T3_TRGO = $00080000;
  ADC_ExternalTrigConv_T4_CC4 = $000A0000;
  ADC_ExternalTrigConv_Ext_IT11_TIM8_TRGO = $000C0000;
  (* for ADC1, ADC2 and ADC3  *)

  ADC_ExternalTrigConv_T1_CC3 = $00040000;
  ADC_ExternalTrigConv_None = $000E0000;
  (* for ADC3  *)

  ADC_ExternalTrigConv_T3_CC1 = $00000000;
  ADC_ExternalTrigConv_T2_CC3 = $00020000;
  ADC_ExternalTrigConv_T8_CC1 = $00060000;
  ADC_ExternalTrigConv_T8_TRGO = $00080000;
  ADC_ExternalTrigConv_T5_CC1 = $000A0000;
  ADC_ExternalTrigConv_T5_CC3 = $000C0000;
  (* ADC data align ------------------------------------------------------------ *)

  ADC_DataAlign_Right = $00000000;
  ADC_DataAlign_Left = $00000800;
  (* ADC channels -------------------------------------------------------------- *)

  ADC_Channel_0 = $00;
  ADC_Channel_1 = $01;
  ADC_Channel_2 = $02;
  ADC_Channel_3 = $03;
  ADC_Channel_4 = $04;
  ADC_Channel_5 = $05;
  ADC_Channel_6 = $06;
  ADC_Channel_7 = $07;
  ADC_Channel_8 = $08;
  ADC_Channel_9 = $09;
  ADC_Channel_10 = $0A;
  ADC_Channel_11 = $0B;
  ADC_Channel_12 = $0C;
  ADC_Channel_13 = $0D;
  ADC_Channel_14 = $0E;
  ADC_Channel_15 = $0F;
  ADC_Channel_16 = $10;
  ADC_Channel_17 = $11;
  (* ADC sampling times -------------------------------------------------------- *)

  ADC_SampleTime_1Cycles5 = $00;
  ADC_SampleTime_7Cycles5 = $01;
  ADC_SampleTime_13Cycles5 = $02;
  ADC_SampleTime_28Cycles5 = $03;
  ADC_SampleTime_41Cycles5 = $04;
  ADC_SampleTime_55Cycles5 = $05;
  ADC_SampleTime_71Cycles5 = $06;
  ADC_SampleTime_239Cycles5 = $07;
  (* ADC extrenal trigger sources for injected channels conversion ------------- *)

  (* For ADC1 and ADC2  *)

  ADC_ExternalTrigInjecConv_T2_TRGO = $00002000;
  ADC_ExternalTrigInjecConv_T2_CC1 = $00003000;
  ADC_ExternalTrigInjecConv_T3_CC4 = $00004000;
  ADC_ExternalTrigInjecConv_T4_TRGO = $00005000;
  ADC_ExternalTrigInjecConv_Ext_IT15_TIM8_CC4 = $00006000;
  (* For ADC1, ADC2 and ADC3  *)

  ADC_ExternalTrigInjecConv_T1_TRGO = $00000000;
  ADC_ExternalTrigInjecConv_T1_CC4 = $00001000;
  ADC_ExternalTrigInjecConv_None = $00007000;
  (* For ADC3  *)

  ADC_ExternalTrigInjecConv_T4_CC3 = $00002000;
  ADC_ExternalTrigInjecConv_T8_CC2 = $00003000;
  ADC_ExternalTrigInjecConv_T8_CC4 = $00004000;
  ADC_ExternalTrigInjecConv_T5_TRGO = $00005000;
  ADC_ExternalTrigInjecConv_T5_CC4 = $00006000;
  (* ADC injected channel selection -------------------------------------------- *)

  ADC_InjectedChannel_1 = $14;
  ADC_InjectedChannel_2 = $18;
  ADC_InjectedChannel_3 = $1C;
  ADC_InjectedChannel_4 = $20;
  (* ADC analog watchdog selection --------------------------------------------- *)

  ADC_AnalogWatchdog_SingleRegEnable = $00800200;
  ADC_AnalogWatchdog_SingleInjecEnable = $00400200;
  ADC_AnalogWatchdog_SingleRegOrInjecEnable = $00C00200;
  ADC_AnalogWatchdog_AllRegEnable = $00800000;
  ADC_AnalogWatchdog_AllInjecEnable = $00400000;
  ADC_AnalogWatchdog_AllRegAllInjecEnable = $00C00000;
  ADC_AnalogWatchdog_None = $00000000;
  (* ADC interrupts definition ------------------------------------------------- *)

  ADC_IT_EOC = $0220;
  ADC_IT_AWD = $0140;
  ADC_IT_JEOC = $0480;
  (* ADC flags definition ------------------------------------------------------ *)

  ADC_FLAG_AWD = $01;
  ADC_FLAG_EOC = $02;
  ADC_FLAG_JEOC = $04;
  ADC_FLAG_JSTRT = $08;
  ADC_FLAG_STRT = $10;
  (* Exported macro ------------------------------------------------------------ *)

procedure ADC_DeInit(var ADCx: TADCRegisters);
procedure ADC_Init(var ADCx: TADCRegisters; const ADC_InitStruct: TADC_InitTypeDef);
procedure ADC_StructInit(out ADC_InitStruct: TADC_InitTypeDef);
procedure ADC_Cmd(var ADCx: TADCRegisters; NewState: TState);
procedure ADC_DMACmd(var ADCx: TADCRegisters; NewState: TState);
procedure ADC_ITConfig(var ADCx: TADCRegisters; ADC_IT: word; NewState: TState);
procedure ADC_ResetCalibration(var ADCx: TADCRegisters);
function ADC_GetResetCalibrationStatus(var ADCx: TADCRegisters): boolean;
procedure ADC_StartCalibration(var ADCx: TADCRegisters);
function ADC_GetCalibrationStatus(var ADCx: TADCRegisters): boolean;
procedure ADC_SoftwareStartConvCmd(var ADCx: TADCRegisters; NewState: TState);
function ADC_GetSoftwareStartConvStatus(var ADCx: TADCRegisters): boolean;
procedure ADC_DiscModeChannelCountConfig(var ADCx: TADCRegisters; Number: byte);
procedure ADC_DiscModeCmd(var ADCx: TADCRegisters; NewState: TState);
procedure ADC_RegularChannelConfig(var ADCx: TADCRegisters; ADC_Channel, Rank, ADC_SampleTime: byte);
procedure ADC_ExternalTrigConvCmd(var ADCx: TADCRegisters; NewState: TState);
function ADC_GetConversionValue(var ADCx: TADCRegisters): word;
function ADC_GetDualModeConversionValue: longword;
procedure ADC_AutoInjectedConvCmd(var ADCx: TADCRegisters; NewState: TState);
procedure ADC_InjectedDiscModeCmd(var ADCx: TADCRegisters; NewState: TState);
procedure ADC_ExternalTrigInjectedConvConfig(var ADCx: TADCRegisters; ADC_ExternalTrigInjecConv: longword);
procedure ADC_ExternalTrigInjectedConvCmd(var ADCx: TADCRegisters; NewState: TState);
procedure ADC_SoftwareStartInjectedConvCmd(var ADCx: TADCRegisters; NewState: TState);
function ADC_GetSoftwareStartInjectedConvCmdStatus(var ADCx: TADCRegisters): boolean;
procedure ADC_InjectedChannelConfig(var ADCx: TADCRegisters; ADC_Channel, Rank, ADC_SampleTime: byte);
procedure ADC_InjectedSequencerLengthConfig(var ADCx: TADCRegisters; Length: byte);
procedure ADC_SetInjectedOffset(var ADCx: TADCRegisters; ADC_InjectedChannel: byte; Offset: word);
function ADC_GetInjectedConversionValue(var ADCx: TADCRegisters; ADC_InjectedChannel: byte): word;
procedure ADC_AnalogWatchdogCmd(var ADCx: TADCRegisters; ADC_AnalogWatchdog: longword);
procedure ADC_AnalogWatchdogThresholdsConfig(var ADCx: TADCRegisters; HighThreshold, LowThreshold: word);
procedure ADC_AnalogWatchdogSingleChannelConfig(var ADCx: TADCRegisters; ADC_Channel: byte);
procedure ADC_TempSensorVrefintCmd(NewState: TState);
function ADC_GetFlagStatus(var ADCx: TADCRegisters; ADC_FLAG: byte): boolean;
procedure ADC_ClearFlag(var ADCx: TADCRegisters; ADC_FLAG: byte);
function ADC_GetITStatus(var ADCx: TADCRegisters; ADC_IT: word): boolean;
procedure ADC_ClearITPendingBit(var ADCx: TADCRegisters; ADC_IT: word);

{ DMA }
type
 TDMA_InitTypeDef = record
  DMA_PeripheralBaseAddr,
  DMA_MemoryBaseAddr: pointer;
  DMA_DIR,
  DMA_BufferSize,
  DMA_PeripheralInc,
  DMA_MemoryInc,
  DMA_PeripheralDataSize,
  DMA_MemoryDataSize,
  DMA_Mode,
  DMA_Priority,
  DMA_M2M: longword;
 end;



  (* DMA data transfer direction ----------------------------------------------- *)

const


  DMA_DIR_PeripheralDST = $00000010;
  DMA_DIR_PeripheralSRC = $00000000;
  (* DMA peripheral incremented mode ------------------------------------------- *)

  DMA_PeripheralInc_Enable = $00000040;
  DMA_PeripheralInc_Disable = $00000000;
  (* DMA memory incremented mode ----------------------------------------------- *)

  DMA_MemoryInc_Enable = $00000080;
  DMA_MemoryInc_Disable = $00000000;
  (* DMA peripheral data size -------------------------------------------------- *)

  DMA_PeripheralDataSize_Byte = $00000000;
  DMA_PeripheralDataSize_HalfWord = $00000100;
  DMA_PeripheralDataSize_Word = $00000200;
  (* DMA memory data size ------------------------------------------------------ *)

  DMA_MemoryDataSize_Byte = $00000000;
  DMA_MemoryDataSize_HalfWord = $00000400;
  DMA_MemoryDataSize_Word = $00000800;
  (* DMA circular/normal mode -------------------------------------------------- *)

  DMA_Mode_Circular = $00000020;
  DMA_Mode_Normal = $00000000;
  (* DMA priority level -------------------------------------------------------- *)

  DMA_Priority_VeryHigh = $00003000;
  DMA_Priority_High = $00002000;
  DMA_Priority_Medium = $00001000;
  DMA_Priority_Low = $00000000;
  (* DMA memory to memory ------------------------------------------------------ *)

  DMA_M2M_Enable = $00004000;
  DMA_M2M_Disable = $00000000;
  (* DMA interrupts definition ------------------------------------------------- *)

  DMA_IT_TC = $00000002;
  DMA_IT_HT = $00000004;
  DMA_IT_TE = $00000008;
  (* For DMA1  *)

  DMA1_IT_GL1 = $00000001;
  DMA1_IT_TC1 = $00000002;
  DMA1_IT_HT1 = $00000004;
  DMA1_IT_TE1 = $00000008;
  DMA1_IT_GL2 = $00000010;
  DMA1_IT_TC2 = $00000020;
  DMA1_IT_HT2 = $00000040;
  DMA1_IT_TE2 = $00000080;
  DMA1_IT_GL3 = $00000100;
  DMA1_IT_TC3 = $00000200;
  DMA1_IT_HT3 = $00000400;
  DMA1_IT_TE3 = $00000800;
  DMA1_IT_GL4 = $00001000;
  DMA1_IT_TC4 = $00002000;
  DMA1_IT_HT4 = $00004000;
  DMA1_IT_TE4 = $00008000;
  DMA1_IT_GL5 = $00010000;
  DMA1_IT_TC5 = $00020000;
  DMA1_IT_HT5 = $00040000;
  DMA1_IT_TE5 = $00080000;
  DMA1_IT_GL6 = $00100000;
  DMA1_IT_TC6 = $00200000;
  DMA1_IT_HT6 = $00400000;
  DMA1_IT_TE6 = $00800000;
  DMA1_IT_GL7 = $01000000;
  DMA1_IT_TC7 = $02000000;
  DMA1_IT_HT7 = $04000000;
  DMA1_IT_TE7 = $08000000;
  (* For DMA2  *)

  DMA2_IT_GL1 = $10000001;
  DMA2_IT_TC1 = $10000002;
  DMA2_IT_HT1 = $10000004;
  DMA2_IT_TE1 = $10000008;
  DMA2_IT_GL2 = $10000010;
  DMA2_IT_TC2 = $10000020;
  DMA2_IT_HT2 = $10000040;
  DMA2_IT_TE2 = $10000080;
  DMA2_IT_GL3 = $10000100;
  DMA2_IT_TC3 = $10000200;
  DMA2_IT_HT3 = $10000400;
  DMA2_IT_TE3 = $10000800;
  DMA2_IT_GL4 = $10001000;
  DMA2_IT_TC4 = $10002000;
  DMA2_IT_HT4 = $10004000;
  DMA2_IT_TE4 = $10008000;
  DMA2_IT_GL5 = $10010000;
  DMA2_IT_TC5 = $10020000;
  DMA2_IT_HT5 = $10040000;
  DMA2_IT_TE5 = $10080000;
  (* DMA flags definition ------------------------------------------------------ *)

  (* For DMA1  *)

  DMA1_FLAG_GL1 = $00000001;
  DMA1_FLAG_TC1 = $00000002;
  DMA1_FLAG_HT1 = $00000004;
  DMA1_FLAG_TE1 = $00000008;
  DMA1_FLAG_GL2 = $00000010;
  DMA1_FLAG_TC2 = $00000020;
  DMA1_FLAG_HT2 = $00000040;
  DMA1_FLAG_TE2 = $00000080;
  DMA1_FLAG_GL3 = $00000100;
  DMA1_FLAG_TC3 = $00000200;
  DMA1_FLAG_HT3 = $00000400;
  DMA1_FLAG_TE3 = $00000800;
  DMA1_FLAG_GL4 = $00001000;
  DMA1_FLAG_TC4 = $00002000;
  DMA1_FLAG_HT4 = $00004000;
  DMA1_FLAG_TE4 = $00008000;
  DMA1_FLAG_GL5 = $00010000;
  DMA1_FLAG_TC5 = $00020000;
  DMA1_FLAG_HT5 = $00040000;
  DMA1_FLAG_TE5 = $00080000;
  DMA1_FLAG_GL6 = $00100000;
  DMA1_FLAG_TC6 = $00200000;
  DMA1_FLAG_HT6 = $00400000;
  DMA1_FLAG_TE6 = $00800000;
  DMA1_FLAG_GL7 = $01000000;
  DMA1_FLAG_TC7 = $02000000;
  DMA1_FLAG_HT7 = $04000000;
  DMA1_FLAG_TE7 = $08000000;
  (* For DMA2  *)

  DMA2_FLAG_GL1 = $10000001;
  DMA2_FLAG_TC1 = $10000002;
  DMA2_FLAG_HT1 = $10000004;
  DMA2_FLAG_TE1 = $10000008;
  DMA2_FLAG_GL2 = $10000010;
  DMA2_FLAG_TC2 = $10000020;
  DMA2_FLAG_HT2 = $10000040;
  DMA2_FLAG_TE2 = $10000080;
  DMA2_FLAG_GL3 = $10000100;
  DMA2_FLAG_TC3 = $10000200;
  DMA2_FLAG_HT3 = $10000400;
  DMA2_FLAG_TE3 = $10000800;
  DMA2_FLAG_GL4 = $10001000;
  DMA2_FLAG_TC4 = $10002000;
  DMA2_FLAG_HT4 = $10004000;
  DMA2_FLAG_TE4 = $10008000;
  DMA2_FLAG_GL5 = $10010000;
  DMA2_FLAG_TC5 = $10020000;
  DMA2_FLAG_HT5 = $10040000;
  DMA2_FLAG_TE5 = $10080000;
{
var

 DMA1_Channel1 : T_DMAChannel                         absolute ($40020008);
 dma1_ccr1 : longword   absolute($40020008);
dma1_cndtr1 : longword   absolute($4002000C);
dma1_cpar1 : longword   absolute($40020010);
dma1_cmar1 : longword   absolute($40020014);
 DMA1_Channel2 : T_DMAChannel                         absolute (AHBBase+$001C);
 dma1_ccr2 : longword   absolute($4002001C);
dma1_cndtr2 : longword   absolute($40020020);
dma1_cpar2 : longword   absolute($40020024);
dma1_cmar2 : longword   absolute($40020028);
 DMA1_Channel3 : T_DMAChannel                         absolute (AHBBase+$0030);
 dma1_ccr3 : longword   absolute($40020030);
dma1_cndtr3 : longword   absolute($40020034);
dma1_cpar3 : longword   absolute($40020038);
dma1_cmar3 : longword   absolute($4002003C);
 DMA1_Channel4 : T_DMAChannel                        absolute (AHBBase+$0044);
 dma1_ccr4 : longword   absolute($40020044);
dma1_cndtr4 : longword   absolute($40020048);
dma1_cpar4 : longword   absolute($4002004C);
dma1_cmar4 : longword   absolute($40020050);
 DMA1_Channel5 : T_DMAChannel                        absolute (AHBBase+$0058);
 DMA1_Channel6 : T_DMAChannel                        absolute (AHBBase+$006C);
 DMA1_Channel7 : T_DMAChannel                        absolute (AHBBase+$0080);
 DMA2_Channel1 : T_DMAChannel                         absolute (AHBBase+$0408);
 DMA2_Channel2 : T_DMAChannel                         absolute (AHBBase+$041C);
 DMA2_Channel3 : T_DMAChannel                         absolute (AHBBase+$0430);
 DMA2_Channel4 : T_DMAChannel                         absolute (AHBBase+$0444);
 DMA2_Channel5 : T_DMAChannel                         absolute (AHBBase+$0458);
 }
procedure DMA_DeInit(var DMAy_Channelx: TDMAChannel);
procedure DMA_Init(var DMAy_Channelx: TDMAChannel; const DMA_InitStruct: TDMA_InitTypeDef);
procedure DMA_StructInit(out DMA_InitStruct: TDMA_InitTypeDef);
procedure DMA_Cmd(var DMAy_Channelx: TDMAChannel; NewState: TState);
procedure DMA_ITConfig(var DMAy_Channelx: TDMAChannel; DMA_IT: longword; NewState: TState);
function DMA_GetCurrDataCounter(var DMAy_Channelx: TDMAChannel): word;
function DMA_GetFlagStatus(DMA_FLAG: longword): boolean;
procedure DMA_ClearFlag(DMA_FLAG: longword);
function DMA_GetITStatus(DMA_IT: longword): boolean;
procedure DMA_ClearITPendingBit(DMA_IT: longword);

{ EXTI }
type
   TEXTIMode_TypeDef = (EXTI_Mode_Interrupt:= $00, EXTI_Mode_Event:= $04);
   TEXTITrigger_TypeDef = (EXTI_Trigger_Rising:= $08, EXTI_Trigger_Falling:= $0C,
                           EXTI_Trigger_Rising_Falling:= $10);

   TEXTI_InitTypeDef = record
      EXTI_Line: longword;
      EXTI_Mode: TEXTIMode_TypeDef;
      EXTI_Trigger: TEXTITrigger_TypeDef;
      EXTI_LineCmd: TState;
   end;

 const
   EXTI_Line0  = $00000001;
   EXTI_Line1  = $00000002;
   EXTI_Line2  = $00000004;
   EXTI_Line3  = $00000008;
   EXTI_Line4  = $00000010;
   EXTI_Line5  = $00000020;
   EXTI_Line6  = $00000040;
   EXTI_Line7  = $00000080;
   EXTI_Line8  = $00000100;
   EXTI_Line9  = $00000200;
   EXTI_Line10 = $00000400;
   EXTI_Line11 = $00000800;
   EXTI_Line12 = $00001000;
   EXTI_Line13 = $00002000;
   EXTI_Line14 = $00004000;
   EXTI_Line15 = $00008000;
   EXTI_Line16 = $00010000;
   EXTI_Line17 = $00020000;
   EXTI_Line18 = $00040000;
   EXTI_Line19 = $00080000;

procedure EXTI_DeInit;
procedure EXTI_Init(var EXTI_InitStruct: TEXTI_InitTypeDef);
procedure EXTI_StructInit(var EXTI_InitStruct: TEXTI_InitTypeDef);
procedure EXTI_GenerateSWInterrupt(EXTI_Line: longword);
function  EXTI_GetFlagStatus(EXTI_Line: longword): boolean;
procedure EXTI_ClearFlag(EXTI_Line: longword);
function  EXTI_GetITStatus(EXTI_Line: longword): boolean; Inline;
procedure EXTI_ClearITPendingBit(EXTI_Line: longword); Inline;

{ DAC }
type
   TDAC_InitTypeDef = record
      DAC_Trigger: longword;
      DAC_WaveGeneration: longword;
      DAC_LFSRUnmask_TriangleAmplitude: longword;
      DAC_OutputBuffer: longword;
   end;

const
   DAC_Trigger_None     = $00000000;
   DAC_Trigger_T6_TRGO  = $00000004;
   DAC_Trigger_T8_TRGO  = $0000000C;
   DAC_Trigger_T3_TRGO  = $0000000C;
   DAC_Trigger_T7_TRGO  = $00000014;
   DAC_Trigger_T5_TRGO  = $0000001C;
   DAC_Trigger_T15_TRGO = $0000001C;
   DAC_Trigger_T2_TRGO  = $00000024;
   DAC_Trigger_T4_TRGO  = $0000002C;
   DAC_Trigger_Ext_IT9  = $00000034;
   DAC_Trigger_Software = $0000003C;

   DAC_WaveGeneration_None     = $00000000;
   DAC_WaveGeneration_Noise    = $00000040;
   DAC_WaveGeneration_Triangle = $00000080;

   DAC_LFSRUnmask_Bit0        = $00000000;
   DAC_LFSRUnmask_Bits1_0     = $00000100;
   DAC_LFSRUnmask_Bits2_0     = $00000200;
   DAC_LFSRUnmask_Bits3_0     = $00000300;
   DAC_LFSRUnmask_Bits4_0     = $00000400;
   DAC_LFSRUnmask_Bits5_0     = $00000500;
   DAC_LFSRUnmask_Bits6_0     = $00000600;
   DAC_LFSRUnmask_Bits7_0     = $00000700;
   DAC_LFSRUnmask_Bits8_0     = $00000800;
   DAC_LFSRUnmask_Bits9_0     = $00000900;
   DAC_LFSRUnmask_Bits10_0    = $00000A00;
   DAC_LFSRUnmask_Bits11_0    = $00000B00;
   DAC_TriangleAmplitude_1    = $00000000;
   DAC_TriangleAmplitude_3    = $00000100;
   DAC_TriangleAmplitude_7    = $00000200;
   DAC_TriangleAmplitude_15   = $00000300;
   DAC_TriangleAmplitude_31   = $00000400;
   DAC_TriangleAmplitude_63   = $00000500;
   DAC_TriangleAmplitude_127  = $00000600;
   DAC_TriangleAmplitude_255  = $00000700;
   DAC_TriangleAmplitude_511  = $00000800;
   DAC_TriangleAmplitude_1023 = $00000900;
   DAC_TriangleAmplitude_2047 = $00000A00;
   DAC_TriangleAmplitude_4095 = $00000B00;

   DAC_OutputBuffer_Enable  = $00000000;
   DAC_OutputBuffer_Disable = $00000002;

   DAC_Channel_1 = $00000000;
   DAC_Channel_2 = $00000010;

   DAC_Align_12b_R = $00000000;
   DAC_Align_12b_L = $00000004;
   DAC_Align_8b_R  = $00000008;

   DAC_Wave_Noise    = $00000040;
   DAC_Wave_Triangle = $00000080;

{$if defined(STM32F10X_LD_VL) or defined(STM32F10X_MD_VL) or defined (STM32F10X_HD_VL)}
   DAC_IT_DMAUDR   = $00002000;
   DAC_FLAG_DMAUDR = $00002000;
{$endif}

procedure DAC_DeInit;
procedure DAC_Init(DAC_Channel: longword; var DAC_InitStruct: TDAC_InitTypeDef);
procedure DAC_StructInit(var DAC_InitStruct: TDAC_InitTypeDef);
procedure DAC_Cmd(DAC_Channel: longword; NewState: TState);

{$if defined(STM32F10X_LD_VL) or defined(STM32F10X_MD_VL) or defined (STM32F10X_HD_VL)}
   procedure DAC_ITConfig(DAC_Channel: longword; DAC_IT: longword; NewState: TState);
{$endif}

procedure DAC_DMACmd(DAC_Channel: longword; NewState: TState);
procedure DAC_SoftwareTriggerCmd(DAC_Channel: longword; NewState: TState);
procedure DAC_DualSoftwareTriggerCmd(NewState: TState);
procedure DAC_WaveGenerationCmd(DAC_Channel: longword; DAC_Wave: longword; NewState: TState);
procedure DAC_SetChannel1Data(DAC_Align: longword; Data: word);
procedure DAC_SetChannel2Data(DAC_Align: longword; Data: word);
procedure DAC_SetDualChannelData(DAC_Align: longword; Data2: word; Data1: word);
function  DAC_GetDataOutputValue(DAC_Channel: longword): word;

{$if defined(STM32F10X_LD_VL) or defined(STM32F10X_MD_VL) or defined (STM32F10X_HD_VL)}
   function  DAC_GetFlagStatus(DAC_Channel: longword; DAC_FLAG: longword): Boolean;
   procedure DAC_ClearFlag(DAC_Channel: longword; DAC_FLAG: longword);
   function  DAC_GetITStatus(DAC_Channel: longword; DAC_IT: longword): Boolean;
   procedure DAC_ClearITPendingBit(DAC_Channel: longword; DAC_IT: longword);
{$endif}

implementation
var
NVIC: TNVICRegisters      absolute (SCS_BASE+$0100);
SysTick: TSysTickRegisters   absolute (SCS_BASE+$0010);
SCB: TSCBRegisters        absolute (SCS_BASE+$0D00);

{ RCC }
const
 RCC_FLAG_Mask            = $1F;

 RCC_CR_HSEBYP_Reset = $FFFBFFFF;
 RCC_CR_HSEBYP_Set   = $00040000;
 RCC_CR_HSEON_Reset  = $FFFEFFFF;
 RCC_CR_HSEON_Set    = $00010000;
 RCC_CR_HSITRIM_Mask = $FFFFFF07;

 RCC_CFGR_PLL_Mask             = $FFC0FFFF;
 RCC_CFGR_PLLMull_Mask         = $003C0000;
 RCC_CFGR_PLLSRC_Mask          = $00010000;
 RCC_CFGR_PLLXTPRE_Mask        = $00020000;
 RCC_CFGR_SWS_Mask             = $0000000C;
 RCC_CFGR_SW_Mask              = $FFFFFFFC;
 RCC_CFGR_HPRE_Reset_Mask      = $FFFFFF0F;
 RCC_CFGR_HPRE_Set_Mask        = $000000F0;
 RCC_CFGR_PPRE1_Reset_Mask     = $FFFFF8FF;
 RCC_CFGR_PPRE1_Set_Mask       = $00000700;
 RCC_CFGR_PPRE2_Reset_Mask     = $FFFFC7FF;
 RCC_CFGR_PPRE2_Set_Mask       = $00003800;
 RCC_CFGR_ADCPRE_Reset_Mask    = $FFFF3FFF;
 RCC_CFGR_ADCPRE_Set_Mask      = $0000C000;
 RCC_CFGR_USBPRE_Reset_Mask    = $FF7FFFFF;
 RCC_CFGR_USBPRE_Set_Mask      = $00800000;

 APBAHBPrescTable: array[0..15] of byte = (0, 0, 0, 0, 1, 2, 3, 4, 1, 2, 3, 4, 6, 7, 8, 9);
 ADCPrescTable: array[0..3] of byte = (2, 4, 6, 8);

const
 HSEStartUp_Timeout = $1FF;


procedure RCC_DeInit;
begin
    { Set HSION bit }
    RCC.CR := RCC.CR or 1;

    { Reset SW[1:0], HPRE[3:0], PPRE1[2:0], PPRE2[2:0], ADCPRE[1:0] and MCO[2:0] bits }
    RCC.CFGR := RCC.CFGR and $F8FF0000;

    { Reset HSEON, CSSON and PLLON bits }
    RCC.CR := RCC.CR and $FEF6FFFF;

    { Reset HSEBYP bit }
    RCC.CR := RCC.CR and $FFFBFFFF;

    { Reset PLLSRC, PLLXTPRE, PLLMUL[3:0] and USBPRE bits }
    RCC.CFGR := RCC.CFGR and $FF80FFFF;

    { Disable all interrupts }
    RCC.CIR := $00000000;
end;

procedure RCC_HSEConfig(status: TRCCStatus);
begin
    { Reset HSEON and HSEBYP bits before configuring the HSE
      Reset HSEON bit }
    RCC.CR := RCC.CR and RCC_CR_HSEON_Reset;

    { Reset HSEBYP bit }
    RCC.CR := RCC.CR and RCC_CR_HSEBYP_Reset;

    { Configure HSE (RCC_HSE_OFF is already covered by the code section above) }
    case status of
        RCC_HSE_ON:
            RCC.CR := RCC.CR or RCC_CR_HSEON_Set;
        RCC_HSE_BYPASS:
            RCC.CR := RCC.CR or RCC_CR_HSEON_Set or RCC_CR_HSEBYP_Set;
    end;
end;

function RCC_WaitForHSEStartUp: boolean;
var StartUpCounter: longint;
     HSEStatus: longword;
begin
    StartUpCounter := 0;
    HSEStatus := RCC_RESET;

    while (HSEStatus = RCC_RESET) and (StartUpCounter < HSEStartUp_Timeout) do
    begin
        HSEStatus := RCC_GetFlagStatus(RCC_FLAG_HSERDY);
        inc(StartUpCounter);
    end;

    if RCC_GetFlagStatus(RCC_FLAG_HSERDY) <> RCC_RESET then
        exit(true)
    else
        exit(false);
end;

procedure RCC_AdjustHSICalibrationValue(HSICalibrationValue: byte);
var tmpreg: longword;
begin
    tmpreg := RCC.CR;

    { Clear HSITRIM[7:3] bits }
    tmpreg := tmpreg and RCC_CR_HSITRIM_Mask;

    { Set the HSITRIM[7:3] bits according to HSICalibrationValue value }
    tmpreg := tmpreg or (HSICalibrationValue shl 3);

    { Store the new value }
    RCC.CR := tmpreg;
end;

procedure RCC_HSICmd(NewState: TState);
begin
    if newstate = Enabled then
        RCC.CR := RCC.CR or 1
    else
        RCC.CR := RCC.CR and not(1);
end;

function RCC_GetSYSCLKSource: byte;
begin
    exit(RCC.CFGR and RCC_CFGR_SWS_Mask);
end;

procedure RCC_PLLConfig(RCC_PLLSource, RCC_PLLMul: longword);
var tmpreg: longword;
begin
    tmpreg := RCC.CFGR;

    { Clear PLLSRC, PLLXTPRE and PLLMUL[21:18] bits }
    tmpreg := tmpreg and RCC_CFGR_PLL_Mask;

    { Set the PLL configuration bits }
    tmpreg := tmpreg or (RCC_PLLSource or RCC_PLLMul);

    { Store the new value }
    RCC.CFGR := tmpreg;
end;

procedure RCC_PLLCmd(NewState: TState);
begin
    if newstate = Enabled then
        RCC.CR := RCC.CR or $01000000
    else
        RCC.CR := RCC.CR and not($01000000);
end;

procedure RCC_SYSCLKConfig(RCC_SYSCLKSource: longword);
var tmpreg: longword;
begin
    tmpreg := RCC.CFGR;

    { Clear SW[1:0] bits }
    tmpreg := tmpreg and RCC_CFGR_SW_Mask;

    { Set SW[1:0] bits according to RCC_SYSCLKSource value }
    tmpreg := tmpreg or RCC_SYSCLKSource;

    { Store the new value }
    RCC.CFGR := tmpreg;
end;

procedure RCC_HCLKConfig(RCC_HCLK: longword);
var tmpreg: longword;
begin
    tmpreg := RCC.CFGR;

    { Clear HPRE[7:4] bits }
    tmpreg := tmpreg and RCC_CFGR_HPRE_Reset_Mask;

    { Set HPRE[7:4] bits according to RCC_HCLK value }
    tmpreg := tmpreg or RCC_HCLK;

    { Store the new value }
    RCC.CFGR := tmpreg;
end;

procedure RCC_PCLK1Config(RCC_PCLK1: longword);
var tmpreg: longword;
begin
    tmpreg := RCC.CFGR;

    { Clear PPRE1[10:8] bits }
    tmpreg := tmpreg and RCC_CFGR_PPRE1_Reset_Mask;

    { Set PPRE1[10:8] bits according to RCC_PCLK1 value }
    tmpreg := tmpreg or RCC_PCLK1;

    { Store the new value }
    RCC.CFGR := tmpreg;
end;

procedure RCC_PCLK2Config(RCC_PCLK2: longword);
var tmpreg: longword;
begin
    tmpreg := RCC.CFGR;

    { Clear PPRE2[13:11] bits }
    tmpreg := tmpreg and RCC_CFGR_PPRE2_Reset_Mask;

    { Set PPRE2[13:11] bits according to RCC_PCLK2 value }
    tmpreg := tmpreg or (RCC_PCLK2 shl 3);

    { Store the new value }
    RCC.CFGR := tmpreg;
end;

function RCC_GetFlagStatus(RCC_FLAG: byte): longword;
var tmp, statusreg: longword;
begin
    { Get the RCC register index }
    tmp := RCC_FLAG shr 5;

    if tmp = 1 then
        statusreg := rcc.cr
    else if tmp = 2 then
        statusreg := rcc.bdcr
    else
        statusreg := rcc.csr;

    tmp := RCC_FLAG and RCC_FLAG_Mask;

    if (statusreg and (1 shl tmp)) <> RCC_RESET then
        exit(RCC_SET)
    else
        exit(RCC_RESET);
end;

procedure RCC_ITConfig(RCC_IT: byte; NewState: TState);
begin
    if newstate = enabled then
        pbyte($40021009)^ := pbyte($40021009)^ or RCC_IT
    else
        pbyte($40021009)^ := pbyte($40021009)^ and not(RCC_IT);
end;

procedure RCC_USBCLKConfig(RCC_USBCLKSource: longword);
begin
    if RCC_USBCLKSource = RCC_USBCLKSource_PLLCLK_1Div5 then
        RCC.CFGR := RCC.CFGR and RCC_CFGR_USBPRE_Reset_Mask
    else
        RCC.CFGR := RCC.CFGR or RCC_CFGR_USBPRE_Set_Mask;
end;

procedure RCC_ADCCLKConfig(RCC_ADCCLK: longword);
begin
    RCC.CFGR := (RCC.CFGR and RCC_CFGR_ADCPRE_Reset_Mask) or RCC_ADCCLK;
end;

procedure RCC_LSEConfig(RCC_LSE: longword);
begin
    RCC.BDCR := RCC_LSE_OFF;
    RCC.BDCR := RCC_LSE_OFF;

    case RCC_LSE of
        RCC_LSE_ON:
            RCC.BDCR := RCC_LSE_ON;
        RCC_LSE_Bypass:
            RCC.BDCR := RCC_LSE_ON or RCC_LSE_Bypass;
    end;
end;

procedure RCC_LSICmd(NewState: TState);
begin
    if NewState = Enabled then
        RCC.CSR := RCC.CSR or 1
    else
        RCC.CSR := RCC.CSR and not(1);
end;

procedure RCC_RTCCLKConfig(RCC_RTCCLKSource: longword);
begin
    RCC.BDCR := RCC.BDCR or RCC_RTCCLKSource;
end;

procedure RCC_RTCCLKCmd(NewState: TState);
begin
    if NewState = Enabled then
        RCC.BDCR := RCC.BDCR or $8000
    else
        RCC.BDCR := RCC.BDCR and not($8000);
end;

procedure RCC_GetClocksFreq(out RCC_Clocks: TRCC_ClocksTypeDef);
var tmp, pllmull, pllsource, presc: longword;
begin
    { Get SYSCLK source -------------------------------------------------------}
    tmp := RCC.CFGR and RCC_CFGR_SWS_Mask;

    case tmp of
        $00: { HSI used as system clock }
            RCC_Clocks.SYSCLK_Frequency := HSI_Value;
        $04:  { HSE used as system clock }
            RCC_Clocks.SYSCLK_Frequency := HSE_Value;
        $08:  { PLL used as system clock }
            begin
                { Get PLL clock source and multiplication factor ----------------------}
                pllmull := RCC.CFGR and RCC_CFGR_PLLMull_Mask;
                pllmull := (pllmull shr 18) + 2;

                pllsource := RCC.CFGR and RCC_CFGR_PLLSRC_Mask;

                if pllsource = 0 then
                    RCC_Clocks.SYSCLK_Frequency := (HSI_Value shr 1) * pllmull { HSI oscillator clock divided by 2 selected as PLL clock entry }
                else
                begin{ HSE selected as PLL clock entry }
                    if (RCC.CFGR and RCC_CFGR_PLLXTPRE_Mask) <> RCC_RESET then
                        RCC_Clocks.SYSCLK_Frequency := (HSE_Value shr 1) * pllmull{ HSE oscillator clock divided by 2 }
                    else
                        RCC_Clocks.SYSCLK_Frequency := HSE_Value * pllmull;
                end;
            end;
        else
            RCC_Clocks.SYSCLK_Frequency := HSI_Value;
    end;

    { Compute HCLK, PCLK1, PCLK2 and ADCCLK clocks frequencies ----------------}
    { Get HCLK prescaler }
    tmp := RCC.CFGR and RCC_CFGR_HPRE_Set_Mask;
    tmp := tmp shr 4;
    presc := APBAHBPrescTable[tmp];

    { HCLK clock frequency }
    RCC_Clocks.HCLK_Frequency := RCC_Clocks.SYSCLK_Frequency shr presc;

    { Get PCLK1 prescaler }
    tmp := RCC.CFGR and RCC_CFGR_PPRE1_Set_Mask;
    tmp := tmp shr 8;
    presc := APBAHBPrescTable[tmp];

    { PCLK1 clock frequency }
    RCC_Clocks.PCLK1_Frequency := RCC_Clocks.HCLK_Frequency shr presc;

    { Get PCLK2 prescaler }
    tmp := RCC.CFGR and RCC_CFGR_PPRE2_Set_Mask;
    tmp := tmp shr 11;
    presc := APBAHBPrescTable[tmp];

    { PCLK2 clock frequency }
    RCC_Clocks.PCLK2_Frequency := RCC_Clocks.HCLK_Frequency shr presc;

    { Get ADCCLK prescaler }
    tmp := RCC.CFGR and RCC_CFGR_ADCPRE_Set_Mask;
    tmp := tmp shr 14;
    presc := ADCPrescTable[tmp];

    { ADCCLK clock frequency }
    RCC_Clocks.ADCCLK_Frequency := RCC_Clocks.PCLK2_Frequency div presc;
end;

procedure RCC_AHBPeriphClockCmd(RCC_AHBPeriph: longword; NewState: TState);
var tmpReg: longword;
begin
    tmpReg:= RCC.AHBENR;
    if newstate = enabled then
        tmpReg := tmpReg or RCC_AHBPeriph
    else
        tmpReg := tmpReg and not(RCC_AHBPeriph);
    RCC.AHBENR := tmpReg;
end;

procedure RCC_APB2PeriphClockCmd(RCC_APB2Periph: longword; NewState: TState);
var tmpReg: longword;
begin
    tmpReg := RCC.APB2ENR;
    if newstate = enabled then
        tmpReg := tmpReg or RCC_APB2Periph
    else
        tmpReg := tmpReg and not(RCC_APB2Periph);
    RCC.APB2ENR := tmpReg;
end;

procedure RCC_APB1PeriphClockCmd(RCC_APB1Periph: longword; NewState: TState);
begin
    if newstate = enabled then
        RCC.APB1ENR := RCC.APB1ENR or RCC_APB1Periph
    else
        RCC.APB1ENR := RCC.APB1ENR and not(RCC_APB1Periph);
end;

procedure RCC_APB2PeriphResetCmd(RCC_APB2Periph: longword; NewState: TState);
var tmpReg: longword;
begin
    tmpReg := RCC.APB2RSTR;
    if newstate = enabled then
        tmpReg := tmpReg or RCC_APB2Periph
    else
        tmpReg := tmpReg and not(RCC_APB2Periph);
    RCC.APB2RSTR := tmpReg;
end;

procedure RCC_APB1PeriphResetCmd(RCC_APB1Periph: longword; NewState: TState);
begin
    if newstate = enabled then
        RCC.APB1RSTR := RCC.APB1RSTR or RCC_APB1Periph
    else
        RCC.APB1RSTR := RCC.APB1RSTR and not(RCC_APB1Periph);
end;

procedure RCC_BackupResetCmd(NewState: TState);
begin
    if newstate = enabled then
        RCC.BDCR := RCC.BDCR or $400
    else
        RCC.BDCR := RCC.BDCR and not($400);
end;

procedure RCC_ClockSecuritySystemCmd(NewState: TState);
begin
    if newstate = enabled then
        RCC.CR := RCC.CR or $80000
    else
        RCC.CR := RCC.CR and not($80000);
end;

procedure RCC_MCOConfig(RCC_MCO: byte);
begin
    pbyte($40021007)^ := RCC_MCO;
end;

procedure RCC_ClearFlag;
begin
    RCC.CSR := RCC.CSR or $01000000;
end;

function RCC_GetITStatus(RCC_IT: byte): longword;
begin
    if (RCC.CIR and RCC_IT) <> RCC_RESET then
        exit(RCC_SET)
    else
        exit(RCC_RESET);
end;

procedure RCC_ClearITPendingBit(RCC_IT: byte);
begin
    pbyte($4002100A)^ := RCC_IT;
end;

{ Flash }
const
 FLASH_ACR_LATENCY_Mask         = $00000038;
 FLASH_ACR_HLFCYA_Mask          = $FFFFFFF7;
 FLASH_ACR_PRFTBE_Mask          = $FFFFFFEF;

procedure FLASH_SetLatency(FLASH_Latency: longword);
begin
    FLASH.ACR := FLASH.ACR and FLASH_ACR_LATENCY_Mask;
    FLASH.ACR := FLASH.ACR or FLASH_Latency;
end;

procedure FLASH_HalfCycleAccessCmd(FLASH_HalfCycleAccess: longword);
begin
    FLASH.ACR := FLASH.ACR and FLASH_ACR_HLFCYA_Mask;
   FLASH.ACR := FLASH.ACR or FLASH_HalfCycleAccess;
end;

procedure FLASH_PrefetchBufferCmd(FLASH_PrefetchBuffer: longword);
begin
    FLASH.ACR := FLASH.ACR and FLASH_ACR_PRFTBE_Mask;
    FLASH.ACR := FLASH.ACR or FLASH_PrefetchBuffer;
end;

 {TIMER}

procedure TIM_DeInit(var TIMx: TTimerRegisters);
var
  tmpTIM : ^TTImerRegisters;
begin
   tmpTIM := @TIMx;
   if tmpTIM = @Timer1 then
                begin
                    RCC_APB2PeriphResetCmd(RCC_APB2Periph_TIM1, ENABLED);
                    RCC_APB2PeriphResetCmd(RCC_APB2Periph_TIM1, DISABLED);
		end;
   if tmpTIM = @Timer2 then
                begin
                   RCC_APB1PeriphResetCmd(RCC_APB1Periph_TIM2, ENABLED);
                   RCC_APB1PeriphResetCmd(RCC_APB1Periph_TIM2, DISABLED);
                end;
   if tmpTIM = @Timer3 then
                begin
                   RCC_APB1PeriphResetCmd(RCC_APB1Periph_TIM3, ENABLED);
                   RCC_APB1PeriphResetCmd(RCC_APB1Periph_TIM3, DISABLED);
                end;
   if tmpTIM = @Timer4 then
                begin
                   RCC_APB1PeriphResetCmd(RCC_APB1Periph_TIM4, ENABLED);
                   RCC_APB1PeriphResetCmd(RCC_APB1Periph_TIM4, DISABLED);
                end;
end;

procedure TIM_Cmd(var TIMx: TTimerRegisters; NewState: TState);
begin

   if (NewState <> DISABLED) then
          TIMx.CR1 := TIMx.CR1 or TIM_CR1_CEN
     else
         TIMx.CR1 := TIMx.CR1 and (not TIM_CR1_CEN );

end;

procedure TIM_TimeBaseInit(var TIMx: TTimerRegisters;
	  var TIM_TimeBaseInitStruct: TIM_TimeBaseInitTypeDef);
var
tmpcr1 : word = 0;
tmpTIM : ^TTimerRegisters;
begin
// /* Check the parameters */
// assert_param(IS_TIM_ALL_PERIPH(TIMx));
// assert_param(IS_TIM_COUNTER_MODE(TIM_TimeBaseInitStruct->TIM_CounterMode));
// assert_param(IS_TIM_CKD_DIV(TIM_TimeBaseInitStruct->TIM_ClockDivision));
 tmpTIM := @TIMx;
 tmpcr1 := TIMx.CR1;

 if((tmpTIM = @Timer1) or (tmpTIM = @Timer2) or (tmpTIM =  @Timer3) or (tmpTIM = @Timer4)) then
     begin
        tmpcr1 := tmpcr1 and (not (TIM_CR1_DIR or TIM_CR1_CMS));
        tmpcr1 := tmpcr1 or TIM_TimeBaseInitStruct.TIM_CounterMode;
     end;
 {
   /* Select the Counter Mode */
   tmpcr1 &= (uint16_t)(~((uint16_t)(TIM_CR1_DIR | TIM_CR1_CMS)));
   tmpcr1 |= (uint32_t)TIM_TimeBaseInitStruct->TIM_CounterMode;
 }

 //if((TIMx != TIM6) && (TIMx != TIM7))
 {
   /* Set the clock division */
   tmpcr1 &= (uint16_t)(~((uint16_t)TIM_CR1_CKD));
   tmpcr1 |= (uint32_t)TIM_TimeBaseInitStruct->TIM_ClockDivision;
 }

 TIMx.CR1 := tmpcr1;

 //* Set the Autoreload value */
 TIMx.ARR := TIM_TimeBaseInitStruct.TIM_Period;

 //* Set the Prescaler value */
 TIMx.PSC := TIM_TimeBaseInitStruct.TIM_Prescaler;

 if (tmpTIM = @Timer1) then
     begin
       TIMx.RCR:=TIM_TimeBaseInitStruct.TIM_RepetitionCounter;
     end;
 {
   /* Set the Repetition Counter value */
   TIMx->RCR = TIM_TimeBaseInitStruct->TIM_RepetitionCounter;
 }

 //* Generate an update event to reload the Prescaler and the Repetition counter
 //   values immediately */
 TIMx.EGR := TIM_PSCReloadMode_Immediate;


end;

function TIM_GetITStatus(var TIMx: TTimerRegisters; TIM_IT: word): boolean;
var
 bitstatus : boolean;
 itenable, itstatus : word;

begin
  bitstatus := False;
  itstatus := 0;
  itenable := 0;
  itstatus := TIMx.SR and TIM_IT;
  itenable := TIMx.DIER and TIM_IT;
   if ((itstatus <> 0) and (itenable <> 0)) then
       bitstatus := True;
   result:=bitstatus;
end;


procedure TIM_ICInit(var TIMx: TTimerRegisters;
	  var TIM_ICInitStruct: TIM_ICInitTypeDef);
begin



end;



{/**
  * @brief  Configures the TIMx\92s DMA interface.
  * @param TIMx: where x can be  1, 2, 3, 4, 5 or 8 to select the TIM
  *   peripheral.
  * @param TIM_DMABase: DMA Base address.
  *   This parameter can be one of the following values:
  * @arg TIM_DMABase_CR, TIM_DMABase_CR2, TIM_DMABase_SMCR,
  *   TIM_DMABase_DIER, TIM1_DMABase_SR, TIM_DMABase_EGR,
  *   TIM_DMABase_CCMR1, TIM_DMABase_CCMR2, TIM_DMABase_CCER,
  *   TIM_DMABase_CNT, TIM_DMABase_PSC, TIM_DMABase_ARR,
  *   TIM_DMABase_RCR, TIM_DMABase_CCR1, TIM_DMABase_CCR2,
  *   TIM_DMABase_CCR3, TIM_DMABase_CCR4, TIM_DMABase_BDTR,
  *   TIM_DMABase_DCR.
  * @param TIM_DMABurstLength: DMA Burst length.
  *   This parameter can be one value between:
  *   TIM_DMABurstLength_1Byte and TIM_DMABurstLength_18Bytes.
  * @retval : None
  */}
procedure TIM_DMAConfig(var TIMx : TTimerRegisters; TIM_DMABase : word;TIM_DMABurstLength : word);
begin

  //* Set the DMA Base and the DMA Burst Length */
  TIMx.DCR := TIM_DMABase or TIM_DMABurstLength;
end;

{/**
  * @brief  Enables or disables the TIMx\92s DMA Requests.
  * @param TIMx: where x can be  1 to 8 to select the TIM peripheral.
  * @param TIM_DMASource: specifies the DMA Request sources.
  *   This parameter can be any combination of the following values:
  * @arg TIM_DMA_Update: TIM update Interrupt source
  * @arg TIM_DMA_CC1: TIM Capture Compare 1 DMA source
  * @arg TIM_DMA_CC2: TIM Capture Compare 2 DMA source
  * @arg TIM_DMA_CC3: TIM Capture Compare 3 DMA source
  * @arg TIM_DMA_CC4: TIM Capture Compare 4 DMA source
  * @arg TIM_DMA_COM: TIM Commutation DMA source
  * @arg TIM_DMA_Trigger: TIM Trigger DMA source
  * @param NewState: new state of the DMA Request sources.
  *   This parameter can be: ENABLE or DISABLE.
  * @retval : None
  */}
procedure TIM_DMACmd(var TIMx :TTimerRegisters; TIM_DMASource : word;  NewState: TState);
begin

  if (NewState <> DISABLED) then
  begin
    //* Enable the DMA sources */
    TIMx.DIER := TIMx.DIER or TIM_DMASource;
  end
  else
  begin
    //* Disable the DMA sources */
    TIMx.DIER := TIMx.DIER and (not TIM_DMASource);
  end;
end;

procedure TIM_OC1Init(var TIMx: TTimerRegisters;
	  var TIM_OCInitStruct: TIM_OCInitTypeDef);
var
  tmpccmrx :word = 0;
  tmpccer :word = 0;
  tmpcr2 :word = 0;
begin
    //* Disable the Channel 1: Reset the CC1E Bit */
  TIMx.CCER := TIMx.CCER and ( not (TIM_CCER_CC1E));
  //* Get the TIMx CCER register value */
  tmpccer := TIMx.CCER;
  //* Get the TIMx CR2 register value */
  tmpcr2 :=  TIMx.CR2;

  //* Get the TIMx CCMR1 register value */
  tmpccmrx := TIMx.CCMR1;

    //* Reset the Output Compare Mode Bits */
  tmpccmrx := tmpccmrx and (not(TIM_CCMR1_OC1M));
  tmpccmrx := tmpccmrx and (not(TIM_CCMR1_CC1S));

  //* Select the Output Compare Mode */
  tmpccmrx := tmpccmrx or TIM_OCInitStruct.TIM_OCMode;

  //* Reset the Output Polarity level */
  tmpccer := tmpccer and (not(TIM_CCER_CC1P));
  //* Set the Output Compare Polarity */
  tmpccer := tmpccer or TIM_OCInitStruct.TIM_OCPolarity;

  //* Set the Output State */
  tmpccer := tmpccer or TIM_OCInitStruct.TIM_OutputState;
  if (@TIMx = @Timer1) or (@TIMx = @Timer8) then
  begin
    //* Reset the Output N Polarity level */
    tmpccer := tmpccer and (not(TIM_CCER_CC1NP));
    //* Set the Output N Polarity */
    tmpccer := tmpccer or TIM_OCInitStruct.TIM_OCNPolarity;

    //* Reset the Output N State */
    tmpccer := tmpccer and (not(TIM_CCER_CC1NE));
    //* Set the Output N State */
    tmpccer := tmpccer or TIM_OCInitStruct.TIM_OutputNState;

    //* Reset the Output Compare and Output Compare N IDLE State */
    tmpcr2 := tmpcr2 and (not(TIM_CR2_OIS1));
    tmpcr2 := tmpcr2 and (not(TIM_CR2_OIS1N));

    //* Set the Output Idle state */
    tmpcr2 := tmpcr2 or TIM_OCInitStruct.TIM_OCIdleState;
    //* Set the Output N Idle state */
    tmpcr2 := tmpcr2 or TIM_OCInitStruct.TIM_OCNIdleState;
  end;
    //* Write to TIMx CR2 */
  TIMx.CR2 := tmpcr2;

  //* Write to TIMx CCMR1 */
  TIMx.CCMR1 := tmpccmrx;

  //* Set the Capture Compare Register value */
  TIMx.CCR1 := TIM_OCInitStruct.TIM_Pulse;

  //* Write to TIMx CCER */
  TIMx.CCER := tmpccer;
end;

procedure TIM_OC2Init(var TIMx: TTimerRegisters;
	  var TIM_OCInitStruct: TIM_OCInitTypeDef);
var
  tmpccmrx :word = 0;
  tmpccer :word = 0;
  tmpcr2 :word = 0;
begin
    //* Disable the Channel 1: Reset the CC1E Bit */
  TIMx.CCER := TIMx.CCER and ( not (TIM_CCER_CC2E));
  //* Get the TIMx CCER register value */
  tmpccer := TIMx.CCER;
  //* Get the TIMx CR2 register value */
  tmpcr2 :=  TIMx.CR2;

  //* Get the TIMx CCMR1 register value */
  tmpccmrx := TIMx.CCMR1;

    //* Reset the Output Compare Mode Bits */
  tmpccmrx := tmpccmrx and (not(TIM_CCMR1_OC2M));
  tmpccmrx := tmpccmrx and (not(TIM_CCMR1_CC2S));

  //* Select the Output Compare Mode */
  tmpccmrx := tmpccmrx or (TIM_OCInitStruct.TIM_OCMode shl 8);

  //* Reset the Output Polarity level */
  tmpccer := tmpccer and (not(TIM_CCER_CC2P));
  //* Set the Output Compare Polarity */
  tmpccer := tmpccer or (TIM_OCInitStruct.TIM_OCPolarity shl 4);

  //* Set the Output State */
  tmpccer := tmpccer or (TIM_OCInitStruct.TIM_OutputState shl 4);
  if (@TIMx = @Timer1) or (@TIMx = @Timer8) then
  begin
    //* Reset the Output N Polarity level */
    tmpccer := tmpccer and (not(TIM_CCER_CC2NP));
    //* Set the Output N Polarity */
    tmpccer := tmpccer or (TIM_OCInitStruct.TIM_OCNPolarity shl 4);

    //* Reset the Output N State */
    tmpccer := tmpccer and (not(TIM_CCER_CC2NE));
    //* Set the Output N State */
    tmpccer := tmpccer or (TIM_OCInitStruct.TIM_OutputNState shl 4);

    //* Reset the Output Compare and Output Compare N IDLE State */
    tmpcr2 := tmpcr2 and (not(TIM_CR2_OIS2));
    tmpcr2 := tmpcr2 and (not(TIM_CR2_OIS2N));

    //* Set the Output Idle state */
    tmpcr2 := tmpcr2 or (TIM_OCInitStruct.TIM_OCIdleState shl 2);
    //* Set the Output N Idle state */
    tmpcr2 := tmpcr2 or (TIM_OCInitStruct.TIM_OCNIdleState shl 2);
  end;
    //* Write to TIMx CR2 */
  TIMx.CR2 := tmpcr2;

  //* Write to TIMx CCMR1 */
  TIMx.CCMR1 := tmpccmrx;

  //* Set the Capture Compare Register value */
  TIMx.CCR2 := TIM_OCInitStruct.TIM_Pulse;

  //* Write to TIMx CCER */
  TIMx.CCER := tmpccer;

end;

procedure TIM_OC3Init(var TIMx: TTimerRegisters;
	  var TIM_OCInitStruct: TIM_OCInitTypeDef);
var
  tmpccmrx :word = 0;
  tmpccer :word = 0;
  tmpcr2 :word = 0;
begin
    //* Disable the Channel 1: Reset the CC1E Bit */
  TIMx.CCER := TIMx.CCER and ( not (TIM_CCER_CC3E));
  //* Get the TIMx CCER register value */
  tmpccer := TIMx.CCER;
  //* Get the TIMx CR2 register value */
  tmpcr2 :=  TIMx.CR2;

  //* Get the TIMx CCMR2 register value */
  tmpccmrx := TIMx.CCMR2;

    //* Reset the Output Compare Mode Bits */
  tmpccmrx := tmpccmrx and (not(TIM_CCMR2_OC3M));
  tmpccmrx := tmpccmrx and (not(TIM_CCMR2_CC3S));

  //* Select the Output Compare Mode */
  tmpccmrx := tmpccmrx or TIM_OCInitStruct.TIM_OCMode;

  //* Reset the Output Polarity level */
  tmpccer := tmpccer and (not(TIM_CCER_CC3P));
  //* Set the Output Compare Polarity */
  tmpccer := tmpccer or (TIM_OCInitStruct.TIM_OCPolarity shl 8);

  //* Set the Output State */
  tmpccer := tmpccer or (TIM_OCInitStruct.TIM_OutputState shl 8);
  if (@TIMx = @Timer1) or (@TIMx = @Timer8) then
  begin
    //* Reset the Output N Polarity level */
    tmpccer := tmpccer and (not(TIM_CCER_CC3NP));
    //* Set the Output N Polarity */
    tmpccer := tmpccer or (TIM_OCInitStruct.TIM_OCNPolarity shl 8);

    //* Reset the Output N State */
    tmpccer := tmpccer and (not(TIM_CCER_CC3NE));
    //* Set the Output N State */
    tmpccer := tmpccer or (TIM_OCInitStruct.TIM_OutputNState shl 8);

    //* Reset the Output Compare and Output Compare N IDLE State */
    tmpcr2 := tmpcr2 and (not(TIM_CR2_OIS3));
    tmpcr2 := tmpcr2 and (not(TIM_CR2_OIS3N));

    //* Set the Output Idle state */
    tmpcr2 := tmpcr2 or (TIM_OCInitStruct.TIM_OCIdleState shl 4);
    //* Set the Output N Idle state */
    tmpcr2 := tmpcr2 or (TIM_OCInitStruct.TIM_OCNIdleState shl 4);
  end;
    //* Write to TIMx CR2 */
  TIMx.CR2 := tmpcr2;

  //* Write to TIMx CCMR1 */
  TIMx.CCMR2 := tmpccmrx;

  //* Set the Capture Compare Register value */
  TIMx.CCR3 := TIM_OCInitStruct.TIM_Pulse;

  //* Write to TIMx CCER */
  TIMx.CCER := tmpccer;

end;

procedure TIM_OC4Init(var TIMx: TTimerRegisters;
	  var TIM_OCInitStruct: TIM_OCInitTypeDef);
var
  tmpccmrx :word = 0;
  tmpccer :word = 0;
  tmpcr2 :word = 0;
begin
    //* Disable the Channel 1: Reset the CC1E Bit */
  TIMx.CCER := TIMx.CCER and ( not (TIM_CCER_CC4E));
  //* Get the TIMx CCER register value */
  tmpccer := TIMx.CCER;
  //* Get the TIMx CR2 register value */
  tmpcr2 :=  TIMx.CR2;

  //* Get the TIMx CCMR2 register value */
  tmpccmrx := TIMx.CCMR2;

    //* Reset the Output Compare Mode Bits */
  tmpccmrx := tmpccmrx and (not(TIM_CCMR2_OC4M));
  tmpccmrx := tmpccmrx and (not(TIM_CCMR2_CC4S));

  //* Select the Output Compare Mode */
  tmpccmrx := tmpccmrx or (TIM_OCInitStruct.TIM_OCMode shl 8);

  //* Reset the Output Polarity level */
  tmpccer := tmpccer and (not(TIM_CCER_CC4P));
  //* Set the Output Compare Polarity */
  tmpccer := tmpccer or (TIM_OCInitStruct.TIM_OCPolarity shl 12);

  //* Set the Output State */
  tmpccer := tmpccer or (TIM_OCInitStruct.TIM_OutputState shl 12);
  if (@TIMx = @Timer1) or (@TIMx = @Timer8) then
  begin



    //* Reset the Output Compare and Output Compare IDLE State */
    tmpcr2 := tmpcr2 and (not(TIM_CR2_OIS4));


    //* Set the Output Idle state */
    tmpcr2 := tmpcr2 or (TIM_OCInitStruct.TIM_OCIdleState shl 6);

  end;
    //* Write to TIMx CR2 */
  TIMx.CR2 := tmpcr2;

  //* Write to TIMx CCMR1 */
  TIMx.CCMR2 := tmpccmrx;

  //* Set the Capture Compare Register value */
  TIMx.CCR4 := TIM_OCInitStruct.TIM_Pulse;

  //* Write to TIMx CCER */
  TIMx.CCER := tmpccer;

end;

procedure TIM_OC1PreloadConfig(var TIMx: TTimerRegisters; TIM_OCPreload: word);
var
  tmpccmr1 : word =0;
begin
  tmpccmr1 := TIMx.CCMR1;
  //* Reset the OC1PE Bit */
  tmpccmr1 := tmpccmr1 and (not(TIM_CCMR1_OC1PE));
  //* Enable or Disable the Output Compare Preload feature */
  tmpccmr1 := tmpccmr1 or TIM_OCPreload;
  //* Write to TIMx CCMR1 register */
  TIMx.CCMR1 := tmpccmr1;
end;

procedure TIM_OC2PreloadConfig(var TIMx: TTimerRegisters; TIM_OCPreload: word);
var
  tmpccmr1 : word =0;
begin
  tmpccmr1 := TIMx.CCMR1;
  //* Reset the OC2PE Bit */
  tmpccmr1 := tmpccmr1 and (not(TIM_CCMR1_OC2PE));
  //* Enable or Disable the Output Compare Preload feature */
  tmpccmr1 := tmpccmr1 or (TIM_OCPreload shl 8);
  //* Write to TIMx CCMR1 register */
  TIMx.CCMR1 := tmpccmr1;

end;

procedure TIM_OC3PreloadConfig(var TIMx: TTimerRegisters; TIM_OCPreload: word);
var
  tmpccmr2 : word =0;
begin
  tmpccmr2 := TIMx.CCMR2;
  //* Reset the OC1PE Bit */
  tmpccmr2 := tmpccmr2 and (not(TIM_CCMR2_OC3PE));
  //* Enable or Disable the Output Compare Preload feature */
  tmpccmr2 := tmpccmr2 or TIM_OCPreload;
  //* Write to TIMx CCMR1 register */
  TIMx.CCMR2 := tmpccmr2;

end;

procedure TIM_OC4PreloadConfig(var TIMx: TTimerRegisters; TIM_OCPreload: word);
var
  tmpccmr2 : word =0;
begin
  tmpccmr2 := TIMx.CCMR2;
  //* Reset the OC1PE Bit */
  tmpccmr2 := tmpccmr2 and (not(TIM_CCMR2_OC4PE));
  //* Enable or Disable the Output Compare Preload feature */
  tmpccmr2 := tmpccmr2 or (TIM_OCPreload shl 8);
  //* Write to TIMx CCMR1 register */
  TIMx.CCMR2 := tmpccmr2;

end;

procedure TIM_ARRPreloadConfig(var TIMx: TTimerRegisters; NewState: TState);
begin
    if (NewState <> DISABLED) then
  begin
    //* Set the ARR Preload Bit */
    TIMx.CR1 := Timx.CR1 or TIM_CR1_ARPE;
  end
  else
  begin
    //* Reset the ARR Preload Bit */
    TIMx.CR1 := TIMx.CR1 and (not(TIM_CR1_ARPE));
  end;
end;

procedure TIM_CCxCmd(var TIMx: TTimerRegisters; TIM_Channel: word; TIM_CCx: word
	  );
begin

end;

procedure TIM_CCxNCmd(var TIMx: TTimerRegisters; TIM_Channel: word;
	  TIM_CCxN: word);
begin

end;

procedure TIM_CtrlPWMOutputs(var TIMx: TTimerRegisters; NewState: TState);
begin
   if (NewState <> DISABLED) then
   begin
    //* Enable the TIM Main Output */
    TIMx.BDTR := TIMx.BDTR or TIM_BDTR_MOE;
  end
  else
  begin
    //* Disable the TIM Main Output */
    TIMx.BDTR := TIMx.BDTR and (not(TIM_BDTR_MOE));
  end;

end;




{
 /**
  * @brief  Initializes the TIM peripheral according to the specified
  *   parameters in the TIM_ICInitStruct.
  * @param TIMx: where x can be  1, 2, 3, 4, 5 or 8 to select the TIM
  *   peripheral.
  * @param TIM_ICInitStruct: pointer to a TIM_ICInitTypeDef structure
  *   that contains the configuration information for the specified
  *   TIM peripheral.
  * @retval : None
  */
void TIM_ICInit(TIM_TypeDef* TIMx, TIM_ICInitTypeDef* TIM_ICInitStruct)
{
  /* Check the parameters */
  assert_param(IS_TIM_123458_PERIPH(TIMx));
  assert_param(IS_TIM_CHANNEL(TIM_ICInitStruct->TIM_Channel));
  assert_param(IS_TIM_IC_POLARITY(TIM_ICInitStruct->TIM_ICPolarity));
  assert_param(IS_TIM_IC_SELECTION(TIM_ICInitStruct->TIM_ICSelection));
  assert_param(IS_TIM_IC_PRESCALER(TIM_ICInitStruct->TIM_ICPrescaler));
  assert_param(IS_TIM_IC_FILTER(TIM_ICInitStruct->TIM_ICFilter));

  if (TIM_ICInitStruct->TIM_Channel == TIM_Channel_1)
  {
    /* TI1 Configuration */
    TI1_Config(I1_ConfigTIMx, TIM_ICInitStruct->TIM_ICPolarity,
               TIM_ICInitStruct->TIM_ICSelection,
               TIM_ICInitStruct->TIM_ICFilter);
    /* Set the Input Capture Prescaler value */
    TIM_SetIC1Prescaler(TIMx, TIM_ICInitStruct->TIM_ICPrescaler);
  }
  else if (TIM_ICInitStruct->TIM_Channel == TIM_Channel_2)
  {
    /* TI2 Configuration */
    TI2_Config(TIMx, TIM_ICInitStruct->TIM_ICPolarity,
               TIM_ICInitStruct->TIM_ICSelection,
               TIM_ICInitStruct->TIM_ICFilter);
    /* Set the Input Capture Prescaler value */
    TIM_SetIC2Prescaler(TIMx, TIM_ICInitStruct->TIM_ICPrescaler);
  }
  else if (TIM_ICInitStruct->TIM_Channel == TIM_Channel_3)
  {
    /* TI3 Configuration */
    TI3_Config(TIMx,  TIM_ICInitStruct->TIM_ICPolarity,
               TIM_ICInitStruct->TIM_ICSelection,
               TIM_ICInitStruct->TIM_ICFilter);
    /* Set the Input Capture Prescaler value */
    TIM_SetIC3Prescaler(TIMx, TIM_ICInitStruct->TIM_ICPrescaler);
  }
  else
  {
    /* TI4 Configuration */
    TI4_Config(TIMx, TIM_ICInitStruct->TIM_ICPolarity,
               TIM_ICInitStruct->TIM_ICSelection,
               TIM_ICInitStruct->TIM_ICFilter);
    /* Set the Input Capture Prescaler value */
    TIM_SetIC4Prescaler(TIMx, TIM_ICInitStruct->TIM_ICPrescaler);
  }
}


}





procedure TIM_ClearITPendingBit(var TIMx: TTimerRegisters; TIM_IT: word);
begin
   TIMx.SR := not TIM_IT;
end;

procedure TIM_ITConfig(var TIMx: TTimerRegisters; TIM_IT: word; NewState: TState
	  );
begin
  if (NewState <> DISABLED) then
          TIMx.DIER := TIMx.DIER or TIM_IT
     else
         TIMx.DIER := TIMx.DIER and (not TIM_IT);

end;

{ GPIO }
const
 GPIO_EVCR_PORTPINCONFIG_MASK     = $FF80;
 GPIO_LSB_MASK                    = $FFFF;
 GPIO_DBGAFR_POSITION_MASK        = $000F0000;
 GPIO_DBGAFR_SWJCFG_MASK          = $F8FFFFFF;
 GPIO_DBGAFR_LOCATION_MASK        = $00200000;
 GPIO_DBGAFR_NUMBITS_MASK         = $00100000;


procedure GPIO_DeInit(var GPIOx: TPortRegisters);
begin
    if @GPIOx = @PortA then
    begin
        RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOA, ENABLED);
        RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOA, DISABLED);
    end
    else if @GPIOx = @PortB then
    begin
        RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOB, ENABLED);
        RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOB, DISABLED);
    end
    else if @GPIOx = @PortC then
    begin
        RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOC, ENABLED);
        RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOC, DISABLED);
    end
    else if @GPIOx = @PortD then
    begin
        RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOD, ENABLED);
        RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOD, DISABLED);
    end
    else if @GPIOx = @PortE then
    begin
        RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOE, ENABLED);
        RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOE, DISABLED);
    end;
    {case PtrUInt(@GPIOx) of
        GPIOA_BASE:
        begin
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOA, ENABLED);
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOA, DISABLED);
        end;
        GPIOB_BASE:
        begin
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOB, ENABLED);
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOB, DISABLED);
        end;
        GPIOC_BASE:
        begin
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOC, ENABLED);
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOC, DISABLED);
        end;
        GPIOD_BASE:
        begin
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOD, ENABLED);
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOD, DISABLED);
        end;
        GPIOE_BASE:
        begin
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOE, ENABLED);
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOE, DISABLED);
        end;
    end;}
end;

procedure GPIO_AFIODeInit;
begin
    RCC_APB2PeriphResetCmd(RCC_APB2Periph_AFIO, ENABLED);
    RCC_APB2PeriphResetCmd(RCC_APB2Periph_AFIO, DISABLED);
end;

procedure GPIO_Init(var GPIOx: TPortRegisters; const GPIO_InitStruct: TGPIO_InitTypeDef);
var currentmode, currentpin, pinpos, pos, tmpreg, pinmask: dword;
begin
    {---------------------------- GPIO Mode Configuration -----------------------}
    currentmode := longint(GPIO_InitStruct.GPIO_Mode) and $0F;

    if (longint(GPIO_InitStruct.GPIO_Mode) and $10) <> $00 then
    begin
        { Output mode }
        currentmode := currentmode or longword(GPIO_InitStruct.GPIO_Speed);
    end;

    {---------------------------- GPIO CRL Configuration ------------------------}
    { Configure the eight low port pins }
    if (GPIO_InitStruct.GPIO_Pin and $00FF) <> $00 then
    begin
        tmpreg := GPIOx.CRL;

        for pinpos := 0 to 7 do
        begin
            pos := 1 shl pinpos;
            { Get the port pins position }
            currentpin := GPIO_InitStruct.GPIO_Pin and pos;

            if currentpin = pos then
            begin
                pos := pinpos shl 2;
                { Clear the corresponding low control register bits }
                pinmask := $0F shl pos;
                tmpreg := tmpreg and not(pinmask);

                { Write the mode configuration in the corresponding bits }
                tmpreg := tmpreg or (currentmode shl pos);

                { Reset the corresponding ODR bit }
                if GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IPD then
                    GPIOx.BRR := 1 shl pinpos;

                { Set the corresponding ODR bit }
                if GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IPU then
                    GPIOx.BSRR := 1 shl pinpos;
            end;
        end;
        GPIOx.CRL := tmpreg;
        tmpreg := 0;
    end;

    {---------------------------- GPIO CRH Configuration ------------------------}
    { Configure the eight high port pins }
    if GPIO_InitStruct.GPIO_Pin > $00FF then
    begin
        tmpreg := GPIOx.CRH;
        for pinpos := 0 to 7 do
        begin
            pos := 1 shl (pinpos + 8);
            { Get the port pins position }
            currentpin := GPIO_InitStruct.GPIO_Pin and pos;

            if currentpin = pos then
            begin
                pos := pinpos shl 2;
                { Clear the corresponding high control register bits }
                pinmask := $0F shl pos;
                tmpreg := tmpreg and not(pinmask);

                { Write the mode configuration in the corresponding bits }
                tmpreg := tmpreg or (currentmode shl pos);

                { Reset the corresponding ODR bit }
                if GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IPD then
                    GPIOx.BRR := 1 shl (pinpos + 8);

                { Set the corresponding ODR bit }
                if GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IPU then
                    GPIOx.BSRR := 1 shl (pinpos + 8);
            end;
        end;
        GPIOx.CRH := tmpreg;
    end;
end;

procedure TIM_TimeBaseStructInit(
	  var TIM_TimeBaseInitStruct: TIM_TimeBaseInitTypeDef);
begin

end;

procedure GPIO_StructInit(out GPIO_InitStruct: TGPIO_InitTypeDef);
begin
    GPIO_InitStruct.GPIO_Pin := GPIO_Pin_All;
    GPIO_InitStruct.GPIO_Speed := GPIO_Speed_2MHz;
    GPIO_InitStruct.GPIO_Mode := GPIO_Mode_IN_FLOATING;
end;

function GPIO_ReadInputDataBit(var GPIOx: TPortRegisters; GPIO_Pin: word): byte;
begin
    exit(ord((GPIOx.IDR and GPIO_Pin) <> 0));
end;

function GPIO_ReadInputData(var GPIOx: TPortRegisters): word;
begin
    exit(GPIOx.IDR);
end;

function GPIO_ReadOutputDataBit(var GPIOx: TPortRegisters; GPIO_Pin: word): byte;
begin
    exit(ord((GPIOx.ODR and GPIO_Pin) <> 0));
end;

function GPIO_ReadOutputData(var GPIOx: TPortRegisters): word;
begin
    exit(GPIOx.ODR);
end;

procedure GPIO_SetBits(var GPIOx: TPortRegisters; GPIO_Pin: word);
begin
    GPIOx.BSRR := GPIO_Pin;
end;

procedure GPIO_ResetBits(var GPIOx: TPortRegisters; GPIO_Pin: word);
begin
    GPIOx.BRR := GPIO_Pin;
end;

procedure GPIO_WriteBit(var GPIOx: TPortRegisters; GPIO_Pin: Word; BitVal: TBitAction);
begin
    if BitVal <> Bit_RESET then
        GPIOx.BSRR := GPIO_Pin
    else
        GPIOx.BRR := GPIO_Pin;
end;

procedure GPIO_Write(var GPIOx: TPortRegisters; PortVal: word);
begin
    GPIOx.ODR := PortVal;
end;

procedure GPIO_PinLockConfig(var GPIOx: TPortRegisters; GPIO_Pin: word);
var tmp: longword;
begin
    tmp := $00010000;

    tmp := tmp or GPIO_Pin;
    { Set LCKK bit }
    GPIOx.LCKR := tmp;
    { Reset LCKK bit }
    GPIOx.LCKR := GPIO_Pin;
    { Set LCKK bit }
    GPIOx.LCKR := tmp;
    { Read LCKK bit}
    tmp := GPIOx.LCKR;
    { Read LCKK bit}
    tmp := GPIOx.LCKR;
end;

procedure GPIO_EventOutputConfig(GPIO_PortSource, GPIO_PinSource: byte);
var tmpreg: longword;
begin
    tmpreg := AFIO.EVCR;
    { Clear the PORT[6:4] and PIN[3:0] bits }
    tmpreg := tmpreg and GPIO_EVCR_PORTPINCONFIG_MASK;
    tmpreg := tmpreg or (GPIO_PortSource shl 4);
    tmpreg := tmpreg or GPIO_PinSource;

    AFIO.EVCR := tmpreg;
end;

procedure GPIO_EventOutputCmd(NewState: TState);
begin
    if NewState = Enabled then
        AFIO.EVCR := AFIO.EVCR or $80
    else
        AFIO.EVCR := AFIO.EVCR or not(longword($80));
end;

procedure GPIO_PinRemapConfig(GPIO_Remap: longword; NewState: TState);
var tmp, tmp1, tmpreg, tmpmask: longword;
begin
    tmpreg := AFIO.MAPR;
    tmp1 := 0;

    tmpmask := (GPIO_Remap and GPIO_DBGAFR_POSITION_MASK) shr $10;
    tmp := GPIO_Remap and GPIO_LSB_MASK;

    if (GPIO_Remap and GPIO_DBGAFR_LOCATION_MASK) = GPIO_DBGAFR_LOCATION_MASK then
    begin
        tmpreg := tmpreg and GPIO_DBGAFR_SWJCFG_MASK;
    end
    else if (GPIO_Remap and GPIO_DBGAFR_NUMBITS_MASK) = GPIO_DBGAFR_NUMBITS_MASK then
    begin
        tmp1 := 3 shl tmpmask;
        tmpreg := tmpreg and not(tmp1);
    end
    else
        tmpreg := tmpreg and not(tmp);

    if NewState = enabled then
    begin
        if (GPIO_Remap and GPIO_DBGAFR_LOCATION_MASK) = GPIO_DBGAFR_LOCATION_MASK then
            tmpreg := tmpreg or (tmp shl $10)
        else
            tmpreg := tmpreg or tmp;
    end;
    AFIO.MAPR := tmpreg;
end;

procedure GPIO_EXTILineConfig(GPIO_PortSource, GPIO_PinSource: byte);
var tmp: longword;
begin
    tmp := $0F shl ($04 * (GPIO_PinSource and 3));

    AFIO.EXTICR[GPIO_PinSource shr $02] := AFIO.EXTICR[GPIO_PinSource shr $02] and not(tmp);
    AFIO.EXTICR[GPIO_PinSource shr $02] := AFIO.EXTICR[GPIO_PinSource shr $02] or (GPIO_PortSource shl ($04 * (GPIO_PinSource and 3)));
end;

{ USART }
const
 { USART RUN Mask }
  CR1_RUN_Set               = $2000;  { USART Enable Mask }
  CR1_RUN_Reset             = $DFFF;  { USART Disable Mask }

  CR2_Address_Mask          = $FFF0;  { USART address Mask }

 { USART RWU Mask }
  CR1_RWU_Set               = $0002;  { USART mute mode Enable Mask }

  USART_IT_Mask             = $001F;  { USART Interrupt Mask }

 { USART LIN Mask }
  CR2_LINE_Set              = $4000;  { USART LIN Enable Mask }
  CR2_LINE_Reset            = $BFFF;  { USART LIN Disable Mask }

  CR1_SBK_Set               = $0001;  { USART Break Character send Mask }

 { USART SC Mask }
  CR3_SCEN_Set              = $0020;  { USART SC Enable Mask }
  CR3_SCEN_Reset            = $FFDF;  { USART SC Disable Mask }

 { USART SC NACK Mask }
  CR3_NACK_Set              = $0010;  { USART SC NACK Enable Mask }
  CR3_NACK_Reset            = $FFEF;  { USART SC NACK Disable Mask }

 { USART Half-Duplex Mask }
  CR3_HDSEL_Set             = $0008;  { USART Half-Duplex Enable Mask }
  CR3_HDSEL_Reset           = $FFF7;  { USART Half-Duplex Disable Mask }

 { USART IrDA Mask }
  CR3_IRLP_Mask             = $FFFB;  { USART IrDA LowPower mode Mask }

 { USART LIN Break detection }
  CR3_LBDL_Mask             = $FFDF;  { USART LIN Break detection Mask }

 { USART WakeUp Method  }
  CR3_WAKE_Mask             = $F7FF;  { USART WakeUp Method Mask }

 { USART IrDA Mask }
  CR3_IREN_Set              = $0002;  { USART IrDA Enable Mask }
  CR3_IREN_Reset            = $FFFD;  { USART IrDA Disable Mask }

  GTPR_LSB_Mask             = $00FF;  { Guard Time Register LSB Mask }
  GTPR_MSB_Mask             = $FF00;  { Guard Time Register MSB Mask }

  CR1_CLEAR_Mask            = $E9F3;  { USART CR1 Mask }
  CR2_CLEAR_Mask            = $C0FF;  { USART CR2 Mask }
  CR3_CLEAR_Mask            = $FCFF;  { USART CR3 Mask }


procedure USART_DeInit(var USARTx: TUSARTRegisters);
begin
  if @USARTx = @Usart1 then
  begin
    RCC_APB2PeriphResetCmd(RCC_APB2Periph_USART1, ENABLED);
    RCC_APB2PeriphResetCmd(RCC_APB2Periph_USART1, DISABLED);
  end
  else if @USARTx = @Usart2 then
  begin
    RCC_APB1PeriphResetCmd(RCC_APB1Periph_USART2, ENABLED);
    RCC_APB1PeriphResetCmd(RCC_APB1Periph_USART2, DISABLED);
  end
  else if @USARTx = @Usart3 then
  begin
    RCC_APB1PeriphResetCmd(RCC_APB1Periph_USART3, ENABLED);
    RCC_APB1PeriphResetCmd(RCC_APB1Periph_USART3, DISABLED);
  end;
end;

//======================================================================
procedure USART_Init(var USARTx: TUSARTRegisters; var USART_InitStruct: TUSART_InitTypeDef);
var apbclock: longword;
   RCC_ClocksStatus: TRCC_ClocksTypeDef;
begin
  {---------------------------- USART CR2 Configuration -----------------------}
  USARTx.CR2 := (USARTx.CR2 and CR2_CLEAR_Mask) or USART_InitStruct.USART_StopBits or USART_InitStruct.USART_Clock or USART_InitStruct.USART_CPOL or USART_InitStruct.USART_CPHA or USART_InitStruct.USART_LastBit;

  {---------------------------- USART CR1 Configuration -----------------------}
  USARTx.CR1 := (USARTx.CR1 and CR1_CLEAR_Mask) or USART_InitStruct.USART_WordLength or USART_InitStruct.USART_Parity or USART_InitStruct.USART_Mode;

  {---------------------------- USART CR3 Configuration -----------------------}
  USARTx.CR3 := (USARTx.CR3 and CR3_CLEAR_Mask) or USART_InitStruct.USART_HardwareFlowControl;

  {---------------------------- USART BRR Configuration -----------------------}
  RCC_GetClocksFreq(RCC_ClocksStatus);

  if @USARTx = @Usart1 then
    apbclock := RCC_ClocksStatus.PCLK2_Frequency
  else
    apbclock := RCC_ClocksStatus.PCLK1_Frequency;

  { Write to USART BRR }
  USARTx.BRR := apbclock div USART_InitStruct.USART_BaudRate;
end;

//======================================================================
procedure USART_StructInit(var USART_InitStruct: TUSART_InitTypeDef);
begin
  USART_InitStruct.USART_BaudRate   := $2580; { 9600 Baud }
  USART_InitStruct.USART_WordLength := USART_WordLength_8b;
  USART_InitStruct.USART_StopBits   := USART_StopBits_1;
  USART_InitStruct.USART_Parity     := USART_Parity_No ;
  USART_InitStruct.USART_Mode       := USART_Mode_Rx or USART_Mode_Tx;
  USART_InitStruct.USART_Clock      := USART_Clock_Disable;
  USART_InitStruct.USART_CPOL       := USART_CPOL_Low;
  USART_InitStruct.USART_CPHA       := USART_CPHA_1Edge;
  USART_InitStruct.USART_LastBit    := USART_LastBit_Disable;
  USART_InitStruct.USART_HardwareFlowControl := USART_HardwareFlowControl_None;
end;

//======================================================================
procedure USART_Cmd(var USARTx: TUSARTRegisters; NewState: TState);
begin
  if NewState = ENABLED then
    USARTx.CR1 := USARTx.CR1 or CR1_RUN_Set
  else
    USARTx.CR1 := USARTx.CR1 and CR1_RUN_Reset;
end;

//======================================================================
procedure USART_ITConfig(var USARTx: TUSARTRegisters; USART_IT: word; NewState: TState);
var usartreg, itpos, itmask: longword;
   address: ^dword;
begin
  usartreg := (byte(USART_IT) shr $05);

  itpos := USART_IT and USART_IT_Mask;

  itmask := dword(1 shl itpos);

  case usartreg of
    1: address := @USARTx.CR1;
    2: address := @USARTx.CR2;
  else
    address := @USARTx.CR3;
  end;

  if newstate = enabled then
    dword(address^) := dword(address^) or itmask
  else
    dword(address^) := dword(address^) and not(itmask);

end;

//======================================================================
procedure USART_DMACmd(var USARTx: TUSARTRegisters; USART_DMAReq: word; NewState: TState);
begin
  if newstate = enabled then
    USARTx.CR3 := USARTx.CR3 or USART_DMAReq
  else
    USARTx.CR3 := USARTx.CR3 and not(USART_DMAReq);
end;

//======================================================================
procedure USART_SetAddress(var USARTx: TUSARTRegisters; USART_Address: byte);
begin
  USARTx.CR2 := USARTx.CR2 and CR2_Address_Mask;
  USARTx.CR2 := USARTx.CR2 or USART_Address;
end;

//======================================================================
procedure USART_WakeUpConfig(var USARTx: TUSARTRegisters; USART_WakeUp: word);
begin
  USARTx.CR1 := USARTx.CR1 and CR3_WAKE_Mask;
  USARTx.CR1 := USARTx.CR1 or USART_WakeUp;
end;

//======================================================================
procedure USART_ReceiverWakeUpCmd(var USARTx: TUSARTRegisters; NewState: TState);
begin
  if newstate = enabled then
    USARTx.CR1 := USARTx.CR1 or CR1_RWU_Set
  else
    USARTx.cr1 := USARTx.cr1 and not(CR1_RWU_Set);
end;

//======================================================================
procedure USART_LINBreakDetectLengthConfig(var USARTx: TUSARTRegisters; USART_LINBreakDetectLength: word);
begin
  USARTx.CR2 := USARTx.CR2 and CR3_LBDL_Mask;
  USARTx.CR2 := USARTx.CR2 or USART_LINBreakDetectLength;
end;

//======================================================================
procedure USART_LINCmd(var USARTx: TUSARTRegisters; NewState: TState);
begin
  if newstate = enabled then
    USARTx.CR2 := USARTx.CR2 or CR2_LINE_Set
  else
    USARTx.CR2 := USARTx.CR2 and CR2_LINE_Reset;
end;

//======================================================================
procedure USART_SendData(var USARTx: TUSARTRegisters; Data: Word);
begin
  //USARTx.DR := Data and $1FF;
  USARTx.DR := Data;
  while (USARTx.SR AND USART_FLAG_TXE) = 0 do;
end;

//======================================================================
procedure USART_SendString(var USARTx: TUSARTRegisters; Data: String);
var
  i : word;
begin
  for i := 1 to length(Data) do
  begin
     USARTx.DR := ord(Data[i]) and $1FF;
    while (USARTx.SR AND USART_FLAG_TXE) = 0 do;
  end;
end;

//======================================================================
function USART_ReceiveData(var USARTx: TUSARTRegisters): Word;
begin
  USART_ReceiveData := (USARTx.DR and $1FF);
end;

//======================================================================
procedure USART_SendBreak(var USARTx: TUSARTRegisters);
begin
  USARTx.CR1 := USARTx.CR1 or CR1_SBK_Set;
end;

//======================================================================
procedure USART_SetGuardTime(var USARTx: TUSARTRegisters; USART_GuardTime: byte);
begin
  USARTx.GTPR := USARTx.GTPR and GTPR_LSB_Mask;
  USARTx.GTPR := USARTx.GTPR or (USART_GuardTime shl 8);
end;

//======================================================================
procedure USART_SetPrescaler(var USARTx: TUSARTRegisters; USART_Prescaler: byte);
begin
  USARTx.GTPR := USARTx.GTPR and GTPR_MSB_Mask;
  USARTx.GTPR := USARTx.GTPR or USART_Prescaler;
end;

//======================================================================
procedure USART_SmartCardCmd(var USARTx: TUSARTRegisters; NewState: TState);
begin
  if newstate = enabled then
    USARTx.CR3 := USARTx.CR3 or CR3_SCEN_Set
  else
    USARTx.CR3 := USARTx.CR3 and CR3_SCEN_Reset;
end;

//======================================================================
procedure USART_SmartCardNACKCmd(var USARTx: TUSARTRegisters; NewState: TState);
begin
  if newstate = enabled then
    USARTx.CR3 := USARTx.CR3 or CR3_NACK_Set
  else
    USARTx.CR3 := USARTx.CR3 and CR3_NACK_Reset;
end;

//======================================================================
procedure USART_HalfDuplexCmd(var USARTx: TUSARTRegisters; NewState: TState);
begin
  if newstate = enabled then
    USARTx.CR3 := USARTx.CR3 or CR3_HDSEL_Set
  else
    USARTx.CR3 := USARTx.CR3 and CR3_HDSEL_Reset;
end;

//======================================================================
procedure USART_IrDAConfig(var USARTx: TUSARTRegisters; USART_IrDAMode: word);
begin
  USARTx.CR3 := USARTx.CR3 and CR3_IRLP_Mask;
  USARTx.CR3 := USARTx.CR3 or USART_IrDAMode;
end;

//======================================================================
procedure USART_IrDACmd(var USARTx: TUSARTRegisters; NewState: TState);
begin
  if newstate = enabled then
    USARTx.CR3 := USARTx.CR3 or CR3_IREN_Set
  else
    USARTx.CR3 := USARTx.CR3 and CR3_IREN_Reset;
end;

//======================================================================
function USART_GetFlagStatus(var USARTx: TUSARTRegisters; USART_FLAG: word
	  ): longword;
begin
  USART_GetFlagStatus := (USARTx.SR AND USART_FLAG);
end;

//======================================================================
procedure USART_ClearFlag(var USARTx: TUSARTRegisters; USART_FLAG: word);
begin
  USARTx.SR := USARTx.SR AND NOT (1 shl 5);
end;

//======================================================================
function USART_GetITStatus(var USARTx: TUSARTRegisters; USART_IT: word): longword;
var bitpos, itmask, usartreg: longword;
begin
  usartreg := (byte(USART_IT) shr 5);

  itmask := USART_IT and USART_IT_Mask;

  itmask := dword(1) shl itmask;

  if usartreg = 1 then
    itmask := itmask and USARTx.CR1
  else if usartreg = 2 then
    itmask := itmask and usartx.CR2
  else
    itmask := itmask and usartx.CR3;

  bitpos := USART_IT shr 8;

  bitpos := dword(1) shl bitpos;
  bitpos := bitpos and USARTx.SR;

  if (itmask <> 0)  and (bitpos <> 0) then
    USART_GetITStatus := 1
  else
    USART_GetITStatus  := 0;
end;

//======================================================================
procedure USART_ClearITPendingBit(var USARTx: TUSARTRegisters; USART_IT: word);
var bitpos, itmask: longword;
begin
  bitpos := USART_IT shr 8;

  itmask := word(1) shl word(bitpos);
  USARTx.SR := USARTx.SR and not(itmask);
end;


{ NVIC }
const
//Private
 AIRCR_VECTKEY_MASK    = $05FA0000;

procedure NVIC_PriorityGroupConfig(PriorityGroup: longword);
begin
    SCB.AIRCR := AIRCR_VECTKEY_MASK or PriorityGroup;
end;

procedure NVIC_Init(const NVIC_InitStruct: TNVIC_InitTypeDef);
var tmppriority, tmppre, tmpsub: longword;
    tmpmask, tmpreg: longword;
begin
    if NVIC_InitStruct.NVIC_IRQChannelCmd <> Disabled then
    begin
        { Compute the Corresponding IRQ Priority --------------------------------}
       tmppriority := ($700 - (SCB.AIRCR and $700)) shr $08;
        tmppre := (4 - tmppriority);
        tmpsub := $0F shr tmppriority;

        tmppriority := NVIC_InitStruct.NVIC_IRQChannelPreemptionPriority shl tmppre;
        tmppriority := tmppriority or (NVIC_InitStruct.NVIC_IRQChannelSubPriority and tmpsub);

        tmppriority := tmppriority shl $04;
      tmppriority := tmppriority shl ((NVIC_InitStruct.NVIC_IRQChannel and 3) * $08);

      tmpreg := NVIC.IP[NVIC_InitStruct.NVIC_IRQChannel shr 2];
      tmpmask := $FF shl ((NVIC_InitStruct.NVIC_IRQChannel and 3) * 8);
      tmpreg := tmpreg and (not tmpmask);
      tmppriority := tmppriority and tmpmask;
      tmpreg := tmpreg or tmppriority;

        NVIC.IP[NVIC_InitStruct.NVIC_IRQChannel shr 2] := tmpreg;

        { Enable the Selected IRQ Channels --------------------------------------}
        NVIC.ISER[NVIC_InitStruct.NVIC_IRQChannel shr 5] := 1 shl (NVIC_InitStruct.NVIC_IRQChannel and $1F);
    end
    else
        NVIC.ICER[NVIC_InitStruct.NVIC_IRQChannel shr 5] := 1 shl (NVIC_InitStruct.NVIC_IRQChannel and $1F);
end;

procedure NVIC_SetVectorTable(NVIC_VectTab, Offset: Longword);
begin
    SCB.VTOR := NVIC_VectTab or (offset and $1FFFFF80);
end;

procedure NVIC_SystemLPConfig(LowPowerMode: byte; NewState: TState);
begin
    case NewState of
        Disabled:
            SCB.SCR := SCB.SCR or LowPowerMode;
        Enabled:
            SCB.SCR := SCB.SCR and not(LowPowerMode);
    end;
end;

procedure NVIC_SystemHandlerConfig(SystemHandler: longword; NewState: TState);
var tmpreg: longword;
begin
   tmpreg := 1 shl (SystemHandler and $1F);

   if NewState = Enabled then
      SCB.SHCSR := SCB.SHCSR or tmpreg
   else
      SCB.SHCSR := SCB.SHCSR and (not tmpreg);
end;

procedure NVIC_SystemHandlerPriorityConfig(SystemHandler: longword; SystemHandlerPreemptionPriority, SystemHandlerSubPriority: byte);
var tmp1,tmp2,handlermask,tmppriority: longword;
begin
   tmp2 := $FF;
   handlermask := $00;

   tmppriority := ($700 - (SCB.AIRCR and $700)) shr $08;
   tmp1 := ($4 - tmppriority);
   tmp2 := tmp2 shr tmppriority;

   tmppriority := SystemHandlerPreemptionPriority shl tmp1;
   tmppriority := tmppriority or (SystemHandlerSubPriority and tmp2);

   tmppriority := tmppriority shl $04;
   tmp1 := SystemHandler and $C0;
   tmp1 := tmp1 shr $06;
   tmp2 := (SystemHandler shr $08) and $03;
   tmppriority := tmppriority shl (tmp2 * $08);
   handlermask := $FF shl (tmp2 * $08);

   SCB.SHP[tmp1] := SCB.SHP[tmp1] and (not handlermask);
   SCB.SHP[tmp1] := SCB.SHP[tmp1] or tmppriority;
end;

function NVIC_GetCurrentPendingIRQChannel: word;
begin
   NVIC_GetCurrentPendingIRQChannel := (SCB.ICSR and $003FF000) shr $0C;
end;

function NVIC_GetSystemHandlerActiveBitStatus(SystemHandler: longword): boolean;
var tmppos: longword;
begin
   tmppos := (SystemHandler shr $0E) and $0F;
   NVIC_GetSystemHandlerActiveBitStatus := (SCB.SHCSR and tmppos) = tmppos;
end;

procedure NVIC_SetSystemHandlerPendingBit(SystemHandler: longword);
begin
   SCB.ICSR := SCB.ICSR or (longword(1) shl (SystemHandler and $1F));
end;

function NVIC_GetSystemHandlerPendingBit(SystemHandler: longword): boolean;
begin
   NVIC_GetSystemHandlerPendingBit := (SCB.ICSR and (1 shl (SystemHandler and $1F))) <> 0;
end;

{ SysTick }
const
 {
  /* SysTick Control / Status Register Definitions */
SysTick_CTRL_COUNTFLAG_Pos         16                                             /*!< SysTick CTRL: COUNTFLAG Position */
SysTick_CTRL_COUNTFLAG_Msk         (1UL << SysTick_CTRL_COUNTFLAG_Pos)            /*!< SysTick CTRL: COUNTFLAG Mask */

SysTick_CTRL_CLKSOURCE_Pos          2                                             /*!< SysTick CTRL: CLKSOURCE Position */
SysTick_CTRL_CLKSOURCE_Msk         (1UL << SysTick_CTRL_CLKSOURCE_Pos)            /*!< SysTick CTRL: CLKSOURCE Mask */

SysTick_CTRL_TICKINT_Pos            1                                             /*!< SysTick CTRL: TICKINT Position */
SysTick_CTRL_TICKINT_Msk           (1UL << SysTick_CTRL_TICKINT_Pos)              /*!< SysTick CTRL: TICKINT Mask */

SysTick_CTRL_ENABLE_Pos             0                                             /*!< SysTick CTRL: ENABLE Position */
SysTick_CTRL_ENABLE_Msk            (1UL << SysTick_CTRL_ENABLE_Pos)               /*!< SysTick CTRL: ENABLE Mask */

/* SysTick Reload Register Definitions */
SysTick_LOAD_RELOAD_Pos             0                                             /*!< SysTick LOAD: RELOAD Position */
SysTick_LOAD_RELOAD_Msk            (0xFFFFFFUL << SysTick_LOAD_RELOAD_Pos)        /*!< SysTick LOAD: RELOAD Mask */

/* SysTick Current Register Definitions */
SysTick_VAL_CURRENT_Pos             0                                             /*!< SysTick VAL: CURRENT Position */
SysTick_VAL_CURRENT_Msk            (0xFFFFFFUL << SysTick_VAL_CURRENT_Pos)        /*!< SysTick VAL: CURRENT Mask */

/* SysTick Calibration Register Definitions */
SysTick_CALIB_NOREF_Pos            31                                             /*!< SysTick CALIB: NOREF Position */
SysTick_CALIB_NOREF_Msk            (1UL << SysTick_CALIB_NOREF_Pos)               /*!< SysTick CALIB: NOREF Mask */

SysTick_CALIB_SKEW_Pos             30                                             /*!< SysTick CALIB: SKEW Position */
SysTick_CALIB_SKEW_Msk             (1UL << SysTick_CALIB_SKEW_Pos)                /*!< SysTick CALIB: SKEW Mask */

SysTick_CALIB_TENMS_Pos             0                                             /*!< SysTick CALIB: TENMS Position */
SysTick_CALIB_TENMS_Msk            (0xFFFFFFUL << SysTick_VAL_CURRENT_Pos)        /*!< SysTick CALIB: TENMS Mask */



 }
 CTRL_TICKINT_Set     = $00000002;
 CTRL_TICKINT_Reset   = $FFFFFFFD;
 SysTick_CTRL_COUNTFLAG_Pos = 16;
 SysTick_CTRL_COUNTFLAG_Msk = (1 shl SysTick_CTRL_COUNTFLAG_Pos);
 SysTick_CTRL_CLKSOURCE_Pos = 2;
 SysTick_CTRL_CLKSOURCE_Msk = ( 1 shl SysTick_CTRL_CLKSOURCE_Pos);
 SysTick_CTRL_TICKINT_Pos =  1;
 SysTick_CTRL_TICKINT_Msk =  (1 shl SysTick_CTRL_TICKINT_Pos);
 SysTick_CTRL_ENABLE_Pos =  0;
 SysTick_CTRL_ENABLE_Msk = (1 shl SysTick_CTRL_ENABLE_Pos);
 SysTick_LOAD_RELOAD_Pos = 0;
 SysTick_LOAD_RELOAD_Msk = ($FFFFFF shl SysTick_LOAD_RELOAD_Pos);


procedure SysTick_CLKSourceConfig(SysTick_CLKSource: longword);
begin
    if SysTick_CLKSource = SysTick_CLKSource_HCLK then
        SysTick.CTRL := SysTick.Ctrl or SysTick_CLKSource_HCLK
    else
        SysTick.CTRL := SysTick.CTRL and SysTick_CLKSource_HCLK_Div8;
end;

procedure SysTick_SetReload(Reload: LongWord);
begin
    SysTick.LOAD := Reload;
end;

procedure SysTick_CounterCmd(SysTick_Counter: Longword);
begin
    if systick_counter = systick_counter_enable then
        systick.ctrl := systick.ctrl or systick_counter_enable
    else if systick_counter = SysTick_Counter_Disable then
        systick.ctrl := systick.ctrl and SysTick_Counter_Disable
    else
        SysTick.VAL := SysTick_Counter_Clear;
end;

procedure SysTick_ITConfig(NewState: TState);
begin
    if NewState <> DISABLED then
        SysTick.CTRL := SysTick.CTRL or CTRL_TICKINT_Set
    else
        SysTick.CTRL := SysTick.CTRL and CTRL_TICKINT_Reset;
end;

function SysTick_GetCounter: LongWord;
begin
    exit(SysTick.Val);
end;

function SysTick_GetFlagStatus(SysTick_FLAG: byte): boolean;
var tmp, statusreg: LongWord;
begin
    tmp := SysTick_FLAG shr 3;

    if tmp = 2 then
        statusreg := systick.ctrl
    else
        statusreg := systick.calib;

    result := (statusreg and (1 shl SysTick_Flag)) <> 0;
end;

function SysTick_Config(ticks: longword): integer;
begin
    if ((ticks - 1) > SysTick_LOAD_RELOAD_Msk) then
       begin
         Systick_Config := 1;
       end;
    SysTick.Load  := ticks - 1;
  SysTick.Val  := 0;
  SysTick.CTRL  := SysTick_CTRL_CLKSOURCE_Msk or
                   SysTick_CTRL_TICKINT_Msk   or
                   SysTick_CTRL_ENABLE_Msk;
  Systick_Config := 0;
end;

function Millis: int64;
begin
   Millis:=SystemTick;
end;

function Micros: int64;
begin
   Micros:=SystemTick*1000 + 1000 - (SysTick_GetCounter  div 72);
end;



//======================================================================
procedure delay_ms(ms_delay : dword);
var
curTime : longword;
begin
  curTime := SystemTick;
  while((ms_delay-(SystemTick-curTime)) > 0) do;

end;

//======================================================================
procedure delay_us(us_delay : dword);
var
   curTime : longword;
begin
   curTime := Micros;
   while((us_delay-(Micros-curTime)) > 0) do;
end;

{ SPI }

(* SPI SPE mask  *)

const
  CR1_SPE_Set = $0040;
  CR1_SPE_Reset = $FFBF;
  (* I2S I2SE mask  *)

  I2SCFGR_I2SE_Set = $0400;
  I2SCFGR_I2SE_Reset = $FBFF;
  (* SPI CRCNext mask  *)

  CR1_CRCNext_Set = $1000;
  (* SPI CRCEN mask  *)

  CR1_CRCEN_Set = $2000;
  CR1_CRCEN_Reset = $DFFF;
  (* SPI SSOE mask  *)

  CR2_SSOE_Set = $0004;
  CR2_SSOE_Reset = $FFFB;
  (* SPI registers Masks  *)

  SPI_CR1_CLEAR_Mask = $3040;
  I2SCFGR_CLEAR_Mask = $F040;
  (* SPI or I2S mode selection masks  *)

  SPI_Mode_Select = $F7FF;
  I2S_Mode_Select = $0800;

procedure SPI_I2S_DeInit(var SPIx: TSPIRegisters);
begin
   case Ptruint(@SPIx) of
      ptruint(@SPI1):
         begin
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_SPI1, Enabled);
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_SPI1, Disabled);
         end;
      ptruint(@SPI2):
         begin
            RCC_APB1PeriphResetCmd(RCC_APB1Periph_SPI2, Enabled);
            RCC_APB1PeriphResetCmd(RCC_APB1Periph_SPI2, Disabled);
         end;
      {ptruint(@SPI3):
         begin
            RCC_APB1PeriphResetCmd(RCC_APB1Periph_SPI3, Enabled);
            RCC_APB1PeriphResetCmd(RCC_APB1Periph_SPI3, Disabled);
         end;}
   end;
end;

procedure SPI_Init(var SPIx: TSPIRegisters; const SPI_InitStruct: TSPI_InitTypeDef);
var tmpreg: word;
begin
   (* Get the SPIx CR1 value *)
   tmpreg := SPIx.CR1;
   (* Clear BIDIMode, BIDIOE, RxONLY, SSM, SSI, LSBFirst, BR, MSTR, CPOL and CPHA bits *)
   tmpreg := tmpreg and SPI_CR1_CLEAR_Mask;
   (* Configure SPIx: direction, NSS management, first transmitted bit, BaudRate prescaler
     master/salve mode, CPOL and CPHA *)
   (* Set BIDImode, BIDIOE and RxONLY bits according to SPI_Direction value *)
   (* Set SSM, SSI and MSTR bits according to SPI_Mode and SPI_NSS values *)
   (* Set LSBFirst bit according to SPI_FirstBit value *)
   (* Set BR bits according to SPI_BaudRatePrescaler value *)
   (* Set CPOL bit according to SPI_CPOL value *)
   (* Set CPHA bit according to SPI_CPHA value *)
   tmpreg := tmpreg or (SPI_InitStruct.SPI_Direction or SPI_InitStruct.SPI_Mode or
                  SPI_InitStruct.SPI_DataSize or SPI_InitStruct.SPI_CPOL or
                  SPI_InitStruct.SPI_CPHA or SPI_InitStruct.SPI_NSS or
                  SPI_InitStruct.SPI_BaudRatePrescaler or SPI_InitStruct.SPI_FirstBit);
   (* Write to SPIx CR1 *)
   SPIx.CR1 := tmpreg;

   (* Activate the SPI mode (Reset I2SMOD bit in I2SCFGR register) *)
   SPIx.I2SCFGR := SPIx.I2SCFGR and SPI_Mode_Select;

   (*---------------------------- SPIx CRCPOLY Configuration --------------------*)
   (* Write to SPIx CRCPOLY *)
   SPIx.CRCPR := SPI_InitStruct.SPI_CRCPolynomial;
end;

procedure I2S_Init(var SPIx: TSPIRegisters; const I2S_InitStruct: TI2S_InitTypeDef);
var tmpreg,
    i2sodd,i2sdiv,packetlength: word;
    tmp: longword;
    RCC_Clocks: TRCC_ClocksTypeDef;
begin
(*----------------------- SPIx I2SCFGR & I2SPR Configuration -----------------*)

   (* Clear I2SMOD, I2SE, I2SCFG, PCMSYNC, I2SSTD, CKPOL, DATLEN and CHLEN bits *)
   SPIx.I2SCFGR := SPIx.I2SCFGR and I2SCFGR_CLEAR_Mask;
   SPIx.I2SPR := $0002;

   (* Get the I2SCFGR register value *)
   tmpreg := SPIx.I2SCFGR;

   (* If the default value has to be written, reinitialize i2sdiv and i2sodd*)
   if I2S_InitStruct.I2S_AudioFreq = I2S_AudioFreq_Default then
   begin
    i2sodd := 0;
    i2sdiv := 2;
   end
   (* If the requested audio frequency is not the default, compute the prescaler *)
   else
   begin
      (* Check the frame length (For the Prescaler computing) *)
      if I2S_InitStruct.I2S_DataFormat = I2S_DataFormat_16b then
      begin
         (* Packet length is 16 bits *)
         packetlength := 1;
      end
      else
      begin
         (* Packet length is 32 bits *)
         packetlength := 2;
      end;
      (* Get System Clock frequency *)
      RCC_GetClocksFreq(RCC_Clocks);

      (* Compute the Real divider depending on the MCLK output state with a flaoting point *)
      if I2S_InitStruct.I2S_MCLKOutput = I2S_MCLKOutput_Enable then
      begin
         (* MCLK output is enabled *)
         tmp := ((longword(10 * RCC_Clocks.SYSCLK_Frequency) div longword(256 * I2S_InitStruct.I2S_AudioFreq)) + 5);
      end
      else
      begin
         (* MCLK output is disabled *)
         tmp := ((longword(10 * RCC_Clocks.SYSCLK_Frequency) div longword(32 * packetlength * I2S_InitStruct.I2S_AudioFreq)) + 5);
      end;

      (* Remove the flaoting point *)
      tmp := tmp div 10;

      (* Check the parity of the divider *)
      i2sodd := tmp and $0001;

      (* Compute the i2sdiv prescaler *)
      i2sdiv := (tmp - i2sodd) div 2;

      (* Get the Mask for the Odd bit (SPI_I2SPR[8]) register *)
      i2sodd := i2sodd shl 8;
   end;

   (* Test if the divider is 1 or 0 *)
   if (i2sdiv < 2) or (i2sdiv > $FF) then
   begin
      (* Set the default values *)
      i2sdiv := 2;
      i2sodd := 0;
   end;

   (* Write to SPIx I2SPR register the computed value *)
   SPIx.I2SPR := i2sdiv or i2sodd or I2S_InitStruct.I2S_MCLKOutput;

   (* Configure the I2S with the SPI_InitStruct values *)
   tmpreg := tmpreg or (I2S_Mode_Select or I2S_InitStruct.I2S_Mode or
                        I2S_InitStruct.I2S_Standard or I2S_InitStruct.I2S_DataFormat or
                        I2S_InitStruct.I2S_CPOL);

   (* Write to SPIx I2SCFGR *)
   SPIx.I2SCFGR := tmpreg;
end;

procedure SPI_StructInit(out SPI_InitStruct: TSPI_InitTypeDef);
begin
(*--------------- Reset SPI init structure parameters values -----------------*)
  (* Initialize the SPI_Direction member *)
  SPI_InitStruct.SPI_Direction := SPI_Direction_2Lines_FullDuplex;

  (* initialize the SPI_Mode member *)
  SPI_InitStruct.SPI_Mode := SPI_Mode_Slave;

  (* initialize the SPI_DataSize member *)
  SPI_InitStruct.SPI_DataSize := SPI_DataSize_8b;

  (* Initialize the SPI_CPOL member *)
  SPI_InitStruct.SPI_CPOL := SPI_CPOL_Low;

  (* Initialize the SPI_CPHA member *)
  SPI_InitStruct.SPI_CPHA := SPI_CPHA_1Edge;

  (* Initialize the SPI_NSS member *)
  SPI_InitStruct.SPI_NSS := SPI_NSS_Hard;

  (* Initialize the SPI_BaudRatePrescaler member *)
  SPI_InitStruct.SPI_BaudRatePrescaler := SPI_BaudRatePrescaler_2;

  (* Initialize the SPI_FirstBit member *)
  SPI_InitStruct.SPI_FirstBit := SPI_FirstBit_MSB;

  (* Initialize the SPI_CRCPolynomial member *)
  SPI_InitStruct.SPI_CRCPolynomial := 7;
end;

procedure I2S_StructInit(out I2S_InitStruct: TI2S_InitTypeDef);
begin
(*--------------- Reset I2S init structure parameters values -----------------*)
  (* Initialize the I2S_Mode member *)
  I2S_InitStruct.I2S_Mode := I2S_Mode_SlaveTx;

  (* Initialize the I2S_Standard member *)
  I2S_InitStruct.I2S_Standard := I2S_Standard_Phillips;

  (* Initialize the I2S_DataFormat member *)
  I2S_InitStruct.I2S_DataFormat := I2S_DataFormat_16b;

  (* Initialize the I2S_MCLKOutput member *)
  I2S_InitStruct.I2S_MCLKOutput := I2S_MCLKOutput_Disable;

  (* Initialize the I2S_AudioFreq member *)
  I2S_InitStruct.I2S_AudioFreq := I2S_AudioFreq_Default;

  (* Initialize the I2S_CPOL member *)
  I2S_InitStruct.I2S_CPOL := I2S_CPOL_Low;
end;

procedure SPI_Cmd(var SPIx: TSPIRegisters; NewState: TState);
begin
   if NewState <> Disabled then
      SPIx.CR1 := SPIx.CR1 or CR1_SPE_Set
   else
      SPIx.CR1 := SPIx.CR1 and CR1_SPE_Reset;
end;

procedure I2S_Cmd(var SPIx: TSPIRegisters; NewState: TState);
begin
   if NewState <> Disabled then
      SPIx.I2SCFGR := SPIx.I2SCFGR or I2SCFGR_I2SE_Set
   else
      SPIx.I2SCFGR := SPIx.I2SCFGR and I2SCFGR_I2SE_Reset;
end;

procedure SPI_I2S_ITConfig(var SPIx: TSPIRegisters; SPI_I2S_IT: byte; NewState: TState);
var itpos: longint;
    itmask: word;
begin
   itpos := SPI_I2S_IT shr 4;
   (* Set the IT mask *)
   itmask := 1 shl itpos;

   if NewState <> Disabled then
   begin
      (* Enable the selected SPI/I2S interrupt *)
      SPIx.CR2 := SPIx.CR2 or itmask;
   end
   else
   begin
      (* Disable the selected SPI/I2S interrupt *)
      SPIx.CR2 := SPIx.CR2 and (not itmask);
   end;
end;

procedure SPI_I2S_DMACmd(var SPIx: TSPIRegisters; SPI_I2S_DMAReq: word; NewState: TState);
begin
   if NewState <> Disabled then
   begin
      (* Enable the selected SPI/I2S DMA requests *)
      SPIx.CR2 := SPIx.CR2 or SPI_I2S_DMAReq;
   end
   else
   begin
      (* Disable the selected SPI/I2S DMA requests *)
      SPIx.CR2 := SPIx.CR2 and (not SPI_I2S_DMAReq);
   end;
end;

procedure SPI_I2S_SendData(var SPIx: TSPIRegisters; Data: word);
begin
   (* Write in the DR register the data to be sent *)
   SPIx.DR := Data;
end;

function SPI_I2S_ReceiveData(var SPIx: TSPIRegisters): word;
begin
   result := SPIx.DR;
end;

procedure SPI_NSSInternalSoftwareConfig(var SPIx: TSPIRegisters; SPI_NSSInternalSoft: word);
begin
   if SPI_NSSInternalSoft <> SPI_NSSInternalSoft_Reset then
   begin
      (* Set NSS pin internally by software *)
      SPIx.CR1 := SPIx.CR1 or SPI_NSSInternalSoft_Set;
   end
   else
   begin
      (* Reset NSS pin internally by software *)
      SPIx.CR1 := SPIx.CR1 and SPI_NSSInternalSoft_Reset;
   end;
end;

procedure SPI_SSOutputCmd(var SPIx: TSPIRegisters; NewState: TState);
begin
   if NewState <> Disabled then
   begin
      (* Enable the selected SPI SS output *)
      SPIx.CR2 := SPIx.CR2 or CR2_SSOE_Set;
   end
   else
   begin
      (* Disable the selected SPI SS output *)
      SPIx.CR2 := SPIx.CR2 and CR2_SSOE_Reset;
   end;
end;

procedure SPI_DataSizeConfig(var SPIx: TSPIRegisters; SPI_DataSize: word);
begin
   (* Clear DFF bit *)
   SPIx.CR1 := SPIx.CR1 and (not SPI_DataSize_16b);
   (* Set new DFF bit value *)
   SPIx.CR1 := SPIx.CR1 or SPI_DataSize;
end;

procedure SPI_TransmitCRC(var SPIx: TSPIRegisters);
begin
   (* Enable the selected SPI CRC transmission *)
   SPIx.CR1 := SPIx.CR1 or CR1_CRCNext_Set;
end;

procedure SPI_CalculateCRC(var SPIx: TSPIRegisters; NewState: TState);
begin
   if NewState <> Disabled then
   begin
      (* Enable the selected SPI CRC calculation *)
      SPIx.CR1 := SPIx.CR1 or CR1_CRCEN_Set;
   end
   else
   begin
      (* Disable the selected SPI CRC calculation *)
      SPIx.CR1 := SPIx.CR1 and CR1_CRCEN_Reset;
   end;
end;

function SPI_GetCRC(var SPIx: TSPIRegisters; SPI_CRC: byte): word;
var crcreg: word;
begin
   if SPI_CRC <> SPI_CRC_Rx then
   begin
      (* Get the Tx CRC register *)
      crcreg := SPIx.TXCRCR;
   end
   else
   begin
      (* Get the Rx CRC register *)
      crcreg := SPIx.RXCRCR;
   end;

   (* result := the selected CRC register *)
   result := crcreg;
end;

function SPI_GetCRCPolynomial(var SPIx: TSPIRegisters): word;
begin
   (* result := the CRC polynomial register *)
   result := SPIx.CRCPR;
end;

procedure SPI_BiDirectionalLineConfig(var SPIx: TSPIRegisters; SPI_Direction: word);
begin
   if SPI_Direction = SPI_Direction_Tx then
   begin
      (* Set the Tx only mode *)
      SPIx.CR1 := SPIx.CR1 or SPI_Direction_Tx;
   end
   else
   begin
      (* Set the Rx only mode *)
      SPIx.CR1 := SPIx.CR1 and SPI_Direction_Rx;
   end;
end;

function SPI_I2S_GetFlagStatus(var SPIx: TSPIRegisters; SPI_I2S_FLAG: word): boolean;
begin
   result := (SPIx.SR and SPI_I2S_FLAG) <> 0;
end;

procedure SPI_I2S_ClearFlag(var SPIx: TSPIRegisters; SPI_I2S_FLAG: word);
begin
   (* Clear the selected SPI CRC Error (CRCERR) flag *)
   SPIx.SR := not SPI_I2S_FLAG;
end;

function SPI_I2S_GetITStatus(var SPIx: TSPIRegisters; SPI_I2S_IT: byte): Boolean;
var itpos, itmask, enablestatus: word;
begin
   (* Get the SPI/I2S IT index *)
   itpos := 1 shl (SPI_I2S_IT and $0F);

   (* Get the SPI/I2S IT mask *)
   itmask := SPI_I2S_IT shr 4;
   (* Set the IT mask *)
   itmask := 1 shl itmask;
   (* Get the SPI_I2S_IT enable bit status *)
   enablestatus := SPIx.CR2 and itmask;

   (* Check the status of the specified SPI/I2S interrupt *)
   result := ((SPIx.SR and itpos) <> 0) and (enablestatus <> 0);
end;

procedure SPI_I2S_ClearITPendingBit(var SPIx: TSPIRegisters; SPI_I2S_IT: byte);
var itpos: word;
begin
   (* Get the SPI IT index *)
   itpos := 1 shl (SPI_I2S_IT and $F);
   (* Clear the selected SPI CRC Error (CRCERR) interrupt pending bit *)
   SPIx.SR := not itpos;
end;

{ ADC }

(* ADC DISCNUM mask  *)

const
  CR1_DISCNUM_Reset = $FFFF1FFF;
  (* ADC DISCEN mask  *)

  CR1_DISCEN_Set = $00000800;
  CR1_DISCEN_Reset = $FFFFF7FF;
  (* ADC JAUTO mask  *)

  CR1_JAUTO_Set = $00000400;
  CR1_JAUTO_Reset = $FFFFFBFF;
  (* ADC JDISCEN mask  *)

  CR1_JDISCEN_Set = $00001000;
  CR1_JDISCEN_Reset = $FFFFEFFF;
  (* ADC AWDCH mask  *)

  CR1_AWDCH_Reset = $FFFFFFE0;
  (* ADC Analog watchdog enable mode mask  *)

  CR1_AWDMode_Reset = $FF3FFDFF;
  (* CR1 register Mask  *)

  ADC_CR1_CLEAR_Mask = $FFF0FEFF;
  (* ADC ADON mask  *)

  CR2_ADON_Set = $00000001;
  CR2_ADON_Reset = $FFFFFFFE;
  (* ADC DMA mask  *)

  CR2_DMA_Set = $00000100;
  CR2_DMA_Reset = $FFFFFEFF;
  (* ADC RSTCAL mask  *)

  CR2_RSTCAL_Set = $00000008;
  (* ADC CAL mask  *)

  CR2_CAL_Set = $00000004;
  (* ADC SWSTART mask  *)

  CR2_SWSTART_Set = $00400000;
  (* ADC EXTTRIG mask  *)

  CR2_EXTTRIG_Set = $00100000;
  CR2_EXTTRIG_Reset = $FFEFFFFF;
  (* ADC Software start mask  *)

  CR2_EXTTRIG_SWSTART_Set = $00500000;
  CR2_EXTTRIG_SWSTART_Reset = $FFAFFFFF;
  (* ADC JEXTSEL mask  *)

  CR2_JEXTSEL_Reset = $FFFF8FFF;
  (* ADC JEXTTRIG mask  *)

  CR2_JEXTTRIG_Set = $00008000;
  CR2_JEXTTRIG_Reset = $FFFF7FFF;
  (* ADC JSWSTART mask  *)

  CR2_JSWSTART_Set = $00200000;
  (* ADC injected software start mask  *)

  CR2_JEXTTRIG_JSWSTART_Set = $00208000;
  CR2_JEXTTRIG_JSWSTART_Reset = $FFDF7FFF;
  (* ADC TSPD mask  *)

  CR2_TSVREFE_Set = $00800000;
  CR2_TSVREFE_Reset = $FF7FFFFF;
  (* CR2 register Mask  *)

  ADC_CR2_CLEAR_Mask = $FFF1F7FD;
  (* ADC SQx mask  *)

  SQR3_SQ_Set = $0000001F;
  SQR2_SQ_Set = $0000001F;
  SQR1_SQ_Set = $0000001F;
  (* SQR1 register Mask  *)

  SQR1_CLEAR_Mask = $FF0FFFFF;
  (* ADC JSQx mask  *)

  JSQR_JSQ_Set = $0000001F;
  (* ADC JL mask  *)

  JSQR_JL_Set = $00300000;
  JSQR_JL_Reset = $FFCFFFFF;
  (* ADC SMPx mask  *)

  SMPR1_SMP_Set = $00000007;
  SMPR2_SMP_Set = $00000007;
  (* ADC JDRx registers offset  *)

  JDR_Offset = $28;
  (* ADC1 DR register base address  *)

  DR_ADDRESS = $4001244C;

procedure ADC_DeInit(var ADCx: TADCRegisters);
begin
   case ptruint(@ADCx) of
      ptruint(@ADC1):
         begin
            (* Enable ADC1 reset state *)
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_ADC1, Enabled);
            (* Release ADC1 from reset state *)
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_ADC1, Disabled);
         end;

      ptruint(@ADC2):
         begin
            (* Enable ADC2 reset state *)
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_ADC2, Enabled);
            (* Release ADC2 from reset state *)
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_ADC2, Disabled);
         end;

     {ptruint(@ADC3):
         begin
            (* Enable ADC3 reset state *)
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_ADC3, Enabled);
            (* Release ADC3 from reset state *)
            RCC_APB2PeriphResetCmd(RCC_APB2Periph_ADC3, Disabled);
         end;}
   end;
end;

procedure ADC_Init(var ADCx: TADCRegisters; const ADC_InitStruct: TADC_InitTypeDef);
var tmpreg1,tmpreg2: longword;
begin
   (*---------------------------- ADCx CR1 Configuration -----------------*)
   (* Get the ADCx CR1 value *)
   tmpreg1 := ADCx.CR1;
   (* Clear DUALMOD and SCAN bits *)
   tmpreg1 := tmpreg1 and ADC_CR1_CLEAR_Mask;
   (* Configure ADCx: Dual mode and scan conversion mode *)
   (* Set DUALMOD bits according to ADC_Mode value *)
   (* Set SCAN bit according to ADC_ScanConvMode value *)
   tmpreg1 := tmpreg1 or (ADC_InitStruct.ADC_Mode or (ord(ADC_InitStruct.ADC_ScanConvMode) shl 8));
   (* Write to ADCx CR1 *)
   ADCx.CR1 := tmpreg1;

   (*---------------------------- ADCx CR2 Configuration -----------------*)
   (* Get the ADCx CR2 value *)
   tmpreg1 := ADCx.CR2;
   (* Clear CONT, ALIGN and EXTSEL bits *)
   tmpreg1 := tmpreg1 and ADC_CR2_CLEAR_Mask;
   (* Configure ADCx: external trigger event and continuous conversion mode *)
   (* Set ALIGN bit according to ADC_DataAlign value *)
   (* Set EXTSEL bits according to ADC_ExternalTrigConv value *)
   (* Set CONT bit according to ADC_ContinuousConvMode value *)
   tmpreg1 := tmpreg1 or (ADC_InitStruct.ADC_DataAlign or ADC_InitStruct.ADC_ExternalTrigConv or (ord(ADC_InitStruct.ADC_ContinuousConvMode) shl 1));
   (* Write to ADCx CR2 *)
   ADCx.CR2 := tmpreg1;

   (*---------------------------- ADCx SQR1 Configuration -----------------*)
   (* Get the ADCx SQR1 value *)
   tmpreg1 := ADCx.SQR1;
   (* Clear L bits *)
   tmpreg1 := tmpreg1 and SQR1_CLEAR_Mask;
   (* Configure ADCx: regular channel sequence length *)
   (* Set L bits according to ADC_NbrOfChannel value *)
   tmpreg2 := ADC_InitStruct.ADC_NbrOfChannel - 1;
   tmpreg1 := tmpreg1 or (tmpreg2 shl 20);
   (* Write to ADCx SQR1 *)
   ADCx.SQR1 := tmpreg1;
end;

procedure ADC_StructInit(out ADC_InitStruct: TADC_InitTypeDef);
begin
   (* Reset ADC init structure parameters values *)
   (* Initialize the ADC_Mode member *)
   ADC_InitStruct.ADC_Mode := ADC_Mode_Independent;

   (* initialize the ADC_ScanConvMode member *)
   ADC_InitStruct.ADC_ScanConvMode := Disabled;

   (* Initialize the ADC_ContinuousConvMode member *)
   ADC_InitStruct.ADC_ContinuousConvMode := Disabled;

   (* Initialize the ADC_ExternalTrigConv member *)
   ADC_InitStruct.ADC_ExternalTrigConv := ADC_ExternalTrigConv_T1_CC1;

   (* Initialize the ADC_DataAlign member *)
   ADC_InitStruct.ADC_DataAlign := ADC_DataAlign_Right;

   (* Initialize the ADC_NbrOfChannel member *)
   ADC_InitStruct.ADC_NbrOfChannel := 1;
end;

procedure ADC_Cmd(var ADCx: TADCRegisters; NewState: TState);
begin
   if NewState <> Disabled then
   begin
      (* Set the ADON bit to wake up the ADC from power down mode *)
      ADCx.CR2 := ADCx.CR2 or CR2_ADON_Set;
   end
   else
   begin
      (* Disable the selected ADC peripheral *)
      ADCx.CR2 := ADCx.CR2 and CR2_ADON_Reset;
   end;
end;

procedure ADC_DMACmd(var ADCx: TADCRegisters; NewState: TState);
begin
   if NewState <> Disabled then
   begin
      (* Enable the selected ADC DMA request *)
      ADCx.CR2 := ADCx.CR2 or CR2_DMA_Set;
   end
   else
   begin
      (* Disable the selected ADC DMA request *)
      ADCx.CR2 := ADCx.CR2 and CR2_DMA_Reset;
   end;
end;

procedure ADC_ITConfig(var ADCx: TADCRegisters; ADC_IT: word; NewState: TState);
var itmask: Word;
begin
   (* Get the ADC IT index *)
   itmask := ADC_IT;

   if NewState <> Disabled then
   begin
      (* Enable the selected ADC interrupts *)
      ADCx.CR1 := ADCx.CR1 or itmask;
   end
   else
   begin
      (* Disable the selected ADC interrupts *)
      ADCx.CR1 := ADCx.CR1 and (not itmask);
   end;
end;

procedure ADC_ResetCalibration(var ADCx: TADCRegisters);
begin
   (* Resets the selected ADC calibartion registers *)
   ADCx.CR2 := ADCx.CR2 or CR2_RSTCAL_Set;
end;

function ADC_GetResetCalibrationStatus(var ADCx: TADCRegisters): boolean;
begin
   result := (ADCx.CR2 and CR2_RSTCAL_Set) <> 0;
end;

procedure ADC_StartCalibration(var ADCx: TADCRegisters);
begin
   (* Enable the selected ADC calibration process *)
   ADCx.CR2 := ADCx.CR2 or CR2_CAL_Set;
end;

function ADC_GetCalibrationStatus(var ADCx: TADCRegisters): boolean;
begin
   result := (ADCx.CR2 and CR2_CAL_Set) <> 0;
end;

procedure ADC_SoftwareStartConvCmd(var ADCx: TADCRegisters; NewState: TState);
begin
   if NewState <> Disabled then
   begin
      (* Enable the selected ADC conversion on external event and start the selected
       ADC conversion *)
      ADCx.CR2 := ADCx.CR2 or CR2_EXTTRIG_SWSTART_Set;
   end
   else
   begin
      (* Disable the selected ADC conversion on external event and stop the selected
       ADC conversion *)
      ADCx.CR2 := ADCx.CR2 and CR2_EXTTRIG_SWSTART_Reset;
   end;
end;

function ADC_GetSoftwareStartConvStatus(var ADCx: TADCRegisters): boolean;
begin
   result := (ADCx.CR2 and CR2_SWSTART_Set) <> 0;
end;

procedure ADC_DiscModeChannelCountConfig(var ADCx: TADCRegisters; Number: byte);
var tmpreg1,tmpreg2: longword;
begin
   (* Get the old register value *)
   tmpreg1 := ADCx.CR1;
   (* Clear the old discontinuous mode channel count *)
   tmpreg1 := tmpreg1 and CR1_DISCNUM_Reset;
   (* Set the discontinuous mode channel count *)
   tmpreg2 := Number - 1;
   tmpreg1 := tmpreg1 or tmpreg2 shl 13;
   (* Store the new register value *)
   ADCx.CR1 := tmpreg1;
end;

procedure ADC_DiscModeCmd(var ADCx: TADCRegisters; NewState: TState);
begin
   if NewState <> Disabled then
   begin
      (* Enable the selected ADC regular discontinuous mode *)
      ADCx.CR1 := ADCx.CR1 or CR1_DISCEN_Set;
   end
   else
   begin
      (* Disable the selected ADC regular discontinuous mode *)
      ADCx.CR1 := ADCx.CR1 and CR1_DISCEN_Reset;
   end;
end;

procedure ADC_RegularChannelConfig(var ADCx: TADCRegisters; ADC_Channel, Rank, ADC_SampleTime: byte);
var tmpreg1,tmpreg2: longword;
begin
   (* if ADC_Channel_10 ... ADC_Channel_17 is selected *)
   if (ADC_Channel > ADC_Channel_9) then
   begin
      (* Get the old register value *)
      tmpreg1 := ADCx.SMPR1;
      (* Calculate the mask to clear *)
      tmpreg2 := SMPR1_SMP_Set shl (3 * (ADC_Channel - 10));
      (* Clear the old discontinuous mode channel count *)
      tmpreg1 := tmpreg1 and (not tmpreg2);
      (* Calculate the mask to set *)
      tmpreg2 := ADC_SampleTime shl (3 * (ADC_Channel - 10));
      (* Set the discontinuous mode channel count *)
      tmpreg1 := tmpreg1 or tmpreg2;
      (* Store the new register value *)
      ADCx.SMPR1 := tmpreg1;
   end
   else (* ADC_Channel include in ADC_Channel_[0..9] *)
   begin
      (* Get the old register value *)
      tmpreg1 := ADCx.SMPR2;
      (* Calculate the mask to clear *)
      tmpreg2 := SMPR2_SMP_Set shl (3 * ADC_Channel);
      (* Clear the old discontinuous mode channel count *)
      tmpreg1 := tmpreg1 and (not tmpreg2);
      (* Calculate the mask to set *)
      tmpreg2 := ADC_SampleTime shl (3 * ADC_Channel);
      (* Set the discontinuous mode channel count *)
      tmpreg1 := tmpreg1 or tmpreg2;
      (* Store the new register value *)
      ADCx.SMPR2 := tmpreg1;
   end;
   (* For Rank 1 to 6 *)
   if (Rank < 7) then
   begin
      (* Get the old register value *)
      tmpreg1 := ADCx.SQR3;
      (* Calculate the mask to clear *)
      tmpreg2 := SQR3_SQ_Set shl (5 * (Rank - 1));
      (* Clear the old SQx bits for the selected rank *)
      tmpreg1 := tmpreg1 and (not tmpreg2);
      (* Calculate the mask to set *)
      tmpreg2 := ADC_Channel shl (5 * (Rank - 1));
      (* Set the SQx bits for the selected rank *)
      tmpreg1 := tmpreg1 or tmpreg2;
      (* Store the new register value *)
      ADCx.SQR3 := tmpreg1;
   end
   (* For Rank 7 to 12 *)
   else if (Rank < 13) then
   begin
      (* Get the old register value *)
      tmpreg1 := ADCx.SQR2;
      (* Calculate the mask to clear *)
      tmpreg2 := SQR2_SQ_Set shl (5 * (Rank - 7));
      (* Clear the old SQx bits for the selected rank *)
      tmpreg1 := tmpreg1 and (not tmpreg2);
      (* Calculate the mask to set *)
      tmpreg2 := ADC_Channel shl (5 * (Rank - 7));
      (* Set the SQx bits for the selected rank *)
      tmpreg1 := tmpreg1 or tmpreg2;
      (* Store the new register value *)
      ADCx.SQR2 := tmpreg1;
   end
   (* For Rank 13 to 16 *)
   else
   begin
      (* Get the old register value *)
      tmpreg1 := ADCx.SQR1;
      (* Calculate the mask to clear *)
      tmpreg2 := SQR1_SQ_Set shl (5 * (Rank - 13));
      (* Clear the old SQx bits for the selected rank *)
      tmpreg1 := tmpreg1 and (not tmpreg2);
      (* Calculate the mask to set *)
      tmpreg2 := ADC_Channel shl (5 * (Rank - 13));
      (* Set the SQx bits for the selected rank *)
      tmpreg1 := tmpreg1 or tmpreg2;
      (* Store the new register value *)
      ADCx.SQR1 := tmpreg1;
   end;
end;

procedure ADC_ExternalTrigConvCmd(var ADCx: TADCRegisters; NewState: TState);
begin
   if (NewState <> Disabled) then
   begin
      (* Enable the selected ADC conversion on external event *)
      ADCx.CR2 := ADCx.CR2 or CR2_EXTTRIG_Set;
   end
   else
   begin
      (* Disable the selected ADC conversion on external event *)
      ADCx.CR2 := ADCx.CR2 and CR2_EXTTRIG_Reset;
   end;
end;

function ADC_GetConversionValue(var ADCx: TADCRegisters): word;
begin
   result := ADCx.DR;
end;

function ADC_GetDualModeConversionValue: longword;
begin
   result := plongword(DR_ADDRESS)^;
end;

procedure ADC_AutoInjectedConvCmd(var ADCx: TADCRegisters; NewState: TState);
begin
   if (NewState <> Disabled) then
   begin
      (* Enable the selected ADC automatic injected group conversion *)
      ADCx.CR1 := ADCx.CR1 or CR1_JAUTO_Set;
   end
   else
   begin
      (* Disable the selected ADC automatic injected group conversion *)
      ADCx.CR1 := ADCx.CR1 and CR1_JAUTO_Reset;
   end;
end;

procedure ADC_InjectedDiscModeCmd(var ADCx: TADCRegisters; NewState: TState);
begin
   if (NewState <> Disabled) then
   begin
      (* Enable the selected ADC injected discontinuous mode *)
      ADCx.CR1 := ADCx.CR1 or CR1_JDISCEN_Set;
   end
   else
   begin
      (* Disable the selected ADC injected discontinuous mode *)
      ADCx.CR1 := ADCx.CR1 and CR1_JDISCEN_Reset;
   end;
end;

procedure ADC_ExternalTrigInjectedConvConfig(var ADCx: TADCRegisters; ADC_ExternalTrigInjecConv: longword);
var tmpreg: longword;
begin
   (* Get the old register value *)
   tmpreg := ADCx.CR2;
   (* Clear the old external event selection for injected group *)
   tmpreg := tmpreg and CR2_JEXTSEL_Reset;
   (* Set the external event selection for injected group *)
   tmpreg := tmpreg or ADC_ExternalTrigInjecConv;
   (* Store the new register value *)
   ADCx.CR2 := tmpreg;
end;

procedure ADC_ExternalTrigInjectedConvCmd(var ADCx: TADCRegisters; NewState: TState);
begin
   if (NewState <> Disabled) then
   begin
      (* Enable the selected ADC external event selection for injected group *)
      ADCx.CR2 := ADCx.CR2 or CR2_JEXTTRIG_Set;
   end
   else
   begin
      (* Disable the selected ADC external event selection for injected group *)
      ADCx.CR2 := ADCx.CR2 and CR2_JEXTTRIG_Reset;
   end;
end;

procedure ADC_SoftwareStartInjectedConvCmd(var ADCx: TADCRegisters; NewState: TState);
begin
   if (NewState <> Disabled) then
   begin
      (* Enable the selected ADC conversion for injected group on external event and start the selected
       ADC injected conversion *)
      ADCx.CR2 := ADCx.CR2 or CR2_JEXTTRIG_JSWSTART_Set;
   end
   else
   begin
      (* Disable the selected ADC conversion on external event for injected group and stop the selected
       ADC injected conversion *)
      ADCx.CR2 := ADCx.CR2 and CR2_JEXTTRIG_JSWSTART_Reset;
   end;
end;

function ADC_GetSoftwareStartInjectedConvCmdStatus(var ADCx: TADCRegisters): boolean;
begin
   result := (ADCx.CR2 and CR2_JSWSTART_Set) <> 0;
end;

procedure ADC_InjectedChannelConfig(var ADCx: TADCRegisters; ADC_Channel, Rank, ADC_SampleTime: byte);
var tmpreg1,tmpreg2,tmpreg3: longword;
begin
   (* if ADC_Channel_10 ... ADC_Channel_17 is selected *)
   if (ADC_Channel > ADC_Channel_9) then
   begin
      (* Get the old register value *)
      tmpreg1 := ADCx.SMPR1;
      (* Calculate the mask to clear *)
      tmpreg2 := SMPR1_SMP_Set shl (3*(ADC_Channel - 10));
      (* Clear the old discontinuous mode channel count *)
      tmpreg1 := tmpreg1 and (not tmpreg2);
      (* Calculate the mask to set *)
      tmpreg2 := ADC_SampleTime shl (3*(ADC_Channel - 10));
      (* Set the discontinuous mode channel count *)
      tmpreg1 := tmpreg1 or tmpreg2;
      (* Store the new register value *)
      ADCx.SMPR1 := tmpreg1;
   end
   else (* ADC_Channel include in ADC_Channel_[0..9] *)
   begin
      (* Get the old register value *)
      tmpreg1 := ADCx.SMPR2;
      (* Calculate the mask to clear *)
      tmpreg2 := SMPR2_SMP_Set shl (3 * ADC_Channel);
      (* Clear the old discontinuous mode channel count *)
      tmpreg1 := tmpreg1 and (not tmpreg2);
      (* Calculate the mask to set *)
      tmpreg2 := ADC_SampleTime shl (3 * ADC_Channel);
      (* Set the discontinuous mode channel count *)
      tmpreg1 := tmpreg1 or tmpreg2;
      (* Store the new register value *)
      ADCx.SMPR2 := tmpreg1;
   end;

   (* Rank configuration *)
   (* Get the old register value *)
   tmpreg1 := ADCx.JSQR;
   (* Get JL value: Number = JL+1 *)
   tmpreg3 := (tmpreg1 and JSQR_JL_Set) shr 20;
   (* Calculate the mask to clear: ((Rank-1)+(4-JL-1)) *)
   tmpreg2 := JSQR_JSQ_Set shl (5 * ((Rank + 3) - (tmpreg3 + 1)));
   (* Clear the old JSQx bits for the selected rank *)
   tmpreg1 := tmpreg1 and (not tmpreg2);
   (* Calculate the mask to set: ((Rank-1)+(4-JL-1)) *)
   tmpreg2 := ADC_Channel shl (5 * ((Rank + 3) - (tmpreg3 + 1)));
   (* Set the JSQx bits for the selected rank *)
   tmpreg1 := tmpreg1 or tmpreg2;
   (* Store the new register value *)
   ADCx.JSQR := tmpreg1;
end;

procedure ADC_InjectedSequencerLengthConfig(var ADCx: TADCRegisters; Length: byte);
var tmpreg1,tmpreg2: longword;
begin
   (* Get the old register value *)
   tmpreg1 := ADCx.JSQR;
   (* Clear the old injected sequnence lenght JL bits *)
   tmpreg1 := tmpreg1 and JSQR_JL_Reset;
   (* Set the injected sequnence lenght JL bits *)
   tmpreg2 := Length - 1;
   tmpreg1 := tmpreg1 or (tmpreg2 shl 20);
   (* Store the new register value *)
   ADCx.JSQR := tmpreg1;
end;

procedure ADC_SetInjectedOffset(var ADCx: TADCRegisters; ADC_InjectedChannel: byte; Offset: word);
begin
   plongword(@ADCx)[ADC_InjectedChannel] := Offset;
end;

function ADC_GetInjectedConversionValue(var ADCx: TADCRegisters; ADC_InjectedChannel: byte): word;
begin
   result := plongword(@ADCx)[ADC_InjectedChannel+JDR_Offset];
end;

procedure ADC_AnalogWatchdogCmd(var ADCx: TADCRegisters; ADC_AnalogWatchdog: longword);
var tmpreg: longword;
begin
   (* Get the old register value *)
   tmpreg := ADCx.CR1;
   (* Clear AWDEN, AWDENJ and AWDSGL bits *)
   tmpreg := tmpreg and CR1_AWDMode_Reset;
   (* Set the analog watchdog enable mode *)
   tmpreg := tmpreg or ADC_AnalogWatchdog;
   (* Store the new register value *)
   ADCx.CR1 := tmpreg;
end;

procedure ADC_AnalogWatchdogThresholdsConfig(var ADCx: TADCRegisters; HighThreshold, LowThreshold: word);
begin
   (* Set the ADCx high threshold *)
   ADCx.HTR := HighThreshold;
   (* Set the ADCx low threshold *)
   ADCx.LTR := LowThreshold;
end;

procedure ADC_AnalogWatchdogSingleChannelConfig(var ADCx: TADCRegisters; ADC_Channel: byte);
var tmpreg: longword;
begin
   (* Get the old register value *)
   tmpreg := ADCx.CR1;
   (* Clear the Analog watchdog channel select bits *)
   tmpreg := tmpreg and CR1_AWDCH_Reset;
   (* Set the Analog watchdog channel *)
   tmpreg := tmpreg or ADC_Channel;
   (* Store the new register value *)
   ADCx.CR1 := tmpreg;
end;

procedure ADC_TempSensorVrefintCmd(NewState: TState);
begin
   if (NewState <> Disabled) then
   begin
      (* Enable the temperature sensor and Vrefint channel*)
      ADC1.CR2 := ADC1.CR2 or CR2_TSVREFE_Set;
   end
   else
   begin
      (* Disable the temperature sensor and Vrefint channel*)
      ADC1.CR2 := ADC1.CR2 and CR2_TSVREFE_Reset;
   end;
end;

function ADC_GetFlagStatus(var ADCx: TADCRegisters; ADC_FLAG: byte): boolean;
begin
   result := (ADCx.SR and ADC_FLAG) <> 0;
end;

procedure ADC_ClearFlag(var ADCx: TADCRegisters; ADC_FLAG: byte);
begin
   (* Clear the selected ADC flags *)
   ADCx.SR := not longword(ADC_FLAG);
end;

function ADC_GetITStatus(var ADCx: TADCRegisters; ADC_IT: word): boolean;
var itmask,enablestatus: longword;
begin
   (* Get the ADC IT index *)
   itmask := ADC_IT shr 8;

   (* Get the ADC_IT enable bit status *)
   enablestatus := ADCx.CR1 and ADC_IT;

   result := ((ADCx.SR and itmask) <> 0) and (enablestatus <> 0);
end;

procedure ADC_ClearITPendingBit(var ADCx: TADCRegisters; ADC_IT: word);
var itmask: longword;
begin
   (* Get the ADC IT index *)
   itmask := (ADC_IT shr 8);

   (* Clear the selected ADC interrupt pending bits *)
   ADCx.SR := not itmask;
end;

{ DMA }

const
  CCR_ENABLE_Set = $00000001;
  CCR_ENABLE_Reset = $FFFFFFFE;
  (* DMA1 Channelx interrupt pending bit masks  *)

  DMA1_Channel1_IT_Mask = $0000000F;
  DMA1_Channel2_IT_Mask = $000000F0;
  DMA1_Channel3_IT_Mask = $00000F00;
  DMA1_Channel4_IT_Mask = $0000F000;
  DMA1_Channel5_IT_Mask = $000F0000;
  DMA1_Channel6_IT_Mask = $00F00000;
  DMA1_Channel7_IT_Mask = $0F000000;
  (* DMA2 Channelx interrupt pending bit masks  *)

  DMA2_Channel1_IT_Mask = $0000000F;
  DMA2_Channel2_IT_Mask = $000000F0;
  DMA2_Channel3_IT_Mask = $00000F00;
  DMA2_Channel4_IT_Mask = $0000F000;
  DMA2_Channel5_IT_Mask = $000F0000;
  (* DMA2 FLAG mask  *)

  FLAG_Mask = $10000000;
  (* DMA registers Masks  *)

  CCR_CLEAR_Mask = $FFFF800F;

procedure DMA_DeInit(var DMAy_Channelx: TDMAChannel);

begin
   DMAy_Channelx.CCR:= DMAy_Channelx.CCR and (not(CCR_ENABLE_SET));
   DMAy_Channelx.CCR:=0;
   DMAy_Channelx.CNDTR:=0;
   DMAy_Channelx.CPAR:=0;
   DMAy_Channelx.CMAR:=0;
   if @DMAy_Channelx = @DMA1.Channel[0] then
      DMA1.IFCR := DMA1.IFCR or DMA1_Channel1_IT_Mask
   else if @DMAy_Channelx = @DMA1.Channel[1] then
      DMA1.IFCR := DMA1.IFCR or DMA1_Channel2_IT_Mask
   else if @DMAy_Channelx = @DMA1.Channel[2] then
      DMA1.IFCR := DMA1.IFCR or DMA1_Channel3_IT_Mask
   else if @DMAy_Channelx = @DMA1.Channel[3] then
      DMA1.IFCR := DMA1.IFCR or DMA1_Channel4_IT_Mask
   else if @DMAy_Channelx = @DMA1.Channel[4] then
      DMA1.IFCR := DMA1.IFCR or DMA1_Channel5_IT_Mask
   else if @DMAy_Channelx = @DMA1.Channel[5] then
      DMA1.IFCR := DMA1.IFCR or DMA1_Channel6_IT_Mask
   else if @DMAy_Channelx = @DMA1.Channel[6] then
      DMA1.IFCR := DMA1.IFCR or DMA1_Channel7_IT_Mask
   else if @DMAy_Channelx = @DMA2.Channel[0] then
      DMA2.IFCR := DMA2.IFCR or DMA2_Channel1_IT_Mask
   else if @DMAy_Channelx = @DMA2.Channel[1] then
      DMA2.IFCR := DMA2.IFCR or DMA2_Channel2_IT_Mask
   else if @DMAy_Channelx = @DMA2.Channel[2] then
      DMA2.IFCR := DMA2.IFCR or DMA2_Channel3_IT_Mask
   else if @DMAy_Channelx = @DMA2.Channel[3] then
      DMA2.IFCR := DMA2.IFCR or DMA2_Channel4_IT_Mask
   else if @DMAy_Channelx = @DMA2.Channel[4] then
      DMA2.IFCR := DMA2.IFCR or DMA2_Channel5_IT_Mask
end;

procedure DMA_Init(var DMAy_Channelx: TDMAChannel; const DMA_InitStruct: TDMA_InitTypeDef);
var tmpreg: longword;
begin
   tmpreg := DMAy_Channelx.CCR;
   tmpreg := tmpreg and CCR_CLEAR_Mask;

   tmpreg := tmpreg or DMA_InitStruct.DMA_DIR or DMA_InitStruct.DMA_Mode or
                       DMA_InitStruct.DMA_PeripheralInc or DMA_InitStruct.DMA_MemoryInc or
                       DMA_InitStruct.DMA_PeripheralDataSize or DMA_InitStruct.DMA_MemoryDataSize or
                       DMA_InitStruct.DMA_Priority or DMA_InitStruct.DMA_M2M;

   DMAy_Channelx.CCR := tmpreg;

   DMAy_Channelx.CNDTR := DMA_InitStruct.DMA_BufferSize;
   DMAy_Channelx.CPAR := ptruint(DMA_InitStruct.DMA_PeripheralBaseAddr);
   DMAy_Channelx.CMAR := ptruint(DMA_InitStruct.DMA_MemoryBaseAddr);
end;

procedure DMA_StructInit(out DMA_InitStruct: TDMA_InitTypeDef);
begin
   DMA_InitStruct.DMA_PeripheralBaseAddr := nil;
   DMA_InitStruct.DMA_MemoryBaseAddr := nil;
   DMA_InitStruct.DMA_DIR := DMA_DIR_PeripheralSRC;
   DMA_InitStruct.DMA_BufferSize := 0;
   DMA_InitStruct.DMA_PeripheralInc := DMA_PeripheralInc_Disable;
   DMA_InitStruct.DMA_MemoryInc := DMA_MemoryInc_Disable;
   DMA_InitStruct.DMA_PeripheralDataSize := DMA_PeripheralDataSize_Byte;
   DMA_InitStruct.DMA_MemoryDataSize := DMA_MemoryDataSize_Byte;
   DMA_InitStruct.DMA_Mode := DMA_Mode_Normal;
   DMA_InitStruct.DMA_Priority := DMA_Priority_Low;
   DMA_InitStruct.DMA_M2M := DMA_M2M_Disable;
end;

procedure DMA_Cmd(var DMAy_Channelx: TDMAChannel; NewState: TState);
begin
   if NewState = Enabled then
      DMAy_Channelx.CCR := DMAy_Channelx.CCR or CCR_ENABLE_Set
   else
      DMAy_Channelx.CCR := DMAy_Channelx.CCR and CCR_ENABLE_Reset;
end;

procedure DMA_ITConfig(var DMAy_Channelx: TDMAChannel; DMA_IT: longword; NewState: TState);
begin
   if NewState = Enabled then
      DMAy_Channelx.CCR := DMAy_Channelx.CCR or DMA_IT
   else
      DMAy_Channelx.CCR := DMAy_Channelx.CCR and not(DMA_IT);
end;

function DMA_GetCurrDataCounter(var DMAy_Channelx: TDMAChannel): word;
begin
   result := DMAy_Channelx.CNDTR;
end;

function DMA_GetFlagStatus(DMA_FLAG: longword): boolean;
var tmpreg: longword;
begin
   if (DMA_FLAG and FLAG_Mask) <> 0 then
      tmpreg := DMA2.ISR
   else
      tmpreg := DMA1.ISR;

   result := (tmpreg and DMA_FLAG) <> 0;
end;

procedure DMA_ClearFlag(DMA_FLAG: longword);
begin
   if (DMA_FLAG and FLAG_Mask) <> 0 then
      DMA2.IFCR := DMA_FLAG
   else
      DMA1.IFCR := DMA_FLAG;
end;

function DMA_GetITStatus(DMA_IT: longword): boolean;
var tmpreg: longword;
begin
   if (DMA_IT and FLAG_Mask) <> 0 then
      tmpreg := DMA2.ISR
   else
      tmpreg := DMA1.ISR;

   result := (tmpreg and DMA_IT) <> 0;
end;

procedure DMA_ClearITPendingBit(DMA_IT: longword);
begin
   if (DMA_IT and FLAG_Mask) <> 0 then
      DMA2.IFCR := DMA_IT
   else
      DMA1.IFCR := DMA_IT;
end;

{ EXTI }

procedure EXTI_DeInit;
begin
   EXTI.IMR:= $00000000;
   EXTI.EMR:= $00000000;
   EXTI.RTSR:= $00000000;
   EXTI.FTSR:= $00000000;
   EXTI.PR:= $000FFFFF;
end;

procedure EXTI_Init(var EXTI_InitStruct: TEXTI_InitTypeDef);
var
   tmp: ^longword;
begin
   tmp:= @EXTI.IMR;

   if EXTI_InitStruct.EXTI_LineCMD <> Disabled then begin
     (* Clear EXTI line configuration *)
     EXTI.IMR:= EXTI.IMR and (not EXTI_InitStruct.EXTI_Line);
     EXTI.EMR:= EXTI.EMR and (not EXTI_InitStruct.EXTI_Line);

     inc(tmp, longword(EXTI_InitStruct.EXTI_Mode) shr 2);
     tmp^:= tmp^ or EXTI_InitStruct.EXTI_Line;

     (* Clear Rising Falling edge configuration *)
     EXTI.RTSR:= EXTI.RTSR and (not EXTI_InitStruct.EXTI_Line);
     EXTI.FTSR:= EXTI.FTSR and (not EXTI_InitStruct.EXTI_Line);

     (* Select the trigger for the selected external interrupts *)
     if (EXTI_InitStruct.EXTI_Trigger = EXTI_Trigger_Rising_Falling) then begin
       (* Rising Falling edge *)
       EXTI.RTSR:= EXTI.RTSR or EXTI_InitStruct.EXTI_Line;
       EXTI.FTSR:= EXTI.FTSR or EXTI_InitStruct.EXTI_Line;
     end else begin
       tmp:= @EXTI.IMR;
       inc(tmp, longword(EXTI_InitStruct.EXTI_Trigger) shr 2);
       tmp^:= tmp^ or EXTI_InitStruct.EXTI_Line;
     end;
   end else begin
     inc(tmp, longword(EXTI_InitStruct.EXTI_Mode) shr 2);

     (* Disable the selected external lines *)
     tmp^:= tmp^ and (not EXTI_InitStruct.EXTI_Line);
   end;
end;

procedure EXTI_StructInit(var EXTI_InitStruct: TEXTI_InitTypeDef);
begin
   EXTI_InitStruct.EXTI_Line:= $00000000;
   EXTI_InitStruct.EXTI_Mode:= EXTI_Mode_Interrupt;
   EXTI_InitStruct.EXTI_Trigger:= EXTI_Trigger_Falling;
   EXTI_InitStruct.EXTI_LineCmd:= Disabled;
end;

procedure EXTI_GenerateSWInterrupt(EXTI_Line: longword);
begin
   EXTI.SWIER:= EXTI.SWIER or EXTI_Line;
end;

function  EXTI_GetFlagStatus(EXTI_Line: longword): boolean;
begin
   result := (EXTI.PR and EXTI_Line) <> 0;
end;

procedure EXTI_ClearFlag(EXTI_Line: longword);
begin
   EXTI.PR:= EXTI_Line;
end;

function  EXTI_GetITStatus(EXTI_Line: longword): boolean; Inline;
var
   enablestatus: longword;
begin
   enablestatus:= EXTI.IMR and EXTI_Line;
   result:= ((EXTI.PR and EXTI_Line) <> 0) and (enablestatus <> 0);
end;

procedure EXTI_ClearITPendingBit(EXTI_Line: longword); Inline;
begin
   EXTI.PR:= EXTI_Line;
end;

{ DAC }

procedure DAC_DeInit;
begin
  (* Enable DAC reset state *)
  RCC_APB1PeriphResetCmd(RCC_APB1Periph_DAC, Enabled);
  (* Release DAC from reset state *)
  RCC_APB1PeriphResetCmd(RCC_APB1Periph_DAC, Disabled);
end;

procedure DAC_Init(DAC_Channel: longword; var DAC_InitStruct: TDAC_InitTypeDef);
const
   CR_CLEAR_MASK = $00000FFE;
var
   tmpreg1, tmpreg2: longword;
begin
   tmpreg1:= 0;
   tmpreg2:= 0;
   (* Get the DAC CR value *)
   tmpreg1:= DAC.CR;
   (* Clear BOFFx, TENx, TSELx, WAVEx and MAMPx bits *)
   tmpreg1:= tmpreg1 and (not (CR_CLEAR_MASK shl DAC_Channel));
   (* Configure for the selected DAC channel: buffer output, trigger, wave generation,
     mask/amplitude for wave generation *)
   (* Set TSELx and TENx bits according to DAC_Trigger value *)
   (* Set WAVEx bits according to DAC_WaveGeneration value *)
   (* Set MAMPx bits according to DAC_LFSRUnmask_TriangleAmplitude value *)
   (* Set BOFFx bit according to DAC_OutputBuffer value *)
    tmpreg2:= (DAC_InitStruct.DAC_Trigger or DAC_InitStruct.DAC_WaveGeneration or
               DAC_InitStruct.DAC_LFSRUnmask_TriangleAmplitude or DAC_InitStruct.DAC_OutputBuffer);
   (* Calculate CR register value depending on DAC_Channel *)
   tmpreg1:= tmpreg1 or (tmpreg2 shl DAC_Channel);
   (* Write to DAC CR *)
   DAC.CR:= tmpreg1;
end;

procedure DAC_StructInit(var DAC_InitStruct: TDAC_InitTypeDef);
begin
   (* Initialize the DAC_Trigger member *)
   DAC_InitStruct.DAC_Trigger:= DAC_Trigger_None;
   (* Initialize the DAC_WaveGeneration member *)
   DAC_InitStruct.DAC_WaveGeneration:= DAC_WaveGeneration_None;
   (* Initialize the DAC_LFSRUnmask_TriangleAmplitude member *)
   DAC_InitStruct.DAC_LFSRUnmask_TriangleAmplitude:= DAC_LFSRUnmask_Bit0;
   (* Initialize the DAC_OutputBuffer member *)
   DAC_InitStruct.DAC_OutputBuffer:= DAC_OutputBuffer_Enable;
end;

procedure DAC_Cmd(DAC_Channel: longword; NewState: TState);
const
   DAC_CR_EN1 = $00000001;

begin
   if (NewState <> Disabled) then begin
      (* Enable the selected DAC channel *)
      DAC.CR:= DAC.CR or (DAC_CR_EN1 shl DAC_Channel);
   end else begin
      (* Disable the selected DAC channel *)
      DAC.CR:= DAC.CR and (not(DAC_CR_EN1 shl DAC_Channel));
   end;
end;

{$if defined(STM32F10X_LD_VL) or defined(STM32F10X_MD_VL) or defined (STM32F10X_HD_VL)}
   procedure DAC_ITConfig(DAC_Channel: longword; DAC_IT: longword; NewState: TState);
   begin
      if (NewState <> Disabled) then begin
         (* Enable the selected DAC interrupts *)
         DAC.CR:= DAC.CR or (DAC_IT shl DAC_Channel);
      end else begin
         (* Disable the selected DAC interrupts *)
         DAC.CR:= DAC.CR and (not longword(DAC_IT shl DAC_Channel));
      end;
   end;
{$endif}

procedure DAC_DMACmd(DAC_Channel: longword; NewState: TState);
const
   DAC_CR_DMAEN1 = $00001000;
begin
   if (NewState <> Disabled) then begin
      (* Enable the selected DAC channel DMA request *)
      DAC.CR:= DAC.CR or (DAC_CR_DMAEN1 shl DAC_Channel);
   end else begin
      (* Disable the selected DAC channel DMA request *)
      DAC.CR:= DAC.CR and (not(DAC_CR_DMAEN1 shl DAC_Channel));
   end;
end;

procedure DAC_SoftwareTriggerCmd(DAC_Channel: longword; NewState: TState);
const
   DAC_SWTRIGR_SWTRIG1 = Byte($01);
begin
   if (NewState <> Disabled) then begin
      (* Enable software trigger for the selected DAC channel *)
      DAC.SWTRIGR:= DAC.SWTRIGR or longword(DAC_SWTRIGR_SWTRIG1) shl (DAC_Channel shr 4);
   end else begin
      (* Disable software trigger for the selected DAC channel *)
      DAC.SWTRIGR:= DAC.SWTRIGR and (not (longword(DAC_SWTRIGR_SWTRIG1) shl (DAC_Channel shr 4)));
   end;
end;

procedure DAC_DualSoftwareTriggerCmd(NewState: TState);
const
   DUAL_SWTRIG_SET   = $00000003;
   DUAL_SWTRIG_RESET = $FFFFFFFC;
begin
   if (NewState <> Disabled) then begin
      (* Enable software trigger for both DAC channels *)
      DAC.SWTRIGR:= DAC.SWTRIGR or DUAL_SWTRIG_SET;
   end else begin
      (* Disable software trigger for both DAC channels *)
      DAC.SWTRIGR:= DAC.SWTRIGR and DUAL_SWTRIG_RESET;
   end;
end;

procedure DAC_WaveGenerationCmd(DAC_Channel: longword; DAC_Wave: longword; NewState: TState);
begin
   if (NewState <> Disabled) then begin
      (* Enable the selected wave generation for the selected DAC channel *)
      DAC.CR:= DAC.CR or (DAC_Wave shl DAC_Channel);
   end else begin
      (* Disable the selected wave generation for the selected DAC channel *)
      DAC.CR:= DAC.CR and (not (DAC_Wave shl DAC_Channel));
   end;
end;

procedure DAC_SetChannel1Data(DAC_Align: longword; Data: word);
(*
const
   DHR12R1_OFFSET = $00000008;
var
   tmp: Pointer;
*)
begin
   case DAC_Align of
      DAC_Align_12b_R: DAC.DHR12R1:= Data;
      DAC_Align_12b_L: DAC.DHR12L1:= Data;
      DAC_Align_8b_R: DAC.DHR8R1:= Data;
   end;
   (* this variant does not work.
   tmp:= @DAC;
   tmp:= tmp + DHR12R1_OFFSET + DAC_Align;
   { Set the DAC channel1 selected data holding register }
   word(tmp^):= Data;
   *)
end;

procedure DAC_SetChannel2Data(DAC_Align: longword; Data: word);
(*
const
   DHR12R2_OFFSET = $00000014;
var
   tmp: Pointer;
*)
begin
   case DAC_Align of
      DAC_Align_12b_R: DAC.DHR12R2:= Data;
      DAC_Align_12b_L: DAC.DHR12L2:= Data;
      DAC_Align_8b_R: DAC.DHR8R2:= Data;
   end;
   (* this variant does not work.
   tmp:= @DAC;
   tmp:= tmp + DHR12R2_OFFSET + DAC_Align;
   { Set the DAC channel2 selected data holding register }
   word(tmp^):= Data;
   *)
end;

procedure DAC_SetDualChannelData(DAC_Align: longword; Data2: word; Data1: word);
const
   DHR12RD_OFFSET = $00000020;
var
   data: longword;
   tmp: Pointer;
begin
   (* Calculate and set dual DAC data holding register value *)
   if (DAC_Align = DAC_Align_8b_R) then begin
      data:= (longword(Data2) shl 8) or Data1;
   end else begin
      data:= (longword(Data2) shl 16) or Data1;
   end;
   tmp:= @DAC;
   tmp:= tmp + DHR12RD_OFFSET + DAC_Align;
   (* Set the dual DAC selected data holding register *)
   longword(tmp^):= Data;
end;

function DAC_GetDataOutputValue(DAC_Channel: longword): word;
const
   DOR_OFFSET = $0000002C;
var
   tmp: Pointer;
begin
   tmp:= @DAC;
   tmp:= tmp + DOR_OFFSET + (DAC_Channel shr 2);
   (* Returns the DAC channel data output register value *)
   DAC_GetDataOutputValue:= word(tmp^);
end;

{$if defined(STM32F10X_LD_VL) or defined(STM32F10X_MD_VL) or defined (STM32F10X_HD_VL)}
   function  DAC_GetFlagStatus(DAC_Channel: longword; DAC_FLAG: longword): Boolean;
   begin
      (* Return the DAC_FLAG status *)
      result:= (DAC.SR and (DAC_FLAG shl DAC_Channel)) <> 0;
   end;

   procedure DAC_ClearFlag(DAC_Channel: longword; DAC_FLAG: longword);
   begin
      (* Clear the selected DAC flags *)
      DAC.SR:= (DAC_FLAG shl DAC_Channel);
   end;

   function  DAC_GetITStatus(DAC_Channel: longword; DAC_IT: longword): Boolean;
   var
      enablestatus: longword;
   begin
      (* Get the DAC_IT enable bit status *)
      enablestatus:= (DAC.CR and (DAC_IT shl DAC_Channel));
      (* Check the status of the specified DAC interrupt *)
      result:= (((DAC.SR and (DAC_IT shl DAC_Channel)) <> 0) and enablestatus);
   end;

   procedure DAC_ClearITPendingBit(DAC_Channel: longword; DAC_IT: longword);
   begin
      (* Clear the selected DAC interrupt pending bits *)
      DAC.SR:= (DAC_IT shl DAC_Channel);
   end;
{$endif}

end.

