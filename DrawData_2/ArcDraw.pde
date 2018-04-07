class ArcDraw  {
  float pointX, pointY, xdim, ydim, start, stop, pstop = 0;

  float[] drawArc(String[] accdims, String[] oredims, float[] ends) {
    int pointX = width / 2; int pointY = height/2;
    delay(50);

    xdim = abs(float(accdims[1])*100);
    ydim = abs(float(accdims[2])*100);
    ends[0] = pstop;
    ends[1] = ends[0] + abs(float(oredims[1]));
    pstop = ends[1];
    arc(pointX, pointY, xdim, ydim, ends[0], ends[1], OPEN);
    return ends;
  }
  
}