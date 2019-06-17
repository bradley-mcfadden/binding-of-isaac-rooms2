/**
  * Generic unsorted, unordered set.
*/
class UnsortedSet <T>{
  Object[] data;
  int manyItems;
  
  /** 
    * Create UnsortedSet with some capacity.
    * @param capacity Number of items it can hold before resizing.
  */
  UnsortedSet(int initialCapacity){
    data = new Object[initialCapacity];
  }
  
  /**
    *Create set with 10 capacity.
  */
  UnsortedSet(){data = new Object[10];}
  
  /**
    * Check if set contains some object.
    * @param t Item to search for
    * @return Is object in set?
  */
  boolean contains(T t){
    for (int i = 0; i < manyItems; i++){
      if (((T)data[i]).equals(t)){
        return true;  
      }
    }
    return false;
  }
  
  /**
    * Search for an remove item from set.
    * @param t Item to remove
  */
  void remove(T t){
    Object[] newArray = new Object[data.length];
    for (int i = 0; i < manyItems;){
      if (!((T)data[i]).equals(t)){
        newArray[i] = data[i];  
        i++;
      }
    }
    manyItems--;
  }
  
  /**
    * Grab a random member of the set.
    * @return Reference to random item.
  */
  T grab(){
   int i = (int)(random(manyItems));
   return (T)data[i];
  }
  
  /**
    * Add an object to the set.
    * @param t Item to add.
  */
  void add(T t){
    if (!contains(t)){
      if (manyItems == data.length)
        ensureCapacity((manyItems+1)*2);
      data[manyItems] = t;
      manyItems++;
    }
  }
  
  /**
    * Make sure set is at least a certain size.
    * @param minimumCapacity Make set this big.
  */
  void ensureCapacity(int minimumCapacity){
    Object[ ] biggerArray;
    if (data.length < minimumCapacity){
      biggerArray = new Object[minimumCapacity];
      System.arraycopy(data, 0, biggerArray, 0, manyItems);
      data = biggerArray;
    }
  }
  
  /**
    * Get number of items in set.
    * @return Number of items in set.
  */
  int size(){return manyItems;}
  
  /**
    * Get number of items set can hold before doubling in size.
  */
  int getCapacity(){return data.length;}
  
  /**
    * Return a string of all items in set.S
    * @return State of set.
  */
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
