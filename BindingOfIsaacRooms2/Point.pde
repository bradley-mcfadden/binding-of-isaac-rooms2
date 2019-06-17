/**
  * Vector for integer values.
*/
class Point{
 int x;
 int y;
 /**
   * Make a point.
   * @param x X value.
   * @param y Y value.
 */
 Point (int x, int y){
   this.x = x;
   this.y = y;
 }
 
 /**
   * Copy constructor.
   * @param p Point to copy.
 */
 Point (Point p){
  this(p.x, p.y); 
 }
 
 /**
   * Compares two points.
   * @param p Point to compare.
   * @return Is this equal to p?
 */
 boolean equals(Point p){
   if (x == p.x && y == p.y)
     return true;
   return false;
 }
}
