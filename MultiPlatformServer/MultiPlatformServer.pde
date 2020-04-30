import java.awt.Point;

import processing.net.*;

//
String map = "sky_map";
String gameMode = "tank_mode";
//

Server s;
Client c;
ArrayList<Client> clients = new ArrayList<Client>();
String cInput, inputs[], data[];
int framesNoFeedback = 0;

ArrayList<Player> players = new ArrayList<Player>();
int selId;

ArrayList<Shot> shots = new ArrayList<Shot>();

final boolean showErr = false;

final float
  pWidth = 50, 
  pHeight = 100, 
  pCrouchHeight = 50;
int
  screenHeight = 1250, 
  screenWidth = 800;

void setup() {
  size(500, 800);
  frameRate(60);

  s = new Server(this, 6969);

  surface.setTitle("Multi Platform | Server - " + Server.ip());
}
void draw() {
  framesNoFeedback++;      

  if (framesNoFeedback >= 60) {
    background(217);

    fill(151);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("Waiting for Players...", width/2, height/2 - 45);
    textSize(40);
    text("IP: " + Server.ip() + ":6969", width/2, height/2 + 45);
  }

  parseData();

  for (int i = 0; i < shots.size(); i++)
    shots.get(i).update();
}

void serverEvent(Server server, Client client) {
  try {
    clients.add(client);
    client.write("id " + (clients.size() - 1) + "\n");
    client.write("setting " + map + " " + gameMode + "\n");

    players.add(new Player(clients.size() - 1));

    for (int i = 0; i < clients.size(); i++) {
      if (clients.get(i).active())
        clients.get(i).write("pc " + clients.size() + "\n");
    }

    while (clients.size() > 4) {
      disposeClient(clients.size() - 1);
    }
  } 
  catch (Exception e) {
    if (showErr)
      System.err.println(e);
  }
}

void disposeClient(int id) {
  clients.remove(id);
  players.remove(id);

  for (int l = 0; l < clients.size(); l++) {
    clients.get(l).write("id " + l + "\n");
    clients.get(l).write("dc " + id + "\n");
    players.get(l).setId(l);
  }
}
