import processing.net.*;

Server s;
Client c;
ArrayList<Client> clients = new ArrayList<Client>();
String cInput, input[], data[];
int framesNoFeedback = 0, 
  selectedClient = 0;

void setup() { 
  size(500, 800);
  frameRate(60);

  s = new Server(this, 6969);

  surface.setTitle("Multi Platform | Server - " + s.ip());
}
void draw() {
  framesNoFeedback++;

  background(217);

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
      background(272);
      framesNoFeedback = 0;

      cInput = c.readString();
      input = cInput.split("\n");

      println("s", cInput);

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
  
  for (int i = 0; i < clients.size(); i++) {
    clients.get(i).write("pC");
  }
}

void keyTyped() {
  if (key == 'a')
    selectedClient--;
  if (key == 'd')
    selectedClient++;

  selectedClient = constrain(selectedClient, 1, clients.size());
}
