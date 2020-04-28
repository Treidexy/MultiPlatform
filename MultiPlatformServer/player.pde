class Player {
  final static int ADD = 1, SUB = -1;
  int x, y, health, 
    id;
  boolean isCrouching;

  Player(int id) {
    this.id = id;
  }

  void health(int operation, int value) {
    switch(operation) {
      case ADD:
        break;
      case SUB:
        health -= value;
    }
    c.write("cp " + id + " hp " + health);
  }

  void setPos(int nx, int ny) {
    x = nx;
    y = ny;
  }
}
