unit main;

interface
uses
  stm32f103fw, interrupts;

procedure setup;
procedure loop;



implementation
//======================================================================

procedure setup;
begin
  //setup all initial stuff
  setup_interrupts;

end;

//==============================================================================
procedure loop;
begin
  // main loop

end;

end.

