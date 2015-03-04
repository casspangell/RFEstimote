
#include <RFduinoBLE.h>

int redPin = 2;
int greenPin = 3;
int bluePin = 4;

void setup() {
  // put your setup code here, to run once:

  RFduinoBLE.begin();
  RFduinoBLE.deviceName = "RFduino"; //Sets the device name to RFduino
  
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT); 
}

void loop() {
  // put your main code here, to run repeatedly:

 /* setColor(255, 0, 0);  // red
  delay(1000);
  setColor(0, 255, 0);  // green
  delay(1000);
  setColor(0, 0, 255);  // blue
  delay(1000);
  setColor(255, 255, 0);  // yellow
  delay(1000);  
  setColor(80, 0, 80);  // purple
  delay(1000);
  setColor(0, 255, 255);  // aqua
  delay(1000);
  */
}

void setColor(int red, int green, int blue)
{
  #ifdef COMMON_ANODE
    red = 255 - red;
    green = 255 - green;
    blue = 255 - blue;
  #endif
  
  analogWrite(redPin, red);
  analogWrite(greenPin, green);
  analogWrite(bluePin, blue);  
}

void RFduinoBLE_onReceive(char *data, int len){
  uint8_t myByte = data[0]; // store first char in array to myByte
  uint8_t myByte2 = data[1];
  uint8_t myByte3 = data[2];
  setColor(myByte, myByte2, myByte3); 
}

void RFduinoBLE_onConnect()
{
  digitalWrite(redPin, LOW);
  digitalWrite(greenPin, HIGH);
  digitalWrite(bluePin, LOW);
}

void RFduinoBLE_onDisconnect()
{
  digitalWrite(redPin, LOW);
  digitalWrite(greenPin, LOW);
  digitalWrite(bluePin, LOW);
}
