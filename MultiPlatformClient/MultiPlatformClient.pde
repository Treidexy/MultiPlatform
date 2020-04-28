import processing.net.*; //<>// //<>// //<>// //<>//

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

  c = new Client(this, "192.168.86.23", 6969);
  //c = new Client(this, "127.0.0.1", 6969);

  surface.setTitle("Multi Platform - " + c.ip());

  player = new Player(true);

  platforms.add(new Platform(300, 600, 500, 50));
}

void draw() {
  if (c.available() > 0) {
    parseData();
  }
  
  //player.update();
  
  for (int i = 0; i < shots.size(); i++)
      shots.get(i).update();

  for (int i = 0; i < platforms.size(); i++) {
    platforms.get(i).show();
  }
  
  for (int i = 0; i < shots.size(); i++)
      shots.get(i).show();

  for (int i = 0; i < players.size(); i++) {
    if (i != id)
      players.get(i).show(i);
  }
  player.show(id);

  fill(151);
  textSize(15);
  textAlign(LEFT, TOP);
  text("FPS: " + frameRate, 0, 0);
}

void disconnect() {
  player.dispose();
  c.write("dc " + id + "\n");
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
