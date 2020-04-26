class Camera {
  float smoothness;
  PVector location, wantLocation, desPos, offset, smoothPos;
  
  public Camera() {
    smoothness = 0.69f;
    
    location = new PVector();
    wantLocation = new PVector();
    desPos = new PVector();
    offset = new PVector(-width/2, -height/2);
    smoothPos = new PVector();
  }
  
  void focus(float fx, float fy) {
    wantLocation = new PVector(fx, fy);
  }
  
  void focus(PVector pPos) {
    wantLocation = pPos;
  }
  
  void update() {
    desPos = PVector.add(wantLocation, offset);
    smoothPos = PVector.lerp(location, desPos, smoothness);
    
    location = smoothPos;
    
    translate(-location.x, -location.y);
  }
}
