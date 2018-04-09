// THIS CLASS'S FUNCTIONS NEED THE FULL 2D DRAW DATA ARRAY AS INPUT BECAUSE IT DEPENDS ON BOTH MYO DEVICES
class TrianglesDraw  {
  float pointX, pointY, xdim, ydim, start, stop, pstop = 0;
  int xl1 = 0, yl1 = 0, xl2, yl2, xl3, yl3;
  int xr1 = width, yr1 = 0, xr2, yr2, xr3, yr3;
  boolean twoVertices = true;
  void drawTriangles(String[][] accdims, String[][] oredims) {
    if(twoVertices) {
      xl2 = (xl1 + int(oredims[0][1]))%width; xr2 = (xr1 - int(oredims[1][1]))%width;
      yl2 = (yl1 + int(oredims[0][1]))%height; yr2 = (yr1 + int(oredims[1][1]))%height;
      xl3 = (xl1 + int(oredims[0][2]))%width; xr3 = (xr1 - int(oredims[1][2]))%width;
      yl3 = (yl1 + int(oredims[0][2]))%height; yr3 = (yr1 + int(oredims[1][2]))%height;
      fill((abs(float(accdims[0][0]))*(255/1.2))%255,(abs(float(accdims[0][1]))*(255/1.2))%255,(abs(float(accdims[0][2]))*(255/1.2))%255);
      triangle(xl1,yl1,xl2,yl2,xl3,yl3);
      fill((abs(float(accdims[1][0]))*(255/1.2))%255,(abs(float(accdims[1][1]))*(255/1.2))%255,(abs(float(accdims[1][2]))*(255/1.2))%255);
      triangle(xr1,yr1,xr2,yr2,xr3,yr3);
      xl1 = xl2; yl1 = yl2;
      xr1 = xr2; yr1 = yr2;
      xl2 = xl3; yl2 = yl3;
      xr2 = xr3; yr2 = yr3;
      twoVertices = false;
    } else {
      xl1 = (xl2 + int(oredims[0][2]))%width; xr1 = (xr2 - int(oredims[1][2]))%width;
      yl1 = (yl2 + int(oredims[0][2]))%height; yr1 = (yr2 + int(oredims[1][2]))%height;
      fill((abs(float(accdims[0][0]))*(255/1.2))%255,(abs(float(accdims[0][1]))*(255/1.2))%255,(abs(float(accdims[0][2]))*(255/1.2))%255);
      triangle(xl1,yl1,xl2,yl2,xl3,yl3);
      fill((abs(float(accdims[1][0]))*(255/1.2))%255,(abs(float(accdims[1][1]))*(255/1.2))%255,(abs(float(accdims[1][2]))*(255/1.2))%255);
      triangle(xr1,yr1,xr2,yr2,xr3,yr3);
      twoVertices = true;
    }
  }
  
}
