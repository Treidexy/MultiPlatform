class homeScreen extends PApplet {
  String ip = "";
  
  PImage background;
  
  void settings() {
    size(500, 400);
  }
  
  void setup() {
    surface.setTitle("Connect");
    surface.setAlwaysOnTop(true);
    
    background = instance.loadImage("assets/home_screen/background.png");
  }
  
  void draw() {
    background(background);
    textSize(50 - ip.length());
    textAlign(CENTER, CENTER);
    text("IP: " + ip, width/2, height/2);
  }
  
  void keyTyped() {
    ip += key;
    if (key == BACKSPACE)
      if (ip.length() - 1 <= 0)
        ip = ip.substring(0, ip.length() - 1);
      else
        ip = ip.substring(0, ip.length() - 2);
    if (key == ENTER) {
      ip = ip.substring(0, ip.length() - 1);
      exit();
    }
  }
  
  void exit() {
    c = new Client(instance, ip, 6969);
    
    if (c.active()) {
      frame.setVisible(false);
      frame.dispose();
    } else {
      ip = "";
    }
  }
}
