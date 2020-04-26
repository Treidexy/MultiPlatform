ArrayList<Shot> shots = new ArrayList<Shot>();

class Player {
  PVector position = new PVector(625, 400);

  final PVector gravity = new PVector(0, 1);
  PVector acceleration = new PVector(0, 0);
  boolean myPlayer;
  float jumpHeight = 20;
  float speed = 5;
  final int _height = 100;
  final int _width = 50;
  final int highestY;

  Player(boolean _myPlayer) {
    myPlayer = _myPlayer;
    highestY = height - _height;
  }

  void show() {
    noFill();
    if (myPlayer) stroke(0, 255, 0);
    else stroke(255, 0, 0);
    
    rect(position.x, position.y, _width, _height);
    for(int i = 0; i < shots.size(); i++) shots.get(i).show();
  }

  void update() {
    if (isJump)jump();
    acceleration.add(gravity);
    if (PVector.add(position, acceleration).y < highestY) position.add(acceleration); 
    else {
      position.y = highestY;
      acceleration = new PVector(0, 0);
    }

    if (isA) position.x-= speed;
    if (isD) position.x+= speed;
    
    for(int i = 0; i < shots.size(); i++) shots.get(i).update();
  }

  void jump() {
    println("jumped");
    if (position.y >= highestY) acceleration.add(new PVector(0, -jumpHeight));
  }

  void newPos(float x, float y) {
    position = new PVector(x, y);
  }
  
  void newShot(boolean facingLeft) {
    shots.add(new Shot(0, facingLeft, (int) position.x, (int) position.y));
  }
}

boolean isA, isD, isJump, isLeft, isRight; 

void keyPressed() {
  if(keyCode == LEFT) player.newShot(true);
  else if(keyCode == RIGHT) player.newShot(false);
  else setMove(keyCode, true);
}

void keyReleased() {
  setMove(keyCode, false);
}

boolean setMove(int k, boolean b) {
  switch (k) {
  //case LEFT:
  //  return isLeft = b;

  //case RIGHT:
  //  return isRight = b;

  case 65:
    return isA = b;

  case 68:
    return isD = b;

  case 32:
    return isJump = b;

  case 87:
    return isJump = b;

  default:
    println(keyCode);
    return b;
  }
}
