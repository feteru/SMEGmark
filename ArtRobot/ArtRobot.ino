String inputString = "";        
boolean stringComplete = false;  
int intensity, fastness;
int on = 0;
void setup() {
  Serial.begin(9600);
  inputString.reserve(20);
  pinMode(13,OUTPUT);

void loop() {
  if (stringComplete) {
    Serial.println(intensity + fastness);
    if((intensity+fastness)>50){
      if(on){
        on = 0;
        digitalWrite(13,LOW);
      } else {
        on = 1;
        digitalWrite(13,HIGH);
      } 
    }
    inputString = "";
    stringComplete = false;
  }
}

void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    if (inChar == '|'){
      intensity = inputString.toInt();
      inputString = "";
    }
    else if (inChar == '\n') {
      stringComplete = true;
      fastness = inputString.toInt();
    }
    else inputString += inChar;
  }
}
