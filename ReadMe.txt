bigsickquick: sample myo data sets
DrawColorExperiment: emma attempted processing alterations to Sam's DrawData script
DrawData_0: Sam's processing code drawing using points from an input excel file

SensorRead: c++ code writing myo sensor data to excel files (for processing code to then pick up)

SensorRead info: build PROJECT located in sample/hello-myo..., then run the executable 
(executable in x64/Debug/hello-myo... ), output file is x64/Debug/outFile.txt in format "roll1,pitch1,yaw1|accelx1,accely1,accelz1|gyrox1,gyroy1,gyroz1|emgOver1;roll2,pitch2,yaw2|accelx2,accely2,accelz2|gyrox2,gyroy2,gyroz2|emgOver2"
logFile.csv has same format as outFile.txt but with all commas for csv.
make sure both myo are connected to computer
// 1st 3 (oreintation): int | last 6: floats

to handle 2 myo inputs, we've changed our input files into arrays (1D or 2D). arr[0] is for myo 1, arr[1] is for myo 2.
likewise, if we have 2d arr: arr2[0][] is for myo 1 and arr2[1][] is for myo 2.