void setup() {
  // put your setup code here, to run once:
  
  pinMode(3,OUTPUT);
  pinMode(5,OUTPUT);
  pinMode(6,OUTPUT);
  Serial.begin(38400);
  Serial.println("Connecting and ready to recieve data...");
}

void loop() {
  // put your main code here, to run repeatedly:

  if(Serial.available() > 0) {
      int r;
      int g;
      int b;
      String s= Serial.readString();
      
      sscanf(s.c_str(), "%d,%d,%d", &r, &g, &b);
     
      analogWrite(5, r);
      analogWrite(6, g);
      analogWrite(3, b);
      delay(100);
  }
  
  analogWrite(5, 0);
  analogWrite(6, 0);
  analogWrite(3, 0);

  
}
