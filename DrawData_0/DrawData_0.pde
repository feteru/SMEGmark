void setup(){
  size(512,512);
}

String[] acclines;
String[] gyrolines;
String[] orelines;
int[] currgyroPoint = {width/2, height/2};
int[] curraccPoint = {width/2, height/2};
int[] currorePoint = {width/2, height/2};
int accdirX = 1;
int accdirY = 1;
int oredirX = 1;
int oredirY = 1;
int i = 0;
void draw(){
  acclines = loadStrings("../bigdickquick/accelerometer-1523080528.csv");  //read strings from list.txt
  gyrolines = loadStrings("../bigdickquick/gyro-1523080528.csv"); 
  orelines = loadStrings("../bigdickquick/orientationEuler-1523080528.csv");
  
  stroke(int(gyrolines[i]));
  String[] accdims = split(acclines[i], ",");
  int pointX = int(curraccPoint[0] + int(accdims[1])*-accdirX);
  int pointY = int(curraccPoint[1] + int(accdims[2])*-accdirY);
  curraccPoint[0] = pointX;
  curraccPoint[1] = pointY;
  println(curraccPoint);
  stroke(0,0,255);
  point(pointX,pointY);
  
  String[] gyrodims = split(gyrolines[i], ",");
  pointX = int(currgyroPoint[0] + int(gyrodims[1])*-accdirX);
  pointY = int(currgyroPoint[1] + int(gyrodims[2])*-accdirY);
  currgyroPoint[0] = pointX;
  currgyroPoint[1] = pointY;
  println(currgyroPoint);
  stroke(0,255,0);
  point(pointX,pointY);

  String[] oredims = split(orelines[i], ",");
  pointX = int(currgyroPoint[0] + int(oredims[1])*-oredirX);
  pointY = int(currgyroPoint[1] + int(oredims[2])*-oredirY);
  currorePoint[0] = pointX;
  currorePoint[1] = pointY;
  println(currorePoint + "gyro");
  stroke(255,0,0);
  point(pointX,pointY);

  
  i++;
  
  if(curraccPoint[0]>512){
    //curraccPoint[0] = 0;
    accdirX = accdirX*-1;
  }
  else if((curraccPoint[1]>512)||(curraccPoint[1]<0)){
    //curraccPoint[1] = 0; 
    accdirY = accdirY*-1;
  }
  
  else if ((currorePoint[0]>512)){ oredirX = oredirX*-1;} 
  else if ((currorePoint[1]>512)||(currorePoint[1]<0)){ oredirY = oredirY*-1;}
  
  
  if(i > acclines.length){ exit(); }  
  //delay(10);
 
}