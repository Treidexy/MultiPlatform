import processing.net.*;

String gameMode;


PApplet instance = this;

String[] sketchArgs = { "" };
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

void settings() {
  size(1250, 800);
  noSmooth();
}

void setup() {
  frameRate(60);
  surface.setResizable(true);
  surface.setTitle("Multi Platform");
  
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

  PApplet.runSketch(sketchArgs, new homeScreen());
}

void draw() {
  if (c == null)
    background(0, 0, 0);
  else {
    surface.setTitle("Multi Platform - " + c.ip());
    if (c.available() > 0) {
      parseData();

      camera.update();

      try {
        backgroundImg.resize(width, height);
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

      fill(#cccccc);
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
  }
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
