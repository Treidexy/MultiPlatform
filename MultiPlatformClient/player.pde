class Player {
  int playerId;

  PVector position;
  float health = 20;
  boolean facingLeft;

  final PVector gravity;
  PVector
    acceleration, 
    desPos;
  boolean
    myPlayer, 
    isCrouching, 
    pCrouching;
  float
    maxSpeed, 
    jumpHeight, 
    bounceHeight, 
    speed, 
    normSpeed, 
    crouchSpeed;
  final int
    crouchHeight, 
    normHeight;
  int
    _height = 100, 
    _width = 50, 
    _rwidth = 80, 
    highestY, 
    framesSinceLastCrouch = 0;
  float
    shotDamage, 
    reloadMillis, 
    pastMillis, 
    millisSinceReload;

  Player(boolean _myPlayer) {
    myPlayer = _myPlayer;
    highestY = height * 2;
    crouchHeight = 50;
    normHeight = 100;

    if (gameMode.equals("pro_gamer_mode")) {
      maxSpeed = 50;
      jumpHeight = 25;
      bounceHeight = 15;
      normSpeed = 7;
      crouchSpeed = 3;

      shotDamage = 1;
      reloadMillis = 500;
    } else if (gameMode.equals("tank_mode")) {
      maxSpeed = 50;
      jumpHeight = 10;
      bounceHeight = 2.5;
      normSpeed = 3;
      crouchSpeed = 0;

      shotDamage = 4;
      reloadMillis = 1200;
    } else {
      maxSpeed = 50;
      jumpHeight = 20;
      bounceHeight = 5;
      normSpeed = 5;
      crouchSpeed = 1;

      shotDamage = 2;
      reloadMillis = 800;
    }

    position = new PVector(625, 400);
    gravity = new PVector(0, 1);
    acceleration = new PVector(0, 0);
    desPos = new PVector();

    pastMillis = millis();
  }

  void show() {
    if (facingLeft) image(playerSprites[playerId][0], position.x - _width/2, position.y, _rwidth, _height);
    else image(playerSprites[playerId][1], position.x, position.y, _rwidth, _height);

    noFill();
    if (myPlayer)
      stroke(0, 255, 0);
    else
      stroke(255, 0, 0);

    rect(position.x, position.y, _width, _height);

    healthBar();
  }

  void healthBar() {
    int healthBarWidth = (int) map(health, 0, 20, 0, _width);

    noStroke();
    fill(#ff0000);
    rect(position.x + healthBarWidth, position.y - 15, _width - healthBarWidth, 10);

    fill(#00ff00);
    rect(position.x, position.y - 15, healthBarWidth, 10);
  }

  void update() {
    checkShot();

    millisSinceReload = millis() - pastMillis;

    if (isA) {
      facingLeft = true;
      if (isCrouching) 
        for (int i = 0; i < platforms.size(); i++) 
          if (position.y + _height == platforms.get(i).position.y) {
            if (position.x + _width >= platforms.get(i).position.x && position.x - 1 + _width < platforms.get(i).position.x + crouchSpeed)
              position.x+= speed;
            break;
          }
      position.x-= speed;
    }
    if (isD) {
      facingLeft = false;
      if (isCrouching) 
        for (int i = 0; i < platforms.size(); i++) 
          if (position.y + _height == platforms.get(i).position.y) {
            if (position.x + 1 >= platforms.get(i).position.x + platforms.get(i).w && position.x < platforms.get(i).position.x + platforms.get(i).w + crouchSpeed)
              position.x-= speed;
            break;
          }
      position.x+= speed;
    }

    if (health <= 0)
      die();
    if (position.y > highestY)
      health--;

    if (isCrouching) {
      _height = crouchHeight;
      speed = crouchSpeed;
    } else {
      _height = normHeight;
      speed = normSpeed;
    }
    if (pCrouching == true && isCrouching == false) {
      unCrouch();
    } 
    if (pCrouching == false && isCrouching == true) {
      crouch();
    }

    acceleration.add(gravity);
    acceleration.limit(maxSpeed);

    for (int i = 0; i < acceleration.y; i++)
      checkForPlatforms(position.x, position.y + i);

    position.add(acceleration);

    pCrouching = isCrouching;

    if (framesSinceLastCrouch < 10) framesSinceLastCrouch++;
  }

  void checkForPlatforms(PVector position) {
    for (int i = 0; i < platforms.size(); i++) {
      Platform _plat = platforms.get(i);

      if (isCrouching) {
        if (position.y + _height >= _plat.position.y &&
          position.y + _height < _plat.position.y + _plat.h/2 &&
          position.x > _plat.position.x + _plat.w) {
          position.x--;
        } else if (position.y + _height >= _plat.position.y &&
          position.y + _height < _plat.position.y + _plat.h/2 &&
          position.x - _width < _plat.position.x + _plat.w) {
          position.x++;
        }
      }

      if (position.y + _height >= _plat.position.y &&
        position.y + _height < _plat.position.y + _plat.h/2 &&
        position.x < _plat.position.x + _plat.w &&
        position.x + _width > _plat.position.x) {
        acceleration.y = 0;
        if (isJump)jump();
        position.y = _plat.position.y - _height;
      } else if (position.y + _height > _plat.position.y &&
        position.y < _plat.position.y + _plat.h) {
        if (position.x + _width > _plat.position.x &&
          position.x < _plat.position.x) {
          position.x = _plat.position.x - _width;
        } else {
          if (position.x + _width > _plat.position.x + _plat.w &&
            position.x < _plat.position.x + _plat.w) {
            position.x = _plat.position.x + _plat.w;
          }
        }
      }
    }
  }

  void checkForPlatforms(float x, float y) {
    PVector position = new PVector(x, y);
    for (int i = 0; i < platforms.size(); i++) {
      Platform _plat = platforms.get(i);

      if (position.y + _height >= _plat.position.y &&
        position.y + _height < _plat.position.y + _plat.h/2 &&
        position.x < _plat.position.x + _plat.w &&
        position.x + _width > _plat.position.x) {
        acceleration.y = 0;
        if (isJump)jump();
        position.y = _plat.position.y - _height;
      } else if (position.y + _height > _plat.position.y &&
        position.y < _plat.position.y + _plat.h) {
        if (position.x + _width > _plat.position.x &&
          position.x < _plat.position.x) {
          position.x = _plat.position.x - _width;
        } else {
          if (position.x + _width > _plat.position.x + _plat.w &&
            position.x < _plat.position.x + _plat.w) {
            position.x = _plat.position.x + _plat.w;
          }
        }
      }
    }
  }

  void jump() {
    acceleration.add(0, -jumpHeight);
  }

  void setPos(float x, float y) {
    position = new PVector(x, y);
  }

  void setPos(PVector newPos) {
    position = newPos;
  }

  void setId(int value) {
    playerId = value;
  }

  void crouch() {
    if (isDown);
    position.add(0, normHeight - crouchHeight);
  }

  void unCrouch() {
    if (!isDown && framesSinceLastCrouch == 10)
      position.add(0, crouchHeight - normHeight);
    acceleration.add(0, -bounceHeight);
    acceleration.y = 0;
    framesSinceLastCrouch = 0;
  }

  void checkShot() {
    if (!isCrouching)
      if (millisSinceReload >= reloadMillis) {
        if (isLeft) {
          facingLeft = true;
          shots.add(new Shot(id, int(shotDamage), facingLeft, int(position.x), int(position.y + _height/4)));
          sendShot(true);
          pastMillis = millis();
        } else if (isRight) {
          facingLeft = false;
          shots.add(new Shot(id, int(shotDamage), facingLeft, int(position.x), int(position.y + _height/4)));
          sendShot(false);
          pastMillis = millis();
        }
      }
  }

  void sendShot(boolean facingLeft) {
    c.write("shot " + id + " " + int(shotDamage) + " " + facingLeft + " " + int(position.x) + " " + int(position.y + _height/4) + "\n");
  }

  void die() {
    exit();
  }
}

boolean isA, isD, isJump, isDown, isLeft, isRight; 

void keyPressed() {
  setMove(keyCode, true);
}

void keyReleased() {
  setMove(keyCode, false);
}

boolean setMove(int k, boolean b) {
  switch (k) {
  case LEFT:
    return isLeft = b;

  case RIGHT:
    return isRight = b;

  case 65:
    return isA = b;

  case 68:
    return isD = b;

  case 83:
    return isDown = b;

  case 32:
    return isJump = b;

  case 87:
    return isJump = b;

  case 16:
    return player.isCrouching = b;

  default:
    return b;
  }
}
