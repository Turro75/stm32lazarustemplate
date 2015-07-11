unit gpio;

{$mode objfpc}{$H+}

interface

uses
  stm32f103fw;

procedure setup_gpio;
procedure setup_gpio_portA;
procedure setup_gpio_portB;
procedure setup_gpio_portC;



implementation

procedure setup_gpio;
begin
       setup_gpio_portA;
    //   setup_gpio_portB;
    //   setup_gpio_portC;
end;

procedure setup_gpio_portA;
begin
     //enable clock on portA

     //set individual pins

end;

procedure setup_gpio_portB;
begin
     //enable clock on portB

     //set individual pins
end;

procedure setup_gpio_portC;
begin
     //enable clock on portC

     //set individual pins
end;

end.

