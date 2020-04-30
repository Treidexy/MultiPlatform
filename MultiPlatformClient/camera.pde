class Camera {
  PVector location, wantLocation, velocity, acceleration;
  float shakiness = 1;
  
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
    acceleration = PVector.sub(new PVector(wantLocation.x - width/2, wantLocation.y - height/2), location);
    
    velocity.add(acceleration);
    velocity.limit(shakiness);
    
    location.add(acceleration);
    
    translate(-location.x, -location.y);
  }
}
