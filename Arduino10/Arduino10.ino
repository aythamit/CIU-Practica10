int val = 0;
int sensorPin = 0;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(sensorPin,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  val = analogRead(0);
  analogWrite ( sensorPin , val ) ;
   Serial.println (val);
   delay(100);
}
