class ArcDraw  {
  float pointX, pointY, xdim, ydim, start, stop;
  
  void test(boolean a){
    if(a==true){println("she works");}
  }
  
  void drawArc(String[] accdims, String[] oredims, float start)  {
    
    int pointX = width / 2; int pointY = height/2;
    
    xdim = float(accdims[1]);
    ydim = float(accdims[2]);
    
    stop = start + float(oredims[1]);
    arc(pointX, pointY, xdim, ydim, start, stop);

  }
  
  
}