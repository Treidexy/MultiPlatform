class Button {
  float
    x, 
    y, 
    w, 
    h;
  boolean isPressed, isOver;

  Button(float x, float y, float width, float height) {
    this.x = x;
    this.y = y;
    w = width;
    h = height;
  }
  
  void draw() {
    stroke(255);
    if (isPressed)
      fill(255);
    else if (isOver)
      fill(151);
    else
      fill(0);
    rect(x + camera.location.x, y + camera.location.y, w, h);
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
  buttons.put("left", new Button(50,  height - 150, 50, 50));
  buttons.put("right", new Button(150, height - 150, 50, 50));
  buttons.put("up", new Button(100,  height - 200, 50, 50));
  buttons.put("down", new Button(100, height - 100, 50, 50));
  buttons.put("crouch", new Button(100, height - 150, 50, 50));
  
  buttons.put("shot-left", new Button(width - 200,  height - 150, 50, 50));
  buttons.put("shot-right", new Button(width - 150, height - 150, 50, 50));
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
