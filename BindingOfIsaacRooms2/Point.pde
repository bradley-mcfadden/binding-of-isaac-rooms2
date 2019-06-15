class Point{
 int x;
 int y;
 Point (int x, int y){
   this.x = x;
   this.y = y;
 }
 
 Point (Point p){
  this(p.x, p.y); 
 }
 
 boolean equals(Point p){
   if (x == p.x && y == p.y)
     return true;
   return false;
 }
}
