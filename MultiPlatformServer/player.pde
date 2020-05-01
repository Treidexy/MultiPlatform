class Player {
  final static int ADD = 1, SUB = -1;
  int
    x, 
    y, 
    health, 
    id;
  int inActiveFrames = 0;
  boolean isCrouching, facingLeft;

  Player(int id) {
    this.id = id;

    health = 20;
  }

  void health(int operation, int value) {
    switch(operation) {
    case ADD:
      health += value;
      break;
    case SUB:
      health -= value;
      break;
    }
    for (int l = 0; l < clients.size(); l++)
      clients.get(l).write("cp " + id + " hp " + health + "\n");
    //println("OUT:", "cp " + id + " hp " + health + "\n");
  }

  void setPos(int nx, int ny) {
    x = nx;
    y = ny;
  }

  void setId(int value) {
    id = value;
  }
}
