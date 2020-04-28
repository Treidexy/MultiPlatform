import processing.net.*;

Client c;
String cInput, input[], data[]; 
int id;

Player player;
ArrayList<Player> players = new ArrayList<Player>();
ArrayList<Shot> shots = new ArrayList<Shot>();
ArrayList<Platform> platforms = new ArrayList<Platform>();

PImage shot_left, shot_right;

void setup() {
  size(1250, 800);
  frameRate(60);

  shot_left = loadImage("assets/shot_left.png");
  shot_right = loadImage("assets/shot_right.png");

  //c = new Client(this, "192.168.86.140", 6969);
  c = new Client(this, "127.0.0.1", 6969);

  surface.setTitle("Multi Platform - " + c.ip());

  player = new Player(true);

  platforms.add(new Platform(300, 600, 500, 50));
}

void draw() {
  if (c.available() > 0) {
    parseData();
  }
  
  for (int i = 0; i < platforms.size(); i++) {
    platforms.get(i).show();
  }
  
  for (int i = 0; i < players.size(); i++) {
    if (i != id)
      players.get(i).show();
  }
  player.show();

  fill(151);
  textSize(15);
  textAlign(LEFT, TOP);
  text("FPS: " + frameRate, 0, 0);
}

void disconnect() {
  player.dispose();
  c.write("dispose " + id + "\n");
}

void exit() {
  disconnect();
  try {
    Thread.sleep(50);
  } 
  catch (Exception e) {
  }
  super.exit();
}
//
void parseData() {
  try {
    cInput = c.readString(); 
    input = cInput.split("\n");
    data = split(input[0], ' ');

    //println("c" + id, cInput);

    if (data[0].equals("id")) {
      id = Integer.valueOf(data[1]);
    }

    //camera.update();

    player.update();

    c.write(id + " " + player.position.x + " " + player.position.y + "\n");
    background(100, 100, 255);
    for (int i = 0; i < input.length; i++) {
      data = split(input[i], ' ');

      switch(data[0]) {
      case "c":
        if (data[1].equals(String.valueOf(id))) {
          players.get(int(data[1])).setPos(float(data[2]), float(data[3]));
        } else {
          players.get(int(data[1])).setPos(float(data[2]), float(data[3]));
        }
        break;
      case "shot":
        shots.add(new Shot(int(data[1]), int(data[2]), boolean(data[3]), int(data[4]), int(data[5])));
        break;
      case "pC":
        while (players.size() <= int(data[1])) {
          players.add(new Player(false));
        }
        break;
      case "dispose":
        players.remove(int(data[1]));
        break;
      }
    }
  } 
  catch (Exception e) {
    System.err.println(e);
  }
}
//
class Platform {
  PVector position;
  
  float w, h;
  
  Platform(float x, float y, float _w, float _h) {
    position = new PVector(x, y);
    w = _w;
    h = _h;
  }
  
  void show() {
    noFill();
    stroke(0, 0, 255);
    rect(position.x, position.y, w, h);
  }
}
//
class Player {
  PVector position;
  float health = 20;

  final PVector gravity;
  PVector acceleration, 
    desPos;
  boolean myPlayer;
  float smoothness = 0.69, 
    jumpHeight = 30,
    speed = 5;
  final int _height = 100, 
    _width = 50, 
    highestY;
  float shotDamage = 3, 
    reloadFrames = 60, 
    pastFramesSinceReload = 0;

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
    pastFramesSinceReload++;

    if (isA)
      position.x-= speed;
    if (isD)
      position.x+= speed;

    checkForPlatforms();

    acceleration.add(gravity);

    for (int i = 0; i < shots.size(); i++)
      shots.get(i).update();

    position.add(acceleration);
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
    acceleration.add(new PVector(0, -jumpHeight));
  }

  void setPos(float x, float y) {
    position = new PVector(x, y);
  }

  void setPos(PVector newPos) {
    position = newPos;
  }

  void newShot(boolean facingLeft) {
    if (pastFramesSinceReload >= reloadFrames) {
      shots.add(new Shot(0, (int) shotDamage, facingLeft, (int) position.x, (int) position.y));
      pastFramesSinceReload = 0;
    }
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
  if (keyCode == LEFT)
    player.newShot(true);
  else if (keyCode == RIGHT)
    player.newShot(false);

  else
    setMove(keyCode, true);
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
    //println(keyCode);
    return b;
  }
}
//
class Shot {
  boolean facingLeft;
  int player, 
    damage, 
    x, 
    y, 
    w, 
    h, 
    speed;

  Shot(int player, int damage, boolean facingLeft, int x, int y) {
    this.player = player;
    this.damage = damage;
    this.facingLeft = facingLeft;
    this.x = x;
    this.y = y;
    w = 50;
    h = 15;
    speed = 6;
    
    update();
    update();
    update();
    c.write("shot " + player + " " + damage + " " + facingLeft + " " + x + " " + y + "\n");
  }

  void show() {
    noFill();
    stroke(255, 0, 0);
    rect(x, y, w, h);

    if (facingLeft)
      image(shot_left, x, y);
    else
      image(shot_right, x, y);
  }

  void update() {
    if (facingLeft)
      x-= speed;
    else
      x+= speed;

    if (x < -w)
      shots.remove(this);
    if (x > width)
      shots.remove(this);

    for (int i = 0; i < players.size(); i++)
      if (collidingWithPlayer(players.get(i)) && i != id) {
        players.get(i).takeDamage(damage);
        shots.remove(this);
      }
  }

  boolean collidingWithPlayer(Player _p) {
    if (x + w > _p.position.x && x < _p.position.x + _p._width && y + h > _p.position.y && y < _p.position.y + _p._height) return true;
    return false;
  }
}
