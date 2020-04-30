import processing.net.*;

Client c;
String cInput, input[], data[]; 
int id;

Player player;
Camera camera;
ArrayList<Player> players = new ArrayList<Player>();
ArrayList<Shot> shots = new ArrayList<Shot>();
ArrayList<Platform> platforms = new ArrayList<Platform>();

PImage shot_left, shot_right;
PImage[][] playerSprites = new PImage[4][2];

HashMap<String, Integer> maps = new HashMap<String, Integer>();

PImage backgroundImg;
PImage[]
  sky_map = new PImage[2], 
  hell_map = new PImage[2], 
  land_map = new PImage[2];

boolean mouseLock;

void setup() {
  size(1250, 800);
  frameRate(60);
  noSmooth();

  //Shot sprites
  shot_left = loadImage("assets/shot/shot_left.png");
  shot_right = loadImage("assets/shot/shot_right.png");

  //Player sprites
  playerSprites[0][0] = loadImage("assets/player/red_player_left.png");
  playerSprites[0][1] = loadImage("assets/player/red_player_right.png");

  playerSprites[1][0] = loadImage("assets/player/blue_player_left.png");
  playerSprites[1][1] = loadImage("assets/player/blue_player_right.png");

  playerSprites[2][0] = loadImage("assets/player/green_player_left.png");
  playerSprites[2][1] = loadImage("assets/player/green_player_right.png");

  playerSprites[3][0] = loadImage("assets/player/pink_player_left.png");
  playerSprites[3][1] = loadImage("assets/player/pink_player_right.png");

  //Maps
  //Sky
  sky_map[0] = loadImage("assets/sky_map/background.png");
  sky_map[1] = loadImage("assets/sky_map/platform.png");
  //Hell
  hell_map[0] = loadImage("assets/hell_map/background.png");
  hell_map[1] = loadImage("assets/hell_map/platform.png");
  //Land
  land_map[0] = loadImage("assets/land_map/background.png");
  land_map[1] = loadImage("assets/land_map/platform_large.png");

  //c = new Client(this, "192.168.86.23", 6969);
  c = new Client(this, "127.0.0.1", 6969);

  surface.setTitle("Multi Platform - " + c.ip());

  player = new Player(true);
  camera = new Camera();
}

void draw() {
  //try {
  if (c.available() > 0) {
    parseData();
  }

  background(100, 100, 255);

  camera.update();

  try {
    background(backgroundImg);
  } 
  catch (Exception e) {
  }

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

  player.update();

  if (player.position.y > height); 
  else
    camera.focus(player.position);

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
  text("FPS: " + frameRate, camera.location.x, camera.location.y);

  fill(#ff0000);
  textSize(15);
  textAlign(RIGHT, TOP);
  text("HP: " + player.health, camera.location.x + width, camera.location.y);

  //noStroke();
  //fill(0);
  //rect(camera.location.x, 800, width, height);
}

void disconnect() {
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
class Camera {
  PVector location, wantLocation, velocity, acceleration;
  float shakiness = 1;
  
  public Camera() {
    location = new PVector();
    wantLocation = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
  }
  
  void focus(float fx, float fy) {
    wantLocation = new PVector(fx, fy);
  }
  
  void focus(PVector focus) {
    wantLocation = focus;
  }
  
  void update() {
    acceleration = PVector.sub(new PVector(wantLocation.x - width/2, wantLocation.y - height/2), location);
    
    velocity.add(acceleration);
    velocity.limit(shakiness);
    
    location.add(acceleration);
    
    translate(-location.x, -location.y);
  }
}
//
class Map {
  PImage background;
  Platform[] platforms;
  
  Map(PImage background, Platform[] platforms) {
    this.background = background;
    this.platforms = platforms;
  }
}

void initMap(String mapId) {
  switch(mapId) {
    case "sky_map":
      backgroundImg = sky_map[0];
      platforms.add(new Platform(300, 700, 400, 50, sky_map[1]));
      platforms.add(new Platform(800, 500, 400, 50, sky_map[1]));
      platforms.add(new Platform(250, 450, 400, 50, sky_map[1]));
      platforms.add(new Platform(650, 300, 400, 50, sky_map[1]));
      break;
    case "hell_map":
     backgroundImg = hell_map[0];
      platforms.add(new Platform(300, 500, 500, 50, hell_map[1]));
      platforms.add(new Platform(50, 250, 400, 50, hell_map[1]));
      platforms.add(new Platform(600, 700, 500, 50, hell_map[1]));
      platforms.add(new Platform(900, 250, 400, 50, hell_map[1]));
      break;
    case "land_map":
      backgroundImg = land_map[0];
      platforms.add(new Platform(0, 700, 1250, 50, land_map[1]));
      break;
  }
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
      case "map":
        initMap(data[1]);
        break;
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
  PImage img;

  int w, h;

  Platform(float x, float y, int w, int h, PImage img) {
    this.img = img;
    this.w = w;
    this.h = h;
    
    position = new PVector(x, y);
  }

  void show() {
    noFill();
    stroke(0, 0, 255);
    rect(position.x, position.y, w, h);
    
    img.resize(w, h);
    image(img, position.x, position.y);
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
    isCrouching, 
    pCrouching;
  float
    maxSpeed = 50, 
    jumpHeight = 20,
    bounceHeight = 5,
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
    highestY = height * 2;
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

    millisSinceReload = millis() - pastMillis;

    if (isA) {
      position.x-= speed;
      facingLeft = true;
    }
    if (isD) {
      position.x+= speed;
      facingLeft = false;
    }
    
    //if (mousePressed)
    //  player.shoot(mouseX, mouseY);

    if (health <= 0)
      die();
    if (position.y > highestY)
      health--;

    if (isCrouching) {
      _height = crouchHeight;
    } else {
      _height = normHeight;
    }
    if (pCrouching == true && isCrouching == false) {
      unCrouch();
    }

    acceleration.add(gravity);
    acceleration.limit(maxSpeed);

    for (int i = 0; i < acceleration.y; i++) {
      checkForPlatforms(position.x, position.y + i);
    }

    position.add(acceleration);

    pCrouching = isCrouching;
  }

  void checkForPlatforms(PVector position) {
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

  void unCrouch() {
    position.add(0, crouchHeight - normHeight);
    //acceleration.add(0, -bounceHeight);
    acceleration.y = 0;
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

  void shoot(float dx, float dy) {
    if (millisSinceReload >= reloadMillis) {
      if (dx < width / 2) {
        facingLeft = true;
        shots.add(new Shot(id, int(shotDamage), facingLeft, int(position.x), int(position.y + _height/4)));
        sendShot(true);
        pastMillis = millis();
      } else {
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
    println("dead");
    exit();
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
