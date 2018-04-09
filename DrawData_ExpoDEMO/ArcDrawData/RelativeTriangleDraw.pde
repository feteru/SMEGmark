class RelativeTriangleDraw  {
  float pointX, pointY, xdim, ydim, start, stop, pstop = 0;

  
  void drawTriangles(String[][] accdims, String[][] oredims, float[] ends, float[][] center) {
    
    //int pointX = width / 2; int pointY = height/2;
   // delay(100);
    //move the center around. // myo 1:
    center[0][0] = center[0][0] + -5*float(oredims[0][2]); // 2Dorder[myo1, myo2][x,y]
    center[0][1] = center[0][0] + 3*float(accdims[0][1]); 
    
    //change the size of the arcs that are generated
    xdim = abs(float(oredims[0][1])*100);
    ydim = abs(float(oredims[0][2])*100);
    //change the arc length that is generated. 
    ends[0] = pstop;
    ends[1] = ends[0] + abs(float(accdims[0][1]));
    pstop = ends[1];
    
    delay(50);
   // noStroke();
   strokeWeight(3);  // thickness of line (1 is default)
   stroke(255);
   
   float tempAcc = 5*float(accdims[0][1]);
   println("r "+abs(tempAcc%255));
    fill(abs(50*tempAcc%255), int(abs((xdim)%255)), int((abs((ydim)%255)))); // color of fill: between 0 and 255
 // fill(255);
  //triangle(10,40,200,50,30,70);
  //triangle(x1, y1, x2, y2, x3, y3)
  float x1 = (50*float(oredims[0][0]) + 30*float(oredims[0][0]))%width;
  float y1 = (50*float(oredims[1][1]))%height;
  float x2 = (50*float(oredims[0][0]) + 25*float(oredims[0][0]) + 100*float(accdims[0][0]))%width;
  float y2 = (50*float(oredims[1][0]) + 50*float(accdims[0][1]))%height;
  float x3 = (50*float(oredims[0][0]) + 30*float(oredims[0][0]) + 100*float(accdims[1][0]))%width;
  float y3 = (50*float(oredims[1][1]) + 50*float(accdims[1][1]))%height;
  
  println(x1);

  triangle(x1, y1, x2, y2, x3, y3);

   
  }
  
}
