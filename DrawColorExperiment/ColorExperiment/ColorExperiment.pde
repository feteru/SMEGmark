void setup(){
  size(512,512); // size of window
}

String[] acclines;
String[] orelines;

//start the acceleration and the orientation vectors at the same point. 
int[] curraccPoint = {width/2, height/2};
int[] currorePoint = {width/2, height/2};

//initialize directions as 1. When it hits a wall this value will switch. 
int accdirX = 1;
int accdirY = 1;
int oredirX = 1;
int oredirY = 1;
int i = 0;  //increment for moving around. 

void draw(){
  //read strings from .csv files. This will be only one file in the future. 
  acclines = loadStrings("../bigsickquick/accelerometer-1523080528.csv"); 
  orelines = loadStrings("../bigsickquick/orientationEuler-1523080528.csv");
  
  //current acceleration reading and plotting section
  String[] accdims = split(acclines[i], ",");
  int pointX = int(curraccPoint[0] + int(accdims[1])*-accdirX);
  int pointY = int(curraccPoint[1] + int(accdims[2])*-accdirY);
  curraccPoint[0] = pointX;
  curraccPoint[1] = pointY;
  //println(curraccPoint);
  //point(pointX,pointY)
  
  //int[] newpoint = pointPlot(orelines[i],curraccPoint));
  String[] oredims = split(orelines[i], ",");
  pointX = int(currorePoint[0] + int(oredims[1])*-oredirX);  //create new point based off of old
  pointY = int(currorePoint[1] + int(oredims[2])*-oredirY);
  currorePoint[0] = pointX; currorePoint[1] = pointY;  //update the current orientation
  println(str(currorePoint[0]) + ", " + str(currorePoint[1]));
  point(pointX,pointY);

  
  i++;  //increment the index one. 
  
  //handle running off the edge. I wish this were better. 
  if(curraccPoint[0]>512){accdirX = accdirX*-1;}
  else if((curraccPoint[1]>512)||(curraccPoint[1]<0)){ accdirY = accdirY*-1;}
  else if ((currorePoint[0]>512)||(currorePoint[0]<512)){ oredirX = oredirX*-1;} 
  else if ((currorePoint[1]>512)||(currorePoint[1]<0)){ oredirY = oredirY*-1;}
  
  
  if(i > acclines.length){ exit(); }   
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
