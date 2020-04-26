import processing.net.*;

Server s;
Client c;
ArrayList<Client> clients = new ArrayList<Client>();
String cInput, input[], data[];
int framesNoFeedback = 0;

//Testing perpisis only
final boolean showErr = false;

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

    fill(200);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("Waiting for players...", width/2, height/2);
  }

  // Receive data from client
  for (int i = 0; i < clients.size(); i++) {
    c = clients.get(i);
    try {
      if (c.active()) {
        background(272);
        framesNoFeedback = 0;

        cInput = c.readString();
        input = cInput.split("\n");

        println("s", cInput);

        for (int j = 0; j < input.length; j++) {
          String pubMsg = null;
          data = split(input[j], ' ');

          if (data[0].equals(String.valueOf(i))) {
            pubMsg = "c " + i + " " + data[1] + " " + data[2];
          }
          
          if (data[0].equals("dispose") && data[1].equals(String.valueOf(i))) {
            pubMsg = "dispose " + i;

            clients.remove(i);
            
            for (int l = 0; l < clients.size(); l++)
              clients.get(l).write("id " + l + "\n");
          }
          
          for (int l = 0; l < clients.size(); l++)
              clients.get(l).write(pubMsg + "\n");
        }
      }
    } 
    catch(Exception e) {
      if (showErr)
        System.err.println(e);
    }
  }
}

void serverEvent(Server server, Client client) {
  try {
    clients.add(client);
    client.write("id " + (clients.size() - 1) + "\n");

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
