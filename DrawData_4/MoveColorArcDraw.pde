class MoveColorArcDraw  {
  float pointX, pointY, xdim, ydim, start, stop, pstop = 0;

  
  float[] drawArc(String[] accdims, String[] oredims, float[] ends, float[] center) {
    
    //int pointX = width / 2; int pointY = height/2;
   // delay(100);
    //move the center around.
    System.out.println("accdims: "+accdims.length);
    center[0] = center[0] + -3*float(accdims[2]);
    center[1] = center[1] + 3*float(oredims[1]);
    
    //change the size of the arcs that are generated
    xdim = abs(float(accdims[1])*100);
    ydim = abs(float(accdims[2])*100);
    //change the arc length that is generated. 
    ends[0] = pstop;
    ends[1] = ends[0] + abs(float(oredims[1]));
    pstop = ends[1];
    
    noStroke();
   // strokeWeight(3);  // thickness of line (1 is default)
    fill(ends[0]%255, xdim%255, ydim%255); // color of fill: between 0 and 255
    //HOW-TO use fill:  
    //fill(rgb)
    //fill(rgb, alpha) // alpha float specifies opacity of the fill
    //fill(gray) // (float specifies val between white & black)
    //fill(gray, alpha)
      //fill(v1, v2, v3)
      //fill(v1, v2, v3, alpha)
    // v1 = red or hue, v2 = green or saturdation, v3 =blue or brightness
    arc(center[0]%width, center[1]%height, xdim, ydim, ends[0], ends[1], OPEN);
    return ends;
  }
  
}
