
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
  
  Serial.begin(9600);
  Serial.println("yo");
}

void loop() {

}

void RFduinoBLE_onReceive(char *data, int len){
  uint8_t myByte = data[0]; // store first char in array to myByte
Serial.println("hi");
  
  if (len > 4 && len < 12) {
    setColor(255, 0, 0); 
  }else{
    setColor(0, 0, 255); 
  }
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
