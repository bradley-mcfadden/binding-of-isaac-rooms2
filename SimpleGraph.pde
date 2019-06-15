class SimpleGraph{
  Edge data[];
  int manyItems;
    
  SimpleGraph(int capacity){
    data = new Edge[capacity];
    manyItems = 0;
  }
  
  SimpleGraph(){
    this(10);  
  }
  
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
  
  void resize(){
    Edge[] arr = new Edge[data.length*2];
    for (int i = 0; i < manyItems; i++){
      arr[i] = data[i];  
    }
    data = arr;
  }
  
  boolean contains(Edge e){
    for (int i = 0; i < manyItems; i++){
      if (e.equals(data[i]))
        return true;
    }
    return false;
  }
  
  int size(){
    return manyItems;  
  }
  
  String toString(){
    String s = "Set: {";
    for (int i = 0; i < manyItems; i++){
      s = s.concat(data[i]+", \n");  
    }
    s.concat("}");
    return s;
  }
  
  void display(){
    for (int i = 0; i < manyItems; i++){
      //data[i].display();
      data[i].display3();
    }
  }
  
  
}
