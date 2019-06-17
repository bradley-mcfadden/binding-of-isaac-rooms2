/**
  * Set of edges. Could be replaced by UnsortedSet.
*/
class SimpleGraph{
  Edge data[];
  int manyItems;
  
  /**
    * Create edge set with some capacity.
    * @param capacity Number of items set can hold before resize.
  */
  SimpleGraph(int capacity){
    data = new Edge[capacity];
    manyItems = 0;
  }
  
  /**
    * Create graph with capacity of 10.
  */
  SimpleGraph(){
    this(10);  
  }
  
  /**
    * Add an edge to the graph.
    * @param e Edge to add.
    * @return True if not already in set.
  */
  boolean add(Edge e){
    if (manyItems >= data.length)
      resize();
    if (!contains(e)){
      data[manyItems] = new Edge(e);
      manyItems++;
      return true;
    }
    return false;
  }
  
  /**
    * Doubles size of set.
  */
  void resize(){
    Edge[] arr = new Edge[data.length*2];
    for (int i = 0; i < manyItems; i++){
      arr[i] = data[i];  
    }
    data = arr;
  }
  
  /**
    * Determines if edge is already in set.
    * @param e Edge to check.
    * @return Is it already in the set?
  */ 
  boolean contains(Edge e){
    for (int i = 0; i < manyItems; i++){
      if (e.equals(data[i]))
        return true;
    }
    return false;
  }
  
  /**
    * Get number of elements in this set.
    * @return Number of elements in set.
  */
  int size(){
    return manyItems;  
  }
  
  /**
    * Print out the set.
    * @return String of set.
  */
  String toString(){
    String s = "Set: {";
    for (int i = 0; i < manyItems; i++){
      s = s.concat(data[i]+", \n");  
    }
    s.concat("}");
    return s;
  }
  
  /**
    * Calls display method for every edge in set
  */
  void display(){
    for (int i = 0; i < manyItems; i++){
      //data[i].display();
      data[i].display3();
    }
  }
  
  
}
