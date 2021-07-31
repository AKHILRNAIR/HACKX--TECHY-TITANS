#define resolution 8
#define mains 50 



#define refresh 2 * 1000000 / mains



void setup() {
Serial.begin(9600);




for(int j = 2; j < 14; j++) {
pinMode(j, OUTPUT);
digitalWrite(j, LOW);
}



for(int j = 8; j < 11; j++)
pinMode(j, INPUT);



st();
}



void loop() {
Serial.print(time(8, B00000001), DEC);
Serial.print(" ");
Serial.print(time(9, B00000010), DEC);
Serial.print(" ");
Serial.println(time(10, B00000100), DEC);



}



long time(int pin, byte mask) {
unsigned long c = 0, t = 0;
while(ct() < refresh) {

pinMode(pin, OUTPUT);
PORTB = 0;
pinMode(pin, INPUT);
while((PINB & mask) == 0)
c++;
t++;
}
st();
return (c << resolution) / t;
}



extern volatile unsigned long timer0_overflow_count;



void st() {
timer0_overflow_count = 0;
TCNT0 = 0;
}



unsigned long ct() {
return ((timer0_overflow_count << 8) + TCNT0) << 2;
}
