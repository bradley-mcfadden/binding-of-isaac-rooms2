/**
  * Describes an area on a discrete grid.
*/
class Rect {
  Point min;
  Point max;
  int xsize;
  int ysize;
  //int red;
  //int blue;
  //int green;
  boolean visited;
  
  /**
    * Copy constructor.
    * @param r Rect to copy.
  */
  Rect (Rect r){
    this(r.min,r.max);  
  }
  
  /**
    * Makes an area from its top left corner and bottom left.
    * @param one Arbitrary point.
    * @param two Arbitrary point.
  */
  Rect(Point one, Point two){
    int minx = one.x < two.x ? one.x : two.x;
    int maxx = one.x > two.x ? one.x : two.x;
    int miny = one.y < two.y ? one.y : two.y;
    int maxy = one.y > two.y ? one.y : two.y;
    min = new Point(minx, miny);
    max = new Point(maxx, maxy);
    xsize = max.x - min.x;
    ysize = max.y - min.y;
    visited = false;
    //red = r.nextInt(256);
    //blue = r.nextInt(256);
    //green = r.nextInt(256);
  }
  
  /**
    * Make a rect from left top corner and width/height.
    * @param xs Width.
    * @param ys Height.
    * @param p1 Top left corner.
  */
  Rect(int xs, int ys, Point p1){
    xsize = xs;
    ysize = ys;
    visited = false;
    min = new Point(p1);
    max = new Point(p1.x+xs,p1.y+ys);
    //red = r.nextInt(256);
    //blue = r.nextInt(256);
    //green = r.nextInt(256);
    
  }
  
  /**
    * Checks if two Rect objects overlap.
    * @param r Rect to check.
    * @return Do they overlap?
  */
  boolean isInside(Rect r){
    if ( 
    !(!(min.x >= r.min.x && max.y <= r.max.y && min.x <= r.max.x && max.y >= r.min.y) 
    && !(min.x >= r.min.x && max.y <= r.max.y && max.x <= r.max.x && min.y >= r.min.y)
    && !(min.x >= r.min.x && min.y >= r.min.y && min.x <= r.max.x && min.y <= r.max.y)
    && !(max.y <= r.max.y && max.y >= r.min.y && max.x <= r.max.x && max.x >= r.min.x)
    && !(min.y <= r.min.y && max.y >= r.min.y && min.x >= r.min.x && min.x <= r.max.x))
    )
      return true;
    
    return false;
  }
  
  /** 
    * Distance between two rects. 
    * If they are beside one another on grid, 
    * returns distance between closest edges.
    * Else, distance between centers.
    * @param r Rect to measure against.
    * @return Distance between rects.
  */
  float distance (Rect r){
    if (r.equals(this))
      return Float.MAX_VALUE;
    if (min.x == r.min.x){
      if (min.y < r.min.y){
        return r.min.y - max.y;  
      } else if (min.y > r.min.y){
        return min.y - r.max.y;
      }
    } else if (min.y == r.min.y){
      if (min.x < r.min.x){
        return r.min.x - max.x;
      } else if (min.x > r.min.x){
        return min.x - r.max.x;
      }
    }
    float deltax = min.x+(xsize/2) - r.min.x+(r.xsize/2);
    float deltay = min.y+(ysize/2) - r.min.y+(r.ysize/2);
    return (float)Math.sqrt((deltax*deltax)+(deltay*deltay));
  }
  
  /**
    * Distance of Rect center from origin.
    * @return Distance of Rect from origin.
  */
  float distance(){
    float deltax = min.x+(xsize/2);
    float deltay = min.y+(ysize/2);
    return (float)Math.sqrt((deltax*deltax)+(deltay*deltay));
  }
  /**
    * Compares if two Rect objects are equal.
    * @param r Rect to compare to.
    * @return Are they equal?
  */
  boolean equals(Rect r){
    if (min.equals(r.min) && max.equals(r.max))
      return true;
     return false;
  }
  
  /**
    * Returns position of Rect and its size.
    * @return State of Rect.
  */
  String toString(){
    return ("Left Corner:("+min.x+" "+min.y+") Size:("+xsize+" "+ysize+")");    
  }
 
  /**
    * Draw rect on screen.
  */
  void display(){   
    fill(50);
    strokeWeight(CELL_SIZE);
    //stroke(red,green, blue);
    stroke(200);
    rect(min.x*CELL_SIZE,min.y*CELL_SIZE,(xsize*CELL_SIZE)-BORDER,(ysize*CELL_SIZE)-BORDER);
  }
}
