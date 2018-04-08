
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
