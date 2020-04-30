class Camera {
  PVector location, wantLocation, velocity, acceleration;
  
  public Camera() {
    location = new PVector();
    wantLocation = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
  }
  
  void focus(float fx, float fy) {
    wantLocation = new PVector(fx, fy);
  }
  
  void focus(PVector focus) {
    wantLocation = focus;
  }
  
  void update() {
    acceleration = new PVector(wantLocation.x - width/2, wantLocation.y - height/2);
    
    location = acceleration;
    
    translate(-location.x, -location.y);
  }
}
