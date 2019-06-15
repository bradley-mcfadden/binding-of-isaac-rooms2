class Rect {
  Point min;
  Point max;
  int xsize;
  int ysize;
  int red;
  int blue;
  int green;
  boolean visited;
  
  Rect (Rect r){
    this(r.min,r.max);  
  }
  
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
    red = r.nextInt(256);
    blue = r.nextInt(256);
    green = r.nextInt(256);
  }
  
  Rect(int xs, int ys, Point p1){
    xsize = xs;
    ysize = ys;
    visited = false;
    min = new Point(p1);
    max = new Point(p1.x+xs,p1.y+ys);
    red = r.nextInt(256);
    blue = r.nextInt(256);
    green = r.nextInt(256);
    
  }
  
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
  
  float distance (Rect r){
    float deltax = (r.min.x + (r.xsize/2)) - (min.x+(xsize/2));
    float deltay = (r.min.y + (r.ysize/2)) - (min.y+(ysize/2));
    return (float)Math.sqrt((deltax*deltax)+(deltay*deltay));
  }
  
  float distance(){
    float deltax = min.x+(xsize/2);
    float deltay = min.y+(ysize/2);
    return (float)Math.sqrt((deltax*deltax)+(deltay*deltay));
  }
 
  boolean equals(Rect r){
    if (min.equals(r.min) && max.equals(r.max))
      return true;
     return false;
  }
  
  String toString(){
    return ("Left Corner:("+min.x+" "+min.y+") Size:("+xsize+" "+ysize+")");    
  }
 
  void display(){   
    fill(50);
    strokeWeight(CELL_SIZE);
    stroke(red,green, blue);
    rect(min.x*CELL_SIZE,min.y*CELL_SIZE,(xsize*CELL_SIZE)-border,(ysize*CELL_SIZE)-border);
  }
}
