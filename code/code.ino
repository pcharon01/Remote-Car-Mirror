/*
 * Copyright (c) Patrick Charon
 * Licensed under 2-Clause BSD License <https://opensource.org/license/bsd-2-clause>
*/

#include <SoftwareSerial.h>
#include <Servo.h>

#define INSTRUCTION_MASK        0b11000000
#define VALUE_MASK              0b00111111

#define FORWARD         0b11000000
#define BACKWARD        0b10000000
#define STEERING        0b01000000
#define FUNCTIONS       0b00000000

#define LIGHTS_ON       0b00000001
#define LIGHTS_OFF      0b00000010
#define HEARTBEAT       0b00000011

#define PIN_EN          3
#define PIN_3A          4
#define PIN_4A          5
#define PIN_LIGHTS      10

#define STEERING_LOWER_BOUND    42
#define STEERING_UPPER_BOUND    138

#define STEERING_CORRECTION_AMPLITUDE   20

SoftwareSerial btserial(8, 9);
Servo steering_servo;

uint8_t steering;
int8_t compensation;

unsigned long int heartbeat_timer;

void setup() 
{
        btserial.begin(9600);
        Serial.begin(9600);

        pinMode(PIN_EN, OUTPUT);
        pinMode(PIN_3A, OUTPUT);
        pinMode(PIN_4A, OUTPUT);
        pinMode(PIN_LIGHTS, OUTPUT);

        pinMode(PIN_A0, INPUT);

        steering_servo.attach(11);

        steering = 90;
        compensation = 0;
}

void loop() 
{
        if (btserial.available()) {
                uint8_t input = btserial.read();
                uint8_t instruction = input & INSTRUCTION_MASK;
                uint8_t value = input & VALUE_MASK;

                switch (instruction) {
                case FUNCTIONS:
                        if (value == LIGHTS_ON)
                                digitalWrite(PIN_LIGHTS, HIGH);
                        else if (value == LIGHTS_OFF)
                                digitalWrite(PIN_LIGHTS, LOW);
                        else if (value == HEARTBEAT)
                                heartbeat_timer = 0;
                        break;

                case FORWARD:
                        digitalWrite(PIN_3A, HIGH);
                        digitalWrite(PIN_4A, LOW);
                        analogWrite(PIN_EN, map(value, 0, 63, 0, 255));
                        break;
                
                case BACKWARD:
                        digitalWrite(PIN_3A, LOW);
                        digitalWrite(PIN_4A, HIGH);
                        analogWrite(PIN_EN, map(value, 0, 63, 0, 255));
                        break;
                
                case STEERING:
                        steering = map(value, 0, 63,
                                        STEERING_LOWER_BOUND, 
                                        STEERING_UPPER_BOUND);
                        break;
                }

                btserial.write(0x02);
        }

        compensation = map(analogRead(PIN_A0), 0, 1023,
                                        STEERING_CORRECTION_AMPLITUDE,
                                        -STEERING_CORRECTION_AMPLITUDE);
        steering_servo.write(steering + compensation);

        heartbeat_timer += 10;
        delay(10);
        Serial.println(heartbeat_timer);

        if (heartbeat_timer > 2000) {
                digitalWrite(PIN_3A, LOW);
                digitalWrite(PIN_4A, HIGH);
                analogWrite(PIN_EN, 0);
                steering = 90;
        }
}
