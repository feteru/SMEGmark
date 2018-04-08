// hit "esc" key to quit draw at any time

//TODO change buffer to random number OR some smallish movement from the last x,y coordinate
ArcDraw arcDraw = new ArcDraw();
MoveColorArcDraw moveColorArcDraw = new MoveColorArcDraw();
BasicShapeLib rectDraw = new BasicShapeLib();

void setup() {
  size(512, 512);
  background(0);
}
//*********************
// INIT VARIABLES 
//********************

boolean readFromExcel = true; // if read line-by-line from .txt, set = false
String inputFileName = "../SensorRead/myo-sdk-win-0.9.0/samples/x64/Debug/outFile.txt"; // either excel or txt
String fileInputXSL_accel = "../bigsickquick/accelerometer-1523080528.csv";
String fileInputXSL_orientEuler = "../bigsickquick/orientationEuler-1523080528.csv";


// file obj to read from
BufferedReader reader;

//input strings
String inputStr;
String[] acclines;
String[] orelines;

// cur accel / orientation reading (to be updated in each loops)
 String[] accdims;
 String[] oredims;

//start the acceleration and the orientation vectors at the same point. 
int[] curraccPoint = {width/2, height/2};
int[] currorePoint = {width/2, height/2};

//initialize directions as 1. When it hits a wall this value will switch. 
int accdirX = 1;
int accdirY = 1;
int oredirX = 1;
int oredirY = 1;
int i = 1;  //increment for moving around. 

int beatDelay = 10; // TODO change the delay time so that it matches the beat of the music

//start and stop for arc drawing.
float[] ends = {0,10};
//start for rectangle drawing (and also end? (past? (and also future?)))
float[] corner1 = {0,0};
//center for moving arc drawing
float[] center = {width/2, height/2};

//****************************
// SUPPORT FUNCTIONS
//****************************
// as safety measure, always mod by width & height to prevent overflow
int[] safeMod(int xVal, int yVal) {
  int[] ret = new int[2]; 
  ret[0] = xVal%width;
  ret[1] = yVal%height;

  return ret; // ret[0] = x, ret[1] = y
}

//****************************
// DRAW() EXECUTING LOOP
//****************************
void draw() {

  delay(beatDelay);
  String[] dataCategory = new String[3]; // save separate data strings into this arr ([0] = accellims, [1] = orelims)

  if (!readFromExcel) {
    // line-by-line .txt data input: opened-close file each time
    reader = createReader(inputFileName); // open file to read

    // read line from that file
    try { inputStr = reader.readLine();  } 
    catch (Exception e ) {
      System.out.println("HELP exception thrown trying to read .txt input file"); 
    }    
    
    if (inputStr != null) {
      dataCategory = split(inputStr, "|");
    } else { // fill dataCategory with dummy string to prevent null pointer exception
      dataCategory[0] = "1,1,1"; // acceleration data dummy
      dataCategory[1] = "1,1,1"; // orienation data dummy
      dataCategory[2] = "1,1,1";
    }
  
  } else if (readFromExcel) { //alternate data input: read strings from 2 .csv input files. This will be reading line-by-line from txt in the future. 
    acclines = loadStrings(fileInputXSL_accel); 
    orelines = loadStrings(fileInputXSL_orientEuler);
    
     //current acceleration reading and plotting section (iterating down xls file with i)
    dataCategory[0] = acclines[i];
    dataCategory[1] = orelines[i];

    // not sure what to do with this "while" code yet:
   // while(i > (inputStr.length()-2)){ delay(2000); exit();}
  } else {
    System.out.println("ERROR invalid boolean input for readFromExcel");
  }
  
      accdims = split(dataCategory[0], ",");
      oredims = split(dataCategory[1], ",");
   
      println(dataCategory[1]);
      println(dataCategory[0]);

  //int[] newpoint = pointPlot(orelines[i],curraccPoint));
  //String[] oredims = split(orelines[i], ",");

  int pointX = int(currorePoint[0] + int(oredims[1])*-oredirX + int(accdims[1])*-accdirX);  //create new point based off of old
  int pointY = int(currorePoint[1] + int(oredims[2])*-oredirY + int(accdims[2])*-accdirY);
  if ((pointX == currorePoint[0])&&(pointY==currorePoint[1])) {
    //if they're the same does it matter?
  }
  currorePoint[0] = pointX; 
  currorePoint[1] = pointY;  //update the current orientation
  // println(str(currorePoint[0]) + ", " + str(currorePoint[1]));  // println for debugging:
  
  // move points around page at more wide-spread rate to see flow better
  // "mod" handles running off the page (but loops around instead of bouncing back in dir from which it came)
  
  int adaptedXpt = safeMod(3*pointX, 3*pointY)[0];
  int adaptedYpt = safeMod(3*pointX, 3*pointY)[1];
  
  //point(adaptedXpt, adaptedYpt); // make sure the point never overwrites the buffer with %width & %height (it essentially wraps around)
  
  
  //linesSlantUp(1, width/8, 3, adaptedXpt, adaptedYpt);
  
  println(accdims);
 // ends = arcDraw.drawArc(accdims, oredims, ends);
   //ends = moveColorArcDraw.drawArc(accdims, oredims, ends, center);
  rectDraw.Rectangles(accdims, oredims, corner1);
  
  
  //handle running off the edge. I wish this were better. 
  // update: instead of bouncing back in dir from which the point came, code will loop (see mod "%")
  //if(curraccPoint[0]>512){accdirX = accdirX*-1;}
  //else if((curraccPoint[1]>512)||(curraccPoint[1]<0)){ accdirY = accdirY*-1;}
  //else if ((currorePoint[0]>512)||(currorePoint[0]<512)){ oredirX = oredirX*-1;} 
  //else if ((currorePoint[1]>512)||(currorePoint[1]<0)){ oredirY = oredirY*-1;}

if (!readFromExcel) { // if not reading from excel, it's reading from a .txt so we open/close file in each loop
  try {
    reader.close();
  } 
  catch (Exception e ) {
    System.out.println("HELP exception thrown trying to close input file");
  }
} else {
    i++;  //increment the index one. only valid for excel input (no needed for .txt)
}

  
save("./artworkOutput.jpg");
}

// press "s" at any time to save the current image on screen
void keyPressed(){
  if(key == 's'){
    println("Saving...");
    saveFrame("screen-####.jpg");
    println("Done saving.");
  }
}