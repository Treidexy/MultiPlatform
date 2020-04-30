class Platform {
  PVector position;
  PImage img;

  int w, h;

  Platform(float x, float y, int w, int h, PImage img) {
    this.img = img;
    this.w = w;
    this.h = h;
    
    position = new PVector(x, y);
  }

  void show() {
    noFill();
    stroke(0, 0, 255);
    rect(position.x, position.y, w, h);
    
    img.resize(w, h);
    image(img, position.x, position.y);
  }
}
