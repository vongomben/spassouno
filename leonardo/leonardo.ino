// include the TinkerKit library
#include <TinkerKit.h>

TKButton button01(2);
TKButton button02(3);
TKButton button03(4);
TKButton button04(5);
TKButton button05(6);
TKButton button06(7);
TKButton button06(8);
TKButton button08(9);
TKButton button08(10);
TKButton button10(11);

void setup() {
  Keyboard.begin();
}

void loop()
{
  if (button01.pressed()) {
       Keyboard.press(' ');	
       delay(100);  
  } 
 
  if (button02.pressed()) {
       Keyboard.press('s');	
       delay(100);  
  } 

  if (button03.pressed()) {
       Keyboard.press('r');	
       delay(100);  
  } 

  if (button04.pressed()) {
       Keyboard.press('i');	
       delay(100);  
  } 

  if (button05.pressed()) {
       Keyboard.press('c');	
       delay(100);  
  } 

  if (button06.pressed()) {
       Keyboard.press('0');	
       delay(100);  
  } 

  if (button07.pressed()) {
       Keyboard.press('1');	
       delay(100);  
  }  /dev/video1 /dev/video1

  if (button08.pressed()) {
       Keyboard.press('2');	
       delay(100);  
  } 

  if (button09.pressed()) {
       Keyboard.press('3');	
       delay(100);  
  } 

  if (button10.pressed()) {
       Keyboard.press('4');	
       delay(100);  
  } 

  Keyboard.releaseAll();
}
