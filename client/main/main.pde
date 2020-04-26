import processing.net.*;

Client c;
String cInput, input[], data[]; 
int id;

Player player;

void setup() {
  size(1250, 800);

  c = new Client(this, "192.168.86.140", 6969);

  surface.setTitle("Multi Platform - " + c.ip());

  player = new Player(true);
}

void draw() {
  background(100, 100, 255);

  if (c.available() > 0) {
    cInput = c.readString(); 
    input = cInput.split("\n");
    data = split(input[0], ' ');

    println("c" + id, cInput);

    player.update();
  c.write("c" + id + player.position.x + " " + player.position.y);

  for (int i = 0; i < input.length; i++) {
    switch(data[0]) {
      case "id":
        id = Integer.valueOf(data[1]);
        break;
      case "c":
        if (data[1].equals(String.valueOf(id))) {
          player.show();
        } else {
           new Player(false).show();
        }
        break;
    }
  }
  }
}
