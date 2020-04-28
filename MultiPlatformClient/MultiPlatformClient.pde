import processing.net.*; //<>//

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

  c = new Client(this, "192.168.86.140", 6969);
  //c = new Client(this, "127.0.0.1", 6969);

  surface.setTitle("Multi Platform - " + c.ip());

  player = new Player(true);

  platforms.add(new Platform(300, 600, 500, 50));
}

void draw() {
  if (c.available() > 0) {
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
        shots.add(new Shot(int(data[1]), int(data[2]), boolean(data[3]), int(data[4]), int(data[5]), true));
        break;
      case "pC":
        while (players.size() < int(data[1])) {
          players.add(new Player(false));
        }
        break;
      case "dispose":
        players.remove(int(data[1]));
        break;
      }
    }
  }
  background(100, 100, 255);
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
