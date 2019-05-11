#include <Arduino.h>
#include <ESP8266TrueRandom.h>

//Number of uploaded audio files
#define AUDIOFILES 14

void setup(void)
	{
      pinMode(D8, OUTPUT);
      pinMode(D4, LED_BUILTIN);
      digitalWrite(D8, HIGH); //Keep PSU online
      digitalWrite(LED_BUILTIN, LOW); //LED "COM"
      pinMode(D3, INPUT_PULLUP);
      delay(500);
      Serial.begin(9600);
      Serial.println(F("BEGIN!"));

      Serial.println("Setting Volume to LVL 20");
      Serial.write(0xAA);
      Serial.write(0x13);
      Serial.write(0x01);
      Serial.write(0x14);
      Serial.write(0xD2);
      Serial.print("AA120113D2 -> ");
      while(Serial.available() > 0) {
        Serial.print(Serial.read(), 16);
        Serial.print("-");
      }
      Serial.println(" END");

      Serial.println("Checking number of files");
      Serial.write(0xAA);
      Serial.write(0x0C);
      Serial.write(0x00);
      Serial.write(0xB6);
      uint32_t answer = 0x00000000;
      while(Serial.available() > 0) {
        answer<<=2;
        answer &= Serial.read();
      }
      Serial.print("0xAA0C00B6 -> ");
      Serial.print(answer, 16);
      Serial.print("-");
      Serial.println(" END");

      //AA 0C 02 Number(hi) Number(Lw) SM
      answer &= 0x0000FFFF00;
      answer >>= 16;
      Serial.print("Found number of audio files: ");
      Serial.println(answer);
      answer = AUDIOFILES;

      /*Specify song (07)
      Command: AA 07 02 filename(Hi) filename(Lw) SM*/

      uint16_t song = 0;
      for(int i = 0; i<(ESP8266TrueRandom.random(25, 400)); i++) {
        song = ESP8266TrueRandom.random(1, (answer+1));
      }
      Serial.print("(Somewhat) random choice: ");
      Serial.println(song);


      Serial.println("Choosing Song");
      Serial.write(0xAA);
      Serial.write(0x07);
      Serial.write(0x02);
      Serial.write(0x00);
      Serial.write((uint8_t)song);
      Serial.write((0xAA+0x07+0x02+song));

      Serial.println("Starting Playback");
      Serial.write(0xAA);
      Serial.write(0x02);
      Serial.write(0x00);
      Serial.write(0xAC);
      Serial.print("AA0200AC -> ");
      while(Serial.available() > 0) {
        Serial.print(Serial.read(), 16);
        Serial.print("-");
      }
      Serial.println("PLAYING...");

      while(digitalRead(D3) == HIGH) {
        delay(10);
        yield();
      }

      Serial.println("Playback confirmed");

      while(digitalRead(D3) == LOW) {
        delay(10);
        yield();
      }
      Serial.println("PLAYBACK ENDED");

      Serial.flush();
      
      digitalWrite(LED_BUILTIN, HIGH); //LED "COM"
      digitalWrite(D8, LOW);  //Turn device off
      ESP.deepSleep(0);
	}
	
void loop(void)
	{
    digitalWrite(D8, LOW);
    yield();
    delay(10);
	}
