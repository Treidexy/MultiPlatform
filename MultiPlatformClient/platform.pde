class Platform {
  static final int STATIC = 0, MOVING = 1, VANISHING = -1, SHAPESHIFTING = 3;

  PVector position;
  PImage img;
  int type;

  int w, h;

  boolean negX, negY;
  float
    speed;
  PVector minPos, maxPos;

  int
    vanishMillis, 
    millisPast, 
    millisSinceVanish;
  boolean vanished;

  PVector
    min, 
    max;
  boolean inW, inH;

  Platform(float x, float y, int w, int h, PImage img, float... attributes) {
    this.img = img;
    this.w = w;
    this.h = h;
    this.type = int(attributes[0]);

    position = new PVector(x, y);

    switch(type) {
    case STATIC:
      break;
    case MOVING:
      speed = attributes[1];
      minPos = new PVector(attributes[2], attributes[3]);
      maxPos = new PVector(attributes[4], attributes[5]);
      break;
    case VANISHING:
      vanishMillis = int(attributes[1]);
      millisPast = millis();
      break;
    case SHAPESHIFTING:
      speed = attributes[1];
      min = new PVector(attributes[2], attributes[3]);
      max = new PVector(attributes[4], attributes[5]);
      break;
    }
  }

  void show() {
    if (!vanished) {
      noFill();
      stroke(0, 0, 255);
      rect(position.x, position.y, w, h);

      img.resize(w, h);
      image(img, position.x, position.y);
    }
  }

  void update() {
    switch(type) {
    case STATIC:
      break;
    case MOVING:
      if (negX) {
        position.sub(cos(PVector.angleBetween(minPos, maxPos)) * speed, 0);
      } else {
        position.add(cos(PVector.angleBetween(minPos, maxPos)) * speed, 0);
      }

      if (negY) {
        position.sub(0, sin(PVector.angleBetween(minPos, maxPos)) * speed);
      } else {
        position.add(0, sin(PVector.angleBetween(minPos, maxPos)) * speed);
      }


      if (position.x >= maxPos.x) {
        negX = true;
      } else if (position.x <= minPos.x) {
        negX = false;
      }

      if (position.y >= maxPos.y) {
        negY = true;
      } else if (position.y <= minPos.y) {
        negY = false;
      }
      break;
    case VANISHING:
      millisSinceVanish += millis() -  millisPast;
      if (millisSinceVanish >= vanishMillis) {
        vanished = !vanished;

        millisSinceVanish = 0;
      }
      millisPast = millis();
      break;
    case SHAPESHIFTING:
      if (inW)
        w+= speed;
      else
        w -= speed;

      if (inH)
        h+= speed;
      else
        h-= speed;

      if (w < min.x) {
        inW = true;
      } else if (w > max.x) {
        inW = false;
      }

      if (h < min.y) {
        inH = true;
      } else if (h > max.y) {
        inH = false;
      }
      break;
    }
  }
}
