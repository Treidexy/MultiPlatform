import processing.net.*; //<>//

Client c;
String cInput, input[], data[]; 
int id;

Player player;
ArrayList<Player> players = new ArrayList<Player>();

void setup() {
  size(1250, 800);
  frameRate(60);

  c = new Client(this, "192.168.86.140", 6969);

  surface.setTitle("Multi Platform - " + c.ip());

  player = new Player(true);
}

void draw() {
  if (c.available() > 0) {
    background(100, 100, 255);

    cInput = c.readString(); 
    input = cInput.split("\n");
    data = split(input[0], ' ');

    println("c" + id, cInput);

    if (data[0].equals("id")) {
      id = Integer.valueOf(data[1]);
    }

    player.update();

    c.write(id + " " + player.position.x + " " + player.position.y);

    for (int i = 0; i < input.length; i++) {
      data = split(input[i], ' ');

      switch(data[0]) {
      case "c":
        if (data[1].equals(String.valueOf(id))) {
        } else {
          players.get(int(data[1])).newPos(float(data[2]), float(data[3]));
        }
        break;
      case "pC":
        while (players.size() < int(data[1]) - 1) {
          players.add(new Player(false));
        }
        break;
      }
    }
  }
  for (int i = 0; i < players.size(); i++) {
    players.get(i).show();
  }
  player.show();
}

void disconnectEvent(Client client) {
  player.disconnect();
}
