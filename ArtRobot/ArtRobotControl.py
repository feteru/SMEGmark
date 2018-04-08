import serial
ser = serial.Serial('COM5', 9600, timeout=0)
intensity = raw_input('Intensity: ') 
speed = raw_input('Speed: ');
ser.write((intensity+'|'+speed+'\n').encode('ascii'))
ser.close()