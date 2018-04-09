bigsickquick: sample myo data sets
DrawData: processing code versions to draw using points from an input excel file

SensorRead: Gerry's c++ code writing myo sensor data to excel files (for processing code to then pick up)

SensorRead info: build PROJECT located in sample/hello-myo..., then run the executable 
(executable in x64/Debug/hello-myo... ), output file is x64/Debug/outFile.txt in format "roll1,pitch1,yaw1|accelx1,accely1,accelz1|gyrox1,gyroy1,gyroz1|emgOver1;roll2,pitch2,yaw2|accelx2,accely2,accelz2|gyrox2,gyroy2,gyroz2|emgOver2"
logFile.csv has same format as outFile.txt but with all commas for csv.
make sure myo is connected to computer
// 1st 3 (oreintation): int | last 6: floats

to run DrawData from csv, set readFromExcel = true, logFileName = "whateverYourFileIsCalled.csv"
to run data in real-time, readFromExcel = false, inputFileName = "fileIsCalled.txt"
for real-time data also launch hello-myo application executable (minimize black console that pops up and have it run in background)