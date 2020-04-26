class Player {
  PVector position = new PVector(625, 400);
  boolean facingLeft = false;
  
  PVector acceleration;
  boolean myPlayer;
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
  
  }
  
  void newPos(float x, float y) {
    position = new PVector(x, y);
  }
}
