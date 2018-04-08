class RelativeTriangleDraw  {
  float pointX, pointY, xdim, ydim, start, stop, pstop = 0;

  
  void drawTriangles(String[][] accdims, String[][] oredims, float[][] center) {
    
    //int pointX = width / 2; int pointY = height/2;
   // delay(100);
    //move the center around.
    center[0][0] = center[0][0] + -3*float(oredims[0][2]); // [myo1, myo2][x,y]
    center[0][1] = center[0][0] + 3*float(accdims[0][1]); //x-movement
    
    //change the size of the arcs that are generated
    xdim = abs(float(oredims[0][1])*100);
    ydim = abs(float(oredims[0][2])*100);
    //change the arc length that is generated. 
 //   ends[0] = pstop;
  //  ends[1] = ends[0] + abs(float(accdims[0][1]));
   // pstop = ends[1];
    
    noStroke();
   // strokeWeight(3);  // thickness of line (1 is default)
   
   int tempAcc = 5*Integer.parseInt(accdims[0][1]);
   
    fill(abs(tempAcc%255), int(abs((xdim)%255)), int((abs((ydim)%255)))); // color of fill: between 0 and 255
  
  //triangle(x1, y1, x2, y2, x3, y3)
  int x1 = Integer.parseInt(oredims[0][0]);
  int y1 = Integer.parseInt(oredims[0][1]);
  int x2 = Integer.parseInt(oredims[0][0]) + Integer.parseInt(accdims[0][0]);
  int y2 = Integer.parseInt(oredims[0][1]) + Integer.parseInt(accdims[0][1]);
  int x3 = Integer.parseInt(oredims[0][0]) + Integer.parseInt(accdims[1][0]);
  int y3 = Integer.parseInt(oredims[0][1]) + Integer.parseInt(accdims[1][1]);

  triangle(x1, y1, x2, y2, x3, y3);

   
  }
  
}
