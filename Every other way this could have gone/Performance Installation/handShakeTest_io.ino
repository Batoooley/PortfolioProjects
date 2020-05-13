/*
 * this code is the programme controlling the physical parts of the performance and communicating using
 * serial to the processing code.
 * Because it uses serial, arduino must listen and wait intermittently.
 * code refernced:
 * - the example code from the adafruit thermal printer library
 * - this guide: 
 * https://sspog.wordpress.com/code-examples/processing-to-arduino-strings-bigger-than-64-bytes/
*/
#include <Adafruit_Thermal.h>
#include "SoftwareSerial.h"
#define TX_PIN 11 // Arduino transmit    labeled RX on printer(blue)
#define RX_PIN 12 // Arduino receive     labeled TX on printer(green)

SoftwareSerial myPrinterSerial(RX_PIN, TX_PIN); // Declare SoftwareSerial obj first
Adafruit_Thermal printer(&myPrinterSerial);     // Pass addr to printer constructor


String val; // Data received from the serial port
int ledPin = 13; // Set the pin to digital I/O 13
boolean ledState = LOW; //to toggle our LED

const int loadPin = 4;
int loadState = 0;

const int permutePin = 7;
int permuteState = 0;

const int drawPin = 8;
int drawState = 0;

void setup() {
  pinMode(loadPin, INPUT);
  pinMode(permutePin, INPUT);
  pinMode(drawPin, INPUT);
  pinMode(ledPin, OUTPUT); // Set pin as OUTPUT

  myPrinterSerial.begin(9600);
  printer.begin();

  printer.justify('L');
  printer.setSize('S');
  printer.println(F("im on test"));
  //initialize serial communications at a 9600 baud rate
  Serial.begin(9600);
  establishContact();  // send a byte to establish contact until receiver responds

  printer.sleep();      // Tell printer to sleep
  delay(100);         // Sleep for 3 seconds
  printer.wake();
}

void loop() {
  loadState = digitalRead(loadPin);
  permuteState = digitalRead(permutePin);
  drawState = digitalRead(drawPin);
  
  if (Serial.available()) { // If data is available to read,

    val = Serial.readString(); // read it and store it in val

    printer.print(val);
    printer.feed(2);//17

    delay(100);
  }
  else {
//    Serial.println("I dont hear you"); //send back a hello world
    Serial.print(loadState);
    Serial.print(",");
    Serial.print(permuteState);
    Serial.print(",");
    Serial.print(drawState);
    Serial.print(",");
    Serial.println( "|" );
    delay(50);
  }

  if (loadState == HIGH) {
    digitalWrite(ledPin, HIGH);
    //    printer.print(F("load is high"));
//    Serial.println("load is high");
  } else {
    digitalWrite(ledPin, LOW);
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("A");   // send a capital A
    delay(300);
  }
}
