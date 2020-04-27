import java.awt.Point;

import processing.net.*;

Server s;
Client c;
ArrayList<Client> clients = new ArrayList<Client>();
String cInput, input[], data[];
int framesNoFeedback = 0;

ArrayList<Point> players = new ArrayList<Point>();

ArrayList<Shot> shots = new ArrayList<Shot>();

final boolean showErr = false;

final float
  pWidth = 100, 
  pHeight = 50;

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
    textSize(35);
    textAlign(CENTER, CENTER);
    text("Waiting for Players...", width/2, height/2);
  }
  
  parseData();
  
  for (int i = 0; i < shots.size(); i++)
    shots.get(i).update();
}

void serverEvent(Server server, Client client) {
  try {
    clients.add(client);
    client.write("id " + (clients.size() - 1) + "\n");

    players.add(new Point());

    for (int i = 0; i < clients.size(); i++) {

      if (clients.get(i).active())
        clients.get(i).write("pC " + clients.size());
    }
  } 
  catch (Exception e) {
    if (showErr)
      System.err.println(e);
  }
}
