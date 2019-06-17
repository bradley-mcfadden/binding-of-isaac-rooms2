/**
  * Edge stores information about a connection between two Rect objects.
  * Edge furthest from origin is always b.
*/
class Edge {
  Rect a;
  Rect b;
  int red;
  int blue;
  int green;

  /**
    * Construct edge with two rectangles.
    * @param a Arbitrary rectangle.
    * @param b Arbitrary rectangle.
  */
  Edge(Rect a, Rect b) {
    double magA = Math.sqrt((a.min.x*a.min.x)+(a.min.y*a.min.y));  
    double magB = Math.sqrt((b.min.x*b.min.x)+(b.min.y*b.min.y));  
    if (magB <= magA) {
      this.a = new Rect(b);
      this.b = new Rect(a);
    } else {
      this.a = new Rect(a);
      this.b = new Rect(b);
    }
    red = r.nextInt(256);
    green = r.nextInt(256);
    blue = r.nextInt(256);
  }

  /**
    * Copy constructor.
    * @param e Edge to copy.
  */
  Edge(Edge e) {
    this(e.a, e.b);
  }

  /**
    * Compare two edges.
    * @param e Edge to compare against.
    * @return Are these edges the same?
  */
  boolean equals(Edge e) {
    if (a.equals(e.a) && b.equals(e.b))
      return true;
    return false;
  }

  /**
    * Returns coordinates of Rect objects.
    * @return Description of edge.
  */
  String toString() {
    return "("+a+", "+b+")";
  }

  /**
    * Draw a straight line between Rects.
  */
  void display() {
    stroke(red, green, blue);
    strokeWeight(10);
    line((a.min.x+(a.xsize/2))*CELL_SIZE, (a.min.y+(a.ysize/2))*CELL_SIZE, 
      (b.min.x+(b.xsize/2))*CELL_SIZE, (b.min.y+(b.ysize/2))*CELL_SIZE);
  }

  /**
    * Draw many rectangles in a line between Rects.
  */
  void display2() {
    float deltax = a.min.x - b.min.y;
    //float deltay = a.min.y - b.min.y;
    //float slope = deltay / deltax;
    //print("Slope: " +slope);
    for (int i = 0; i < deltax; i++) {
      noStroke();
      fill(red, green, blue);
      rect((CELL_SIZE/2)+(a.min.x+(a.xsize/2)+i)*CELL_SIZE, (CELL_SIZE/2)+
      (/*(i*slope)*/+a.min.y+(a.ysize/2))*CELL_SIZE, 
        CELL_SIZE, CELL_SIZE);
    }
  }

  /**
    *Draws an opposite side and an ajacent side between two Rects.
  */
  void display3() {
    //int deltax = a.min.x + (a.xsize/2)+abs(a.min.x - b.min.x);
    //int deltay = a.min.y + (a.ysize/2)+abs(a.min.y - b.min.y);
    pushMatrix();
    translate(-CELL_SIZE/2, -CELL_SIZE/2);
    if (a.min.x - b.min.x < 0) {
      for (int i = a.min.x + (a.xsize/2); i <= b.min.x+(b.xsize/2); i++) {
        noStroke();
        fill(0, 255, 0);
        rect(i*CELL_SIZE, (b.min.y+(b.ysize/2))*CELL_SIZE, CELL_SIZE, CELL_SIZE);
      }
    } else if (a.min.x - b.min.x > 0){
      for (int i = b.min.x + (b.xsize/2); i <= a.min.x+(a.xsize/2); i++) {
        noStroke();
        fill(0, 255, 0);
        rect(i*CELL_SIZE, (b.min.y+(b.ysize/2))*CELL_SIZE, CELL_SIZE, CELL_SIZE);
      }
    }
    if (a.min.y - b.min.y < 0) {
      for (int i = a.min.y + (a.ysize/2); i <= b.min.y+(b.ysize/2); i++) {
        noStroke();
        fill(0, 255, 0);
        rect((a.min.x+(a.xsize/2))*CELL_SIZE, i*CELL_SIZE, CELL_SIZE, CELL_SIZE);
      }
    } else if (a.min.y - b.min.y > 0){
      for (int i = b.min.y + (b.ysize/2); i <= a.min.y+(a.ysize/2); i++) {
        noStroke();
        fill(0, 255, 0);
        rect((a.min.x+(a.xsize/2))*CELL_SIZE,i*CELL_SIZE, CELL_SIZE, CELL_SIZE);
      }
    }
    popMatrix();
  }
}
