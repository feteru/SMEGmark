class BasicShapeLib {

void linesSlantUp(int freq, int lineLeng, int spacing, int xVal, int yVal) { // highest freq at 1, 
  // every 2nd point, also include a line to spice things up
  if (i%freq == 0) {
    int x1 = xVal*spacing - (width/lineLeng);
    int x2 = xVal*spacing + (width/lineLeng);
    int y1 = yVal*spacing - (height/lineLeng);
    int y2 = yVal*spacing + (height/lineLeng);

    // to ensure no overflow, call safety measure
    int[] allXVals = safeMod(x1, x2);
    int[] allYVals = safeMod(y1, y2);

    //draw line
    line(allXVals[0], allYVals[0], allXVals[1], allYVals[1]);
  }
}

float[] Rectangles(String[] accdims, String[] oredims, float[] corner1)  {
  rectMode(CORNER);
  println("she here");
  fill(0,255,0);
  //float[] corner1 = (ends);  //pass corner1 value in.
  float wide1 = abs(float(accdims[0])) + abs(float(accdims[1]))*5 + corner1[0];  //width is composite of two 
  float height1 = abs(float(accdims[2])) + corner1[1];  //height delta + previous height value
  
  if(height1 > height){
    height1 = height;
    rect(corner1[0], corner1[1], wide1, height1);
    corner1[0] = wide1; corner1[1] = height1;
  }
  else if(height1 < height)
    //float[] corner2 = {corner1[0] + wide1, corner2[0]);
    rect(corner1[0], corner1[1], wide1, height1);
  return corner1;
}

}