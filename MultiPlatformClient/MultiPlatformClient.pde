import processing.net.*; //<>// //<>// //<>// //<>//

Client c;
String cInput, input[], data[]; 
int id;

Player player;
ArrayList<Player> players = new ArrayList<Player>();
ArrayList<Shot> shots = new ArrayList<Shot>();

//Platform testPlat;
ArrayList<Platform> platforms = new ArrayList<Platform>();

void setup() {
  size(1250, 800);
  frameRate(60);

  c = new Client(this, "192.168.86.140", 6969);
  //c = new Client(this, "localhost", 6969);

  surface.setTitle("Multi Platform - " + c.ip());

  player = new Player(true);

  platforms.add(new Platform(300, 600, 500, 50));
}

void draw() {
  println(players.size());
  if (c.available() > 0) {
    cInput = c.readString(); 
    input = cInput.split("\n");
    data = split(input[0], ' ');

    println("c" + id, cInput);

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
        } else {
          players.get(int(data[1])).setPos(float(data[2]), float(data[3]));
        }
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
  background(100, 100, 255);
  for (int i = 0; i < platforms.size(); i++) {
    platforms.get(i).show();
  }
  for (int i = 0; i < players.size(); i++) {
    players.get(i).show();
  }
  player.show();
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
