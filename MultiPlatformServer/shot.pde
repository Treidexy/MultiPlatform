class Shot {
  int player;
  int damage;
  boolean facingLeft;
  int x, 
    y, 
    w, 
    h;
  final int speed;

  Shot(int player, int damage, boolean facingLeft, int x, int y) {
    this.player = player;
    this.damage = damage;
    this.facingLeft = facingLeft;
    this.x = x;
    this.y = y;
    w = 48;
    h = 16;
    speed = 6;
  }

  void update() {
    println(x, y);
    if (facingLeft)
      x-= speed;
    else
      x+= speed;

    if (x < -w)
      shots.remove(this);
    if (x > width)
      shots.remove(this);

    for (int i = 0; i < clients.size(); i++) {
      if (collidingWithPlayer(players.get(i)) && i != selId) {
        players.get(i).health(Player.SUB, damage);
        shots.remove(this);
      }
    }
  }

  boolean collidingWithPlayer(Player _p) {
    if (x + w > _p.x && x < _p.x + pWidth && y + h > _p.y && y < _p.y + pHeight)
      return true;
    return false;
  }
}
