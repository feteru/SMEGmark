// hit "esc" key to quit draw at any time

void setup(){
  size(512,512);
}

// as safety measure, always mod by width & height to prevent overflow
int[] safeMod(int xVal, int yVal) {
  int[] ret = new int[2]; 
  ret[0] = xVal%width;
  ret[1] = yVal%height;
  
  return ret;
}

void linesSlantUp(int modVal, int spacing, int xVal, int yVal) {
// every 2nd point, also include a line to spice things up
  if (i%2 == 0) {
    int x1 = xVal*spacing - (width/modVal);
    int x2 = xVal*spacing + (width/modVal);
    int y1 = yVal*spacing - (height/modVal);
    int y2 = yVal*spacing + (height/modVal);
    
    // to ensure no overflow, call safety measure
    int[] allXVals = safeMod(x1, x2);
    int[] allYVals = safeMod(y1, y2);
    
    //draw line
    line(x1,y1,x2,y2);
  }
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
  if(i > (acclines.length-2)){ delay(2000); exit(); }   

  //current acceleration reading and plotting section
  String[] accdims = split(acclines[i], ",");
  
  //int[] newpoint = pointPlot(orelines[i],curraccPoint));
  String[] oredims = split(orelines[i], ",");
  int pointX = int(currorePoint[0] + int(oredims[1])*-oredirX + int(accdims[1])*-accdirX);  //create new point based off of old
  int pointY = int(currorePoint[1] + int(oredims[2])*-oredirY + int(accdims[2])*-accdirY);
  if((pointX == currorePoint[0])&&(pointY==currorePoint[1])){
    //if they're the same does it matter?    
  }
  currorePoint[0] = pointX; currorePoint[1] = pointY;  //update the current orientation
  println(str(currorePoint[0]) + ", " + str(currorePoint[1]));
  
  // move points around page at more wide-spread rate to see flow better
  // "mod" handles running off the page (but loops around instead of bouncing back in dir from which it came)
  int adaptedXpt = ((pointX*3) % width);
  int adaptedYpt = ((pointY*3) % height);
  point(adaptedXpt,adaptedYpt); // make sure the point never overwrites the buffer with %width & %height (it essentially wraps around)

// every 2nd point, also include a line to spice things up
  if (i%2 == 0) {
    int x1 = adaptedXpt - (width/8);
    int x2 = adaptedXpt + (width/8);
    int y1 = adaptedYpt - (height/8);
    int y2 = adaptedYpt + (height/8);
    line(x1,y1,x2,y2);
  }
  
  i++;  //increment the index one. 
  
  //handle running off the edge. I wish this were better. 
// update: instead of bouncing back in dir from which the point came, code will loop (see mod "%")
  //if(curraccPoint[0]>512){accdirX = accdirX*-1;}
  //else if((curraccPoint[1]>512)||(curraccPoint[1]<0)){ accdirY = accdirY*-1;}
  //else if ((currorePoint[0]>512)||(currorePoint[0]<512)){ oredirX = oredirX*-1;} 
  //else if ((currorePoint[1]>512)||(currorePoint[1]<0)){ oredirY = oredirY*-1;}
  
  
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
