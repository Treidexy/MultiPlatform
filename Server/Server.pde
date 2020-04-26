import processing.net.*;

Server s;
Client c;
ArrayList<Client> clients = new ArrayList<Client>();
String cInput, input[], data[];
int framesNoFeedback = 0, 
  selectedClient = 0;

float w = 500, h = 800, 
  startX = 260, 
  startY = 15;

void setup() { 
  size(500, 800);
  frameRate(60);

  s = new Server(this, 23118);
}
void draw() { 
  framesNoFeedback++;
  surface.setTitle("Bike Game | Server - " + Server.ip());

  background(151);

  if (framesNoFeedback >= 60) {
    fill(200);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("Waiting for players...", width/2, height/2);
  }

  // Receive data from client
  for (int i = 0; i < clients.size(); i++) {
    c = clients.get(i);
    if (c.available() > 0) {
      framesNoFeedback = 0;
      
      cInput = c.readString();
      input = cInput.split("\n");

      println("s", cInput);

      float px = 0, py = 0;

      for (int j = 0; j < input.length; j++) {
        data = split(input[j], ' ');  // Split values into an array

        if (data[0].equalsIgnoreCase(String.valueOf(i))) {
          for (int l = 0; l < clients.size(); l++)
            clients.get(l).write("c " + i + " " + data[1] + " " + data[2] + "\n");
        }
      }
    }
  }
}

void serverEvent(Server server, Client client) {
  clients.add(client);
  client.write("id " + (clients.size() - 1) + "\n");
}

void keyTyped() {
  if (key == 'a')
    selectedClient--;
  if (key == 'd')
    selectedClient++;

  selectedClient = constrain(selectedClient, 1, clients.size());
}
