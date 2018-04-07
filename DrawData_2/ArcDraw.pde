class ArcDraw  {
  float pointX, pointY, xdim, ydim, start, stop;
  
  void drawArc(String[] accdims, String[] oredims, float start)  {
    
    int pointX = width / 2; int pointY = height/2;
    
    xdim = abs(float(accdims[1])*100);
    ydim = abs(float(accdims[2])*100);
    
    stop = start + abs(float(oredims[1]));
    
    arc(pointX, pointY, xdim, ydim, start, stop, OPEN);

  }
  float retStop(){
    return stop;
  }
  
  
}