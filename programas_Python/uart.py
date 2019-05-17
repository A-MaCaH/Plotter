import time
import serial
 
# Iniciando conexión serial
arduinoPort = serial.Serial('/dev/ttyACM1', 9600, timeout=1)
flagCharacter = 'k'
 
# Retardo para establecer la conexión serial
time.sleep(1.8) 
arduinoPort.write(flagCharacter)
getSerialValue = arduinoPort.readline()
#getSerialValue = arduinoPort.read()
#getSerialValue = arduinoPort.read(6)
print '\nValor retornado de Arduino: %s' % (getSerialValue)
 
# Cerrando puerto serial
arduinoPort.close()
