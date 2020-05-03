class Camera {
  PVector location, wantLocation, acceleration;
  float shakiness;

  public Camera() {
    shakiness = selCharacter.getFloat("shakiness");
    
    //default
    //shakiness = 0;
    location = new PVector();
    wantLocation = new PVector();
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

    acceleration.add(random(-shakiness, shakiness), random(-shakiness, shakiness));

    location.add(acceleration);

    translate(-location.x, -location.y);
  }
}
