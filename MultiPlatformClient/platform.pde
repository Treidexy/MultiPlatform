class Platform {
  PVector position;
  
  float w, h;
  
  Platform(float x, float y, float w, float h) {
    this.w = w;
    this.h = h;
    
    position = new PVector(x, y);
  }
  
  void show() {
    fill(#00ff00);
    rect(position.x, position.y, w, h);
  }
}
