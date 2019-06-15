class UnsortedSet <T>{
  Object[] data;
  int manyItems;
  
  UnsortedSet(int initialCapacity){
    data = new Object[initialCapacity];
  }
  
  UnsortedSet(){data = new Object[10];}
  
  boolean contains(T t){
    for (int i = 0; i < manyItems; i++){
      if (((T)data[i]).equals(t)){
        return true;  
      }
    }
    return false;
  }
  
  void add(T t){
    if (!contains(t)){
      if (manyItems == data.length)
        ensureCapacity((manyItems+1)*2);
      data[manyItems] = t;
      manyItems++;
    }
  }
  
  void ensureCapacity(int minimumCapacity){
    Object[ ] biggerArray;
    if (data.length < minimumCapacity){
      biggerArray = new Object[minimumCapacity];
      System.arraycopy(data, 0, biggerArray, 0, manyItems);
      data = biggerArray;
    }
  }
  
  int size(){return manyItems;}
  
  int getCapacity(){return data.length;}
  
  String toString(){
    String result = "[";
    for (int i = 0; i < manyItems; i++){
      if (i == manyItems - 1)
        result += data[i].toString() + "]";
      else 
        result += data[i].toString() + ", ";
    }
    return result;
  }
}
