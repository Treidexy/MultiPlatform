import processing.net.*;

Client c;
String cInput, input[], data[]; 
int id;

Player player;
ArrayList<Player> players = new ArrayList<Player>();
ArrayList<Shot> shots = new ArrayList<Shot>();
ArrayList<Platform> platforms = new ArrayList<Platform>();

PImage shot_left, shot_right;
PImage[][] playerSprites = new PImage[4][2];

void setup() {
  size(1250, 800);
  frameRate(60);
  noSmooth();

  shot_left = loadImage("assets/shot_left.png");
  shot_right = loadImage("assets/shot_right.png");

  playerSprites[0][0] = loadImage("assets/red_player_left.png");
  playerSprites[0][1] = loadImage("assets/red_player_right.png");

  playerSprites[1][0] = loadImage("assets/blue_player_left.png");
  playerSprites[1][1] = loadImage("assets/blue_player_right.png");

  playerSprites[2][0] = loadImage("assets/green_player_left.png");
  playerSprites[2][1] = loadImage("assets/green_player_right.png");

  playerSprites[3][0] = loadImage("assets/pink_player_left.png");
  playerSprites[3][1] = loadImage("assets/pink_player_right.png");

  //c = new Client(this, "192.168.86.23", 6969);
  c = new Client(this, "127.0.0.1", 6969);

  surface.setTitle("Multi Platform - " + c.ip());

  player = new Player(true);

  platforms.add(new Platform(300, 600, 500, 50));
}

void draw() {
  //try {
  if (c.available() > 0) {
    parseData();
  }

  background(100, 100, 255);

  for (int i = 0; i < shots.size(); i++)
    shots.get(i).update();

  for (int i = 0; i < platforms.size(); i++) {
    platforms.get(i).show();
  }

  for (int i = 0; i < shots.size(); i++) {
    shots.get(i).show();
  }

  for (int i = 0; i < players.size(); i++) {
    if (i != id)
      players.get(i).show();
  }

  //camera.update();

  player.update();

  c.write(id + " " + int(player.position.x) + " " + int(player.position.y) + " " + player.isCrouching + " " + player.facingLeft + "\n");

  player.setId(id);
  player.show();
  //} 
  //catch (Exception e) {
  //  fill(151);
  //  textSize(15);
  //  textAlign(CENTER, CENTER);
  //  text("Error compiling", width/2, height/2);
  //  print("~");
  //}

  fill(151);
  textSize(15);
  textAlign(LEFT, TOP);
  text("FPS: " + frameRate, 0, 0);

  fill(151);
  textSize(15);
  textAlign(RIGHT, TOP);
  text("HP: " + player.health, width, 0);
}

void disconnect() {
  player.dispose();
  c.write("dc " + id + "\n");
}

void exit() {
  try {
    disconnect();
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

    //println(cInput);

    if (data[0].equals("id")) {
      id = Integer.valueOf(data[1]);
    }

    for (String in : input) {
      data = split(in, ' ');

      switch(data[0]) {
      case "c":
        if (data[1].equals(String.valueOf(id))) {
          players.get(int(data[1])).setPos(float(data[2]), float(data[3]));
        } else {
          while (players.get(int(data[1])) == null)
            players.add(new Player(false));
          players.get(int(data[1])).setPos(float(data[2]), float(data[3]));
          players.get(int(data[1])).isCrouching = boolean(data[5]);
          players.get(int(data[1])).facingLeft = boolean(data[6]);
        }
        break;
      case "cp":
        println(1);
        if (data[1].equals(String.valueOf(id))) {
          println(2);
          switch(data[2]) {
          case "hp":
            player.health = int(data[3]);
            println(in, player.health, int(data[3]));
            break;
          }
        }
        break;
      case "shot":
        shots.add(new Shot(int(data[1]), int(data[2]), boolean(data[3]), int(data[4]), int(data[5])));
        break;
      case "pc":
        for (int j = players.size(); j  < int(data[1]); j++) {
          players.add(new Player(false));
          players.get(j).setId(j);
        }
        break;
      case "dc":
        players.remove(int(data[1]));
        break;
      }
    }
  } 
  catch (Exception e) {
    e.getCause();
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
    isCrouching;
  float
    smoothness = 0.69, 
    jumpHeight = 20, 
    speed = 5;
  final int
    crouchHeight, 
    normHeight;
  int
    _height = 100, 
    _width = 50, 
    _rwidth = 80, 
    highestY;
  float
    shotDamage = 3, 
    reloadMillis = 500, 
    pastMillis, 
    millisSinceReload;

  Player(boolean _myPlayer) {
    myPlayer = _myPlayer;
    highestY = height - _height;
    crouchHeight = 50;
    normHeight = 100;

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
  }

  void update() {
    checkShot();
    highestY = height - _height;

    millisSinceReload = millis() - pastMillis;

    if (isA) {
      position.x-= speed;
      facingLeft = true;
    }
    if (isD) {
      position.x+= speed;
      facingLeft = false;
    }

    if (isCrouching) {
      _height = crouchHeight;
    } else {
      _height = normHeight;
    }

    checkForPlatforms();

    acceleration.add(gravity);

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

  void setId(int value) {
    playerId = value;
  }

  void crouchChange() {
  }

  void checkShot() {
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

  void dispose() {
    //if (myPlayer)
    //  ;
    //else {
    //  players.remove(this);
    //}
  }

  //void takeDamage(float damage) {
  //  health-= damage;
  //  if (health <= 0)
  //    die();
  //}

  void die() {
    println("dead");
  }
}

boolean isA, isD, isJump, isLeft, isRight; 

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

  case 32:
    return isJump = b;

  case 87:
    return isJump = b;
  case 16:
    return player.isCrouching = b;

  default:
    //println(keyCode);
    return b;
  }
}
//
class Shot {
  boolean facingLeft;
  int playerSender, 
    damage, 
    x, 
    y, 
    w, 
    h, 
    rw, 
    rh, 
    speed;

  Shot(int playerSender, int damage, boolean facingLeft, int x, int y) {
    this.playerSender = playerSender;
    this.damage = damage;
    this.facingLeft = facingLeft;
    this.x = x;
    this.y = y;
    w = 48;
    h = 16;
    rw = 96;
    rh = 16;
    speed = 6;
  }

  void show() {
    noFill();
    stroke(255, 0, 0);
    rect(x, y, w, h);

    if (facingLeft)
      image(shot_left, x, y, rw, rh);
    else
      image(shot_right, x - w, y, rw, rh);
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
      if (collidingWithPlayer(players.get(i)) && i != playerSender) {
        shots.remove(this);
      }
  }

  boolean collidingWithPlayer(Player _p) {
    if (x + w > _p.position.x && x < _p.position.x + _p._width && y + h > _p.position.y && y < _p.position.y + _p._height)
      return true;
    return false;
  }
}
