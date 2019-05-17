void setup() {
        // Se establece la conexión serial
	Serial.begin(9600);
}
 
void loop(){
	if (Serial.available() > 0) {
		if (Serial.read() == 107) { 
                        // Se envia el caracter 445.45
			Serial.println(445.45);
		}
	}
}
