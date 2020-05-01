class Button {
  PImage sprite;
  int
    x, 
    y, 
    w, 
    h;
  boolean isPressed, isOver;

  Button(int x, int y, int width, int height, PImage sprite) {
    this.x = x;
    this.y = y;
    w = width;
    h = height;
    
    this.sprite = sprite;
  }
  
  void draw() {
    stroke(255);
    if (isPressed)
      fill(151, 151, 151, 151);
    else if (isOver)
      fill(0, 0, 0, 151);
    else
      fill(0, 0, 0, 0);
    ellipseMode(CORNER);
    image(sprite, x + camera.location.x, y + camera.location.y, w, h);
    ellipse(x + camera.location.x, y + camera.location.y, w, h);
  }
  
  void update() {
    if (mouseX > x && mouseX < x + w &&
      mouseY > y && mouseY < y + h) {
        isOver = true;
        if (mousePressed)
          isPressed = true;
        else
          isPressed = false;
    } else {
      isOver = false;
      isPressed = false;
    }
  }
}

void initButtons() {
  buttons.put("left", new Button(50,  height - 150, 50, 50, buttonSprites.get("left")));
  buttons.put("right", new Button(150, height - 150, 50, 50, buttonSprites.get("right")));
  buttons.put("up", new Button(100,  height - 200, 50, 50, buttonSprites.get("up")));
  buttons.put("down", new Button(100, height - 100, 50, 50, buttonSprites.get("down")));
  
  buttons.put("crouch", new Button(width - 200, height - 150, 50, 50, buttonSprites.get("crouch")));
  buttons.put("shot-left", new Button(width - 250,  height - 150, 50, 50, buttonSprites.get("shot-left")));
  buttons.put("shot-right", new Button(width - 150, height - 150, 50, 50, buttonSprites.get("shot-right")));
}

void drawButtons() {
  buttons.get("left").draw();
  buttons.get("right").draw();
  buttons.get("up").draw();
  buttons.get("down").draw();
  buttons.get("crouch").draw();
  
  buttons.get("shot-left").draw();
  buttons.get("shot-right").draw();
}

void updateButtons() {
  buttons.get("left").update();
    isA = buttons.get("left").isPressed;
  buttons.get("right").update();
    isD = buttons.get("right").isPressed;
  buttons.get("up").update();
    isJump = buttons.get("up").isPressed;
  buttons.get("down").update();
    isDown = buttons.get("down").isPressed;
  buttons.get("crouch").update();
    player.isCrouching = buttons.get("crouch").isPressed;
    
  buttons.get("shot-left").update();
    isLeft = buttons.get("shot-left").isPressed;
  buttons.get("shot-right").update();
    isRight = buttons.get("shot-right").isPressed;
}
