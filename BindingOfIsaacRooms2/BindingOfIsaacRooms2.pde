import java.util.ArrayList;
import java.util.Random;
import java.util.Iterator;
int NUM_RECTS = 20;
Random r;
//int GRIDXS;
//int GRIDYS;
int CELL_SIZE = 20;
int time = 0;
float avgTime = 0;
int avgRooms = 0;
int rooms = 0;
int count = 0;
int cellcountw;
int cellcounth;
int cellxs;
int cellys;
int ROOMW = 15;
int ROOMH = 10;
int border = 5;
ArrayList<Rect> region;
float[][] matrix;
SimpleGraph edgeSet;

void setup(){
  size(1600,900);
  cellcountw = width / CELL_SIZE; //120
  cellcounth = height / CELL_SIZE;
  cellxs = width / cellcountw;
  cellys = height / cellcounth;
  r = new Random();
  generate();
  connect2();
}

void draw(){
  background(200);
  
  for (int i = 0; i < cellcountw; i++){
    stroke(0);
    strokeWeight(3);
    line((i * cellxs)+CELL_SIZE/2,0,(i * cellxs)+CELL_SIZE/2,height);
  }
  for (int i = 0; i < cellcounth; i++){
    stroke(0);
    strokeWeight(3);
    line(0,(i * cellys)+CELL_SIZE/2,width,(i * cellys)+CELL_SIZE/2);
  }
  edgeSet.display();
  for (Rect r: region)
    r.display();
}

//Generate4 a new room and log data
void keyReleased(){
  count++;
  int start = millis();
  generate();
  connect();
  time += millis() - start;
  avgTime = time / (float)count;
  rooms += region.size();
  avgRooms = rooms / count;
  // println("Millis ("+(millis()-start)+") Rooms ("+region.size()+") Avg. Millis ("+nf(avgTime,3,2)+") Avg. Rooms ("+avgRooms+")"); 
}

void mouseReleased(){
  saveFrame("Dungeon Generation.png");  
}

void generate(){
  region = new ArrayList<Rect>();
  int px = cellcountw/(ROOMW+border);
  int py = cellcounth/(ROOMH+border);
  for (int i = 0; i  < px; i++){
    for (int j = 0; j < py; j++){
      Point p = new Point(i*(ROOMW+border), j*(ROOMH+border));
      region.add(new Rect(ROOMW,ROOMH,p));
    }
    shuffleArrayList(region);
  }
    
  //for (int i = 0; i < region.size(); i++){
  //  Rect current = region.get(i);
  //  for (int j = 0; j < region.size(); j++){
  //    if (i == j)
  //      continue;
  //    if (!region.get(j).visited && current.isInside(region.get(j))){ 
  //      region.get(i).visited = true;  
  //      break;
  //    }
  //  }
  //}
  //Iterator<Rect> it = region.iterator();
  //while(it.hasNext()){
  //  Rect r = it.next();
  //  if (r.visited)
  //    it.remove();  
  //  else {}  
  //}
}
void connect2(){
    matrix = new float[region.size()][region.size()];
  //println("{");
  for (int i = 0; i < matrix.length; i++){
    Rect r = region.get(i);
    for (int j = 0; j < matrix[i].length; j++){
      if (i == j){
        matrix[i][j] = Float.MAX_VALUE;
      } else {
        matrix[i][j] = r.distance(region.get(j)); 
      }
    }
  }
  int[][] aMatrix = new int [region.size()][region.size()];
  int root = (int)(random(region.size()));
  ArrayList<Integer> tree = new ArrayList<Integer>(region.size());
  tree.add(root);
  for (int x = 0; x < region.size()-1; x++){
    UnsortedSet<Integer> neighbours = getNeighbours(aMatrix,matrix,tree);
    if (neighbours != null){
      int child = neighbours.grab();
      int parent = -1;
      for (int i = 0; i < tree.size(); i++){
        if (matrix[child][tree.get(i)] == 5){
          parent = tree.get(i);  
          break;
        }
      }
      Edge e = new Edge(region.get(child),region.get(parent));
      aMatrix[child][parent] = 1;
      aMatrix[parent][child] = 1;
    }
  }
  
  
}
void connect(){
  matrix = new float[region.size()][region.size()];
  //println("{");
  for (int i = 0; i < matrix.length; i++){
    Rect r = region.get(i);
    for (int j = 0; j < matrix[i].length; j++){
        matrix[i][j] = r.distance(region.get(j)); 
    }
  }
  printMatrix(matrix);
  edgeSet = new SimpleGraph(region.size());
  //Define some adjacency matrix
  int[][] aMatrix = new int[region.size()][region.size()];
  /*START KRUSKAL METHOD*/
  for (int i = 0; i < region.size()-1; i++){
    for (;;){
    int[] minPos = kruskal2(aMatrix, matrix);
      Edge e = new Edge(region.get(minPos[0]), region.get(minPos[1]));
      aMatrix[minPos[0]][minPos[1]] = 1;
      aMatrix[minPos[1]][minPos[0]] = 1;
      if (!hasCycle(aMatrix)){
        edgeSet.add(e);
        break;
      } else {
        aMatrix[minPos[0]][minPos[1]] = 0;
        aMatrix[minPos[1]][minPos[0]] = 0;
      }
      matrix[minPos[0]][minPos[1]] = Float.MAX_VALUE;
      matrix[minPos[1]][minPos[0]] = Float.MAX_VALUE;
    }
  } /*END KRUKSAL METHOD*/
}

//Take in current adjacency matrix as well as weighted
//matrix. Find min of weighted not in adjacency matrix 
int[] kruskal(int[][] adj, float[][] weights){
  int minI = 0;
  int minJ = 0;
  for (int i = 0; i < weights.length; i++){
    for (int j = i; j < weights[i].length; j++){
      if (adj[i][j] == 0){
        if (weights[i][j] < weights[minI][minJ]){
          minI = i;
          minJ = j;
        }
      }
    }
  }
  int[] minPos = new int[2];
  minPos[0] = minI;
  minPos[1] = minJ;
  return minPos;
}

//Take in current adjacency matrix as well as weighted
//matrix. Find min of weighted not in adjacency matrix 
int[] kruskal2(int[][] adj, float[][] weights){
  int minI = 0;
  int minJ = 0;
  ArrayList<int[]> mins = new ArrayList<int[]>();
  for (int i = 0; i < weights.length; i++){
    for (int j = i; j < weights[i].length; j++){
      if (adj[i][j] == 0){
        if (weights[i][j] < weights[minI][minJ]){
          minI = i;
          minJ = j;
        } 
      }
    }
  }
  int[] minPos = new int[2];
  minPos[0] = minI;
  minPos[1] = minJ;
  for (int i = 0; i < weights.length; i++){
    for (int j = i; j < weights[i].length; j++){
      if (adj[i][j] == 0){
        if (weights[i][j] == weights[minI][minJ]){
          int[] temp = {i,j};
          mins.add(temp);
        } 
      }
    }
  }
  minPos = mins.get((int)random(mins.size()));
  return minPos;
}

UnsortedSet<Integer> getNeighbours(int[][] adj, float[][] weights, ArrayList<Integer> tree){
  UnsortedSet<Integer> neighbours = new UnsortedSet<Integer>();
  for (int i = 0; i < tree.size(); i++){
    for (int j = 0; j < weights[tree.get(i)].length; j++){
      if (weights[tree.get(i)][j] == 5 && adj[tree.get(i)][j] == 0){
        neighbours.add(j);
      }
    }
  }
  return neighbours;
}

//deprecated
float[][] kthMinArray(float[] arr){
  float[][] arr2 = new float[arr.length][2];
  for (int i = 0; i < arr2.length; i++){
    arr2[i][0] = arr[i];
    arr2[i][1] = i;
  }
  
  for (int i = 0; i < arr2.length-1; i++){
     // Find the minimum element in unsorted array 
     int min_idx = i; 
     for (int j = i+1; j < arr2.length; j++) 
       if (arr2[j][0] < arr2[min_idx][0]) 
         min_idx = j; 
         // Swap the found minimum element with the first 
         // element 
            float[] temp = arr2[min_idx]; 
            arr2[min_idx] = arr2[i]; 
            arr2[i] = temp; 
  }
  return arr2;
}

boolean hasCycle(int matrix[][]){
  UnsortedSet<Integer> visited = new UnsortedSet<Integer>(matrix.length);
  for (int i = 0; i < matrix.length; i++){
    if(visited.contains(i))
      continue;
    if(dfs(i, visited, -1, matrix))
      return true;
  }
  return false;
}

boolean dfs(int vertex, UnsortedSet<Integer> visited, int parent, int[][] matrix){
  visited.add(vertex);
  for (int i = 0; i < matrix.length; i++){
    if (matrix[vertex][i] == 1){
      if (i == parent)
        continue;
      if (visited.contains(i))
        return true;
      if (dfs(i, visited, vertex, matrix))
        return true;
    }
  }
  return false;
};

void shuffleArrayList(ArrayList<Rect> r){
  for(int i = 0; i < r.size(); i++){
    Rect temp = r.get(i);
    int toSwap = (int)random(i,r.size());
    r.set(i,r.get(toSwap));
    r.set(toSwap,temp);
  }
}

void printArray(float[] arr){
  print("[");
  for (int i = 0; i < arr.length-1; i++){
    print(round(arr[i])+", ");
  }
  println(round(arr[arr.length-1])+"]");
}

void printArray(int[] arr){
  print("[");
  for (int i = 0; i < arr.length; i++){
    print(arr[i]+", ");
  }
  println("]");
}

void printMatrix(int[][] arr){
  print("[");
  for(int i = 0; i < arr.length; i++)
    printArray(arr[i]);
  println("]");
}

void printMatrix(float[][] arr){
  print("[");
  for(int i = 0; i < arr.length; i++)
    printArray(arr[i]);
  println("]");
}
