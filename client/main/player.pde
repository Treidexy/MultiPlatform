class Player {
  PVector position = new PVector(625, 400);
  boolean facingLeft = false;
  
  PVector acceleration;
  boolean myPlayer;
  float jumpHeight = 20;
  float speed = 5;
  final int _height = 100;
  final int _width = 50;
  
  Player(boolean _myPlayer) {
    myPlayer = _myPlayer;
  }
  
  void show() {
    noFill();
    if(myPlayer) {
      stroke(0, 255, 0);
    } else {
      stroke(255, 0, 0);
    }
    rect(position.x, position.y, _width, _height);
  }
  
  void update() {
    if(keyPressed) {
      switch (keyCode) {
        case 38:
          jump();
          break;
        case 37:
          position.x-= speed;
          break;
        case 39:
          position.x+= speed;
          break;
        default: println(keyCode);
      }
    }
  }
  
  void jump() {
    position.add(new PVector(0, -jumpHeight));
  }
  
  void newPos(float x, float y) {
    position = new PVector(x, y);
  }
}
