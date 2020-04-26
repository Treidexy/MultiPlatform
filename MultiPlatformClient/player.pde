class Player {
  PVector position;
  float health = 20;

  final PVector gravity;
  PVector acceleration, desPos;
  boolean myPlayer;
  float smoothness = 0.69;
  float jumpHeight = 20;
  float speed = 5;
  final int _height = 100;
  final int _width = 50;
  final int highestY;
  float shotDamage = 3;

  Player(boolean _myPlayer) {
    myPlayer = _myPlayer;
    highestY = height - _height;

    position = new PVector(625, 400);
    gravity = new PVector(0, 1);
    acceleration = new PVector(0, 0);
    desPos = new PVector();
  }

  void show() {
    noFill();
    if (myPlayer)
      stroke(0, 255, 0);
    else
      stroke(255, 0, 0);

    rect(position.x, position.y, _width, _height);
    for (int i = 0; i < shots.size(); i++)
      shots.get(i).show();
  }

  void update() {
    if (isA)
      position.x-= speed;
    if (isD)
      position.x+= speed;

    checkForPlatforms();

    acceleration.add(gravity);

    for (int i = 0; i < shots.size(); i++)
      shots.get(i).update();

    desPos = PVector.add(acceleration, position);

    position = PVector.lerp(position, desPos, smoothness);
  }

  void checkForPlatforms() {
    for (int i = 0; i < platforms.size(); i++) {
      Platform _plat = platforms.get(i);

      if (position.y + _height >= _plat.position.y &&
        position.y + _height < _plat.position.y + _plat.h/2 &&
        position.x < _plat.position.x + _plat.w &&
        position.x + _width > _plat.position.x) {
        acceleration.y = 0;
        if (isJump)jump();
        position.y = _plat.position.y - _height;
      }

      //if (position.x + _width > _plat.position.x && 
      //  position.x < _plat.position.x + _plat.w && 
      //  position.y + _height > _plat.position.y && 
      //  position.y < _plat.position.y + _plat.h) {

      //  if (position.x < _plat.position.x + _plat.w/2) position.x = _plat.position.x - _width;
      //  else position.x = _plat.position.x + _plat.w;
      //}
    }
  }

  void jump() {
    acceleration.add(new PVector(0, -jumpHeight));
  }

  void setPos(float x, float y) {
    position = new PVector(x, y);
  }

  void setPos(PVector newPos) {
    position = newPos;
  }

  void newShot(boolean facingLeft) {
    shots.add(new Shot(0, shotDamage, facingLeft, (int) position.x, (int) position.y));
  }

  void dispose() {
    if (myPlayer)
      ;
    else {
      players.remove(this);
    }
  }

  void takeDamage(float damage) {
    health-= damage;
    if (health <= 0)
      die();
  }

  void die() {
    println("dead");
  }
}

boolean isA, isD, isJump, isLeft, isRight; 

void keyPressed() {
  if (keyCode == LEFT) player.newShot(true);
  else if (keyCode == RIGHT) player.newShot(false);
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
