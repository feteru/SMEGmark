class ColorArcDraw  {
  float pointX, pointY, xdim, ydim, start, stop, pstop = 0;

  
  float[] drawArc(String[] accdims, String[] oredims, float[] ends) {
    int pointX = width / 2; int pointY = height/2;
   // delay(100);
    
    xdim = abs(float(accdims[1])*100);
    ydim = abs(float(accdims[2])*100);
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
    
    
 //   arc(pointX, pointY, (5*xdim)%width, (7*ydim)%height, ends[0], ends[1], OPEN); // fills page
    arc(pointX, pointY, (xdim)%width, (ydim)%height, ends[0], ends[1], OPEN);

    return ends;
  }
  
}