class Player {
  final static int ADD = 1, SUB = -1, SET = 0;

  String username;
  int
    x, 
    y, 
    health,
    maxHealth,
    id;
  int inActiveFrames = 0;
  boolean isCrouching, facingLeft;
  
  int
    regenSpeed,
    framesSinceRegen;

  Player(int id) {
    this.id = id;

    health = 20;
    maxHealth = 20;
    regenSpeed = 98;
  }
  
  void update() {
    framesSinceRegen++;
    if (framesSinceRegen >= regenSpeed) {
      health(ADD, 1);
    }
    
    if (health >= maxHealth) {
      health(SET, maxHealth);
    }
    
    if (y > voidY)
      health(SUB, 1);
  }

  void health(int operation, int value) {
    switch(operation) {
    case ADD:
      health += value;
      break;
    case SUB:
      health -= value;
      break;
    case SET:
      health = value;
      break;
    }
    for (int l = 0; l < clients.size(); l++)
      clients.get(l).write("cp " + id + " hp " + health + "\n");
    framesSinceRegen = 0;
  }

  void setPos(int nx, int ny) {
    x = nx;
    y = ny;
  }

  void setId(int value) {
    id = value;
  }
}
