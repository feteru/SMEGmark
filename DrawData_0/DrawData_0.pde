void setup(){
  size(512,512);
}

String[] acclines;
String[] orelines;
int[] curraccPoint = {width/2, height/2};
int[] currorePoint = {width/2, height/2};
int accdirX = 1;
int accdirY = 1;
int oredirX = 1;
int oredirY = 1;
int i = 0;
void draw(){
  acclines = loadStrings("../bigsickquick/accelerometer-1523080528.csv");  //read strings from list.txt
  orelines = loadStrings("../bigsickquick/orientationEuler-1523080528.csv");
  
  String[] accdims = split(acclines[i], ",");
  int pointX = int(curraccPoint[0] + int(accdims[1])*-accdirX);
  int pointY = int(curraccPoint[1] + int(accdims[2])*-accdirY);
  curraccPoint[0] = pointX;
  curraccPoint[1] = pointY;
  println(curraccPoint);
  //point(pointX,pointY)
  
  //int[] newpoint = pointPlot(orelines[i],curraccPoint));
  String[] oredims = split(orelines[i], ",");
  pointX = int(currorePoint[0] + int(oredims[1])*-oredirX);
  pointY = int(currorePoint[1] + int(oredims[2])*-oredirY);
  currorePoint[0] = pointX;
  currorePoint[1] = pointY;
  println(currorePoint + "gyro");
  stroke(255,0,0);
  point(pointX,pointY);

  
  i++;
  
  //handle running off the edge. I wish this were better. 
  if(curraccPoint[0]>512){accdirX = accdirX*-1;}
  else if((curraccPoint[1]>512)||(curraccPoint[1]<0)){ accdirY = accdirY*-1;}
  else if ((currorePoint[0]>512)){ oredirX = oredirX*-1;} 
  else if ((currorePoint[1]>512)||(currorePoint[1]<0)){ oredirY = oredirY*-1;}
  
  
  if(i > acclines.length){ exit(); }  
  //delay(10);
 
}


//void pointPlot(String line, int[] currPoint, int type){
  
//  String[] split = split(line,",");
//  if(type==0){
//   pointX =  
//  }
//  int pointX = int(curraccPoint[0] + int(accdims[1])*-accdirX);
//  int pointY = int(curraccPoint[1] + int(accdims[2])*-accdirY);
//  curraccPoint[0] = pointX;
//  curraccPoint[1] = pointY;
//  println(curraccPoint);

  
  
//}