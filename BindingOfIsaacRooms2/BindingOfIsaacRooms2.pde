/**
  * See README.txt for more information
*/
import java.util.ArrayList;
import java.util.Random;
import java.util.Iterator;

final int NUM_RECTS =               20;
final int CELL_SIZE =               4;
final float CHANCE_PER_EXTRA_EDGE = 0.1;
final int ROOMW =                   15;
final int ROOMH =                   10;
final int BORDER =                  5;
final int DESIRED_ROOMS =           75;

int time;
float avgTime;
int avgRooms;
int rooms;
int count;
int cellcountw;
int cellcounth;
int cellxs;
int cellys;
ArrayList<Rect> region;
float[][] matrix;
SimpleGraph edgeSet;
Random r;

//Init
void setup() {
  size(1600, 900);
  cellcountw = width / CELL_SIZE; //120
  cellcounth = height / CELL_SIZE;
  cellxs = width / cellcountw;
  cellys = height / cellcounth;
  r = new Random();
  generate();
  prim();
}

//Draw rooms and edges each frame.
void draw() {
  background(200);

  for (int i = 0; i < cellcountw; i++) {
    stroke(0);
    strokeWeight(3);
    line((i * cellxs)+CELL_SIZE/2, 0, (i * cellxs)+CELL_SIZE/2, height);
  }
  for (int i = 0; i < cellcounth; i++) {
    stroke(0);
    strokeWeight(3);
    line(0, (i * cellys)+CELL_SIZE/2, width, (i * cellys)+CELL_SIZE/2);
  }
  edgeSet.display();
  for (Rect r : region)
    r.display();
}

//Generate4 a new room and log data
void keyReleased() {
  count++;
  int start = millis();
  generate();
  prim();
  time += millis() - start;
  avgTime = time / (float)count;
  rooms += region.size();
  avgRooms = rooms / count;
  //println("Millis ("+(millis()-start)+") Rooms ("+region.size()+") Avg. Millis ("+nf(avgTime,3,2)+") Avg. Rooms ("+avgRooms+")");
}

/**
  * Export screenshot on mouse click.
*/
void mouseReleased() {
  saveFrame("Dungeon Generation.png");
}

/** 
  * Generates set of Rectangles along a grid, which are all
  * the same size, and do not overlap. 
*/
void generate() {
  region = new ArrayList<Rect>();
  int px = cellcountw/(ROOMW+BORDER);
  int py = cellcounth/(ROOMH+BORDER);
  for (int i = 0; i  < px; i++) {
    for (int j = 0; j < py; j++) {
      Point p = new Point(i*(ROOMW+BORDER), j*(ROOMH+BORDER));
      region.add(new Rect(ROOMW, ROOMH, p));
    }
    shuffleArrayList(region);
  }
}

/**
  * Generate a spanning tree using prim's algorithm.
  * Starts with an arbitrary Rect, then adds neighbours until
  * DESIRED_ROOMS is reached. Then, makes tree more densely 
  * connected with a 10% chance to add in edges between adjacent
  * members of tree.
*/
void prim() {
  matrix = new float[region.size()][region.size()];
  //println("{");
  for (int i = 0; i < matrix.length; i++) {
    Rect r = region.get(i);
    for (int j = 0; j < matrix[i].length; j++) {
      if (i == j) {
        matrix[i][j] = Float.MAX_VALUE;
      } else {
        matrix[i][j] = r.distance(region.get(j));
      }
    }
  }
  int[][] aMatrix = new int[region.size()][region.size()];
  int root = (int)(random(region.size()));
  ArrayList<Integer> tree = new ArrayList<Integer>(region.size());
  tree.add(root);
  edgeSet = new SimpleGraph(region.size());
  //println(getNeighbours(aMatrix,matrix,tree).toString());
  while (tree.size() < DESIRED_ROOMS) {
    println("Tree:"+tree);
    UnsortedSet<Integer> neighbours = getNeighbours(aMatrix, matrix, tree);
    println(neighbours.toString());
    if (neighbours != null) {
      for (int m = 0; m < neighbours.size(); m++) {
        //int child = (int)neighbours.data[m];
        int child = (int)neighbours.grab();
        println("Child: " +child);
        int parent = -1;
        for (int i = 0; i < tree.size(); i++) {
          if (matrix[child][tree.get(i)] == 5) {
            parent = tree.get(i);  
            aMatrix[child][parent] = 1;
            aMatrix[parent][child] = 1;
            if (!hasCycle(aMatrix)) {
              Edge e = new Edge(region.get(child), region.get(parent));
              edgeSet.add(e);
              tree.add(child);
              break;
            } else {
              aMatrix[child][parent] = 0;
              aMatrix[parent][child] = 0;
            }
          }
        }
        if (parent >= 0) {
          matrix[parent][child] = Float.MAX_VALUE;
          matrix[child][parent] = Float.MAX_VALUE;
          break;
        }
      }
    }
  }
  for (int i = 0; i < region.size(); i++) {
    region.get(i).visited = true;
    for (int j = 0; j < tree.size(); j++) {
      if (i == tree.get(j)) {
        region.get(i).visited = false;
        break;
      }
    }
  }
  Iterator<Rect> it = region.iterator();
  while (it.hasNext()) {
    Rect r = it.next();
    if (r.visited)
      it.remove();  
    else {
    }
  }
  matrix = new float[region.size()][region.size()];
  for (int i = 0; i < matrix.length; i++) {
    Rect r = region.get(i);
    for (int j = 0; j < matrix[i].length; j++) {
      if (i == j) {
        matrix[i][j] = Float.MAX_VALUE;
      } else {
        matrix[i][j] = r.distance(region.get(j));
        if (matrix[i][j] == 5 && random(1) < CHANCE_PER_EXTRA_EDGE){
          edgeSet.add(new Edge(region.get(i),region.get(j)));  
        }
      }
    }
  }
  
}

/**
  * Return neighbours to the current graph. A neighbour has a distance of 5, 
  * meaning that it is directly adjacent to a rect, and no edge will cross it
  * connect to its parent.
  * @param adj Adjacency matrix
  * @param weights Weighted matrix of the complete graph.
  * @param tree Current members of spanning tree.
  * @return Set of all neighbours adjacent to members of tree.
*/
UnsortedSet<Integer> getNeighbours(int[][] adj, float[][] weights, ArrayList<Integer> tree) {
  UnsortedSet<Integer> neighbours = new UnsortedSet<Integer>();
  for (int i = 0; i < tree.size(); i++) {
    for (int j = 0; j < weights[tree.get(i)].length; j++) {
      if (weights[tree.get(i)][j] == 5 && adj[tree.get(i)][j] == 0) {
        neighbours.add(j);
      }
    }
  }
  return neighbours;
}

/**
  * Uses a depth first search to look for cycles on a matrix.
  * @param matrix Graph to check.
  * @return Does this graph have cycles?
*/
boolean hasCycle(int matrix[][]) {
  UnsortedSet<Integer> visited = new UnsortedSet<Integer>(matrix.length);
  for (int i = 0; i < matrix.length; i++) {
    if (visited.contains(i))
      continue;
    if (dfs(i, visited, -1, matrix))
      return true;
  }
  return false;
}

/**
  * Perform a depth first search to look for cycles on a matrix.
  * @param vertex Current vertex of search.
  * @param visited Set of all visited vertices.
  * @param parent Parent of current vertex.
  * @param matrix Adjacency matrix of graph.
  * @return Does this graph have a cycle?
*/
boolean dfs(int vertex, UnsortedSet<Integer> visited, int parent, int[][] matrix) {
  visited.add(vertex);
  for (int i = 0; i < matrix.length; i++) {
    if (matrix[vertex][i] == 1) {
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

/**
  * Take elements of an arraylist of Rects and shuffle their order.
  * @param r ArrayList of Rect to shuffle.
*/
void shuffleArrayList(ArrayList<Rect> r) {
  for (int i = 0; i < r.size(); i++) {
    Rect temp = r.get(i);
    int toSwap = (int)random(i, r.size());
    r.set(i, r.get(toSwap));
    r.set(toSwap, temp);
  }
}

/**
  * Print an array of floats.
  * @param arr Float array to print.
*/
void printArray(float[] arr) {
  print("[");
  for (int i = 0; i < arr.length-1; i++) {
    print(round(arr[i])+", ");
  }
  println(round(arr[arr.length-1])+"]");
}

/**
  * Print an integer array.
  * @param arr Int array to print.
*/
void printArray(int[] arr) {
  print("[");
  for (int i = 0; i < arr.length; i++) {
    print(arr[i]+", ");
  }
  println("]");
}

/**
  * Take a 2D int array and print it.
  * @param arr int array to be printed.
*/
void printMatrix(int[][] arr) {
  print("[");
  for (int i = 0; i < arr.length; i++)
    printArray(arr[i]);
  println("]");
}

/**
  * Take a 2D float array and print it.
  * @param arr Float array to be printed.
*/
void printMatrix(float[][] arr) {
  print("[");
  for (int i = 0; i < arr.length; i++)
    printArray(arr[i]);
  println("]");
}
