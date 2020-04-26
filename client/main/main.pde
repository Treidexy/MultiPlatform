import processing.net.*;

Client c;
String cInput, input[], data[]; 
int id;

Player player = new Player(true);

void setup() {
  size(1250, 800);

  c = new Client(this, "127.0.0.1", 6969);

  surface.setTitle("Multi Platform - " + c.ip());
}

void draw() {
  background(100, 100, 255);

  player.update();

  if (c.available() > 0) {
    cInput = c.readString(); 
    input = cInput.split("\n");
    data = split(input[0], ' ');

    for (int i = 0; i < input.length; i++) {
      switch(data[0]) {
        case "id":
          id = Integer.valueOf(data[0]);
          break;
        case "c":
          if (data[1].equals(id)) {
            player.show();
          } else {
             new Player(false).show();
          }
          break;
      }
    }
  }
}
