class Platform {
  PVector position;
  
  float w, h;
  
  Platform(float x, float y, float _w, float _h) {
    position = new PVector(x, y);
    w = _w;
    h = _h;
  }
  
  void show() {
    noFill();
    stroke(0, 0, 255);
    rect(position.x, position.y, w, h);
  }
}
