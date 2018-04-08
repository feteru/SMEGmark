class BasicShapeLib{
  
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
  

  int[][] Rectangles(String[] accdims, String[] oredims, int[][] corner) {
    rectMode(CORNER);
    
    fill((float(oredims[0])*200)%255, (float(oredims[1])*200)%255, (float(oredims[2])*200)%255);
    //float[] corner1 = (ends);  //pass corner1 value in.
    //corner[1][1] = abs(int(accdims[2])) + corner[1][1];  //height delta + previous height value
    //44println(corner[0]);
    if(corner[1][1] > height){
      corner[1][1] = height;
      rect(corner[0][0], corner[0][1], corner[1][0], corner[1][1]);
      corner[0][0] = corner[1][0]; corner[0][1] = 0;
      corner[1][0] = corner[0][0];  //abs(int(accdims[0]))*5 + abs(int(oredims[1]))*3 + 
      corner[1][1] = corner[0][1]; //abs(int(accdims[2]))*4;
      //rect(corner[0][0], corner[0][1], corner[1][0], corner[1][1]);
    }
    else if(corner[1][1] < height){
      //float[] corner2 = {corner1[0] + wide1, corner2[0]);
      rect(corner[0][0]%width, corner[0][1]%width, corner[1][0]%width, corner[1][1]%width);  //do a rectangle
      corner[0][1] = corner[1][1];  //set the new top left to the old bottom right.
      corner[1][1] = corner[0][1] + abs(int(accdims[2]))*3;
      //println(corner[0]);
    }
    else if(corner[1][1] > width){
      rect(corner[0][0], corner[0][1], corner[1][0], corner[1][1]);
      corner[0][0] = 0; corner[0][1] = 0; //corner[1][1];
      corner[1][0] = abs(int(accdims[0]))*5 + abs(int(oredims[1]))*3;
      corner[1][1] = abs(int(accdims[2]))*4;
      rect(corner[0][0], corner[0][1], corner[1][0], corner[1][1]);
    }
      //println(corner[0]);
      //println(corner[1]);
      return corner;

  
  }
}