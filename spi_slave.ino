# include <SPI.h>
char str[50];
volatile byte i;
volatile bool pin;

void setup()
 {
  Serial.begin (9600);   // set baud rate to 115200 for usart
  Serial.println("Hello I'm SPI UNO_SLAVE");
  pinMode(MISO, OUTPUT); // have to send on Master in so it set as output
  SPCR |= _BV(SPE); // turn on SPI in slave mode
  i = 0; // buffer empty
  pin = false;
  SPI.attachInterrupt();     // turn on interrupt
}

void loop(){
  static int count;
  if (pin)
    {
    pin = false;   //reset the pin
    if(count++< 5){
    Serial.print(count);
    Serial.print(" : ");

   Serial.println(str); //print the array on serial monitor
   if(count==5)
     {
   delay(1000);
   Serial.println("The end data");
     }
    }
    delay(1000);
    i= 0; //reset button to zero
  }
  if(SS==1)
    Serial.println("connected");
}

// Interrupt function
ISR (SPI_STC_vect) 
{
 char c = SPDR;        // read byte from SPI Data Register
  if (i < sizeof(str)) {
    str [i++] = c; // save data in the next index in the array buff
    if ( (c == '\r') || (c == '\n') || (c=='\0') ) //check for the end of the word
      pin = true;
  }
}