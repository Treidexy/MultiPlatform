import processing.net.*;

Client c;
String cInput, input[], data[]; 
int id;

Player player;

void setup() {
  size(1250, 800);
  frameRate(60);

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
            println(1);
            player.show();
          } else {
             new Player(false).show();
          }
          break;
      }
    }
  }
  }
}
