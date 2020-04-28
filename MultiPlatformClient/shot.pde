class Shot {
  boolean facingLeft;
  int player, 
    damage, 
    x, 
    y, 
    w, 
    h, 
    rw, 
    rh, 
    speed;

  Shot(int player, int damage, boolean facingLeft, int x, int y) {
    this.player = player;
    this.damage = damage;
    this.facingLeft = facingLeft;
    this.x = x;
    this.y = y;
    w = 48;
    h = 16;
    rw = 96;
    rh = 16;
    speed = 6;
  }

  void show() {
    noFill();
    stroke(255, 0, 0);
    rect(x, y, w, h);

    if (facingLeft)
      image(shot_left, x, y, rw, rh);
    else
      image(shot_right, x - w, y, rw, rh);
  }

  void update() {
    if (facingLeft)
      x-= speed;
    else
      x+= speed;

    if (x < -w)
      shots.remove(this);
    if (x > width)
      shots.remove(this);

    for (int i = 0; i < players.length; i++)
      if (collidingWithPlayer(players[i]) && i != id) {
        shots.remove(this);
      }
  }

  boolean collidingWithPlayer(Player _p) {
    if (x + w > _p.position.x && x < _p.position.x + _p._width && y + h > _p.position.y && y < _p.position.y + _p._height) return true;
    return false;
  }
}
