class Shot {
  int player;
  int damage;
  boolean facingLeft;
  int x;
  int y;
  int w;
  int h;
  int speed;
  
  Shot(int player, int damage, boolean facingLeft, int x, int y) {
    this.player = player;
    this.damage = damage;
    this.facingLeft = facingLeft;
    this.x = x;
    this.y = y;
    w = 50;
    h = 15;
    speed = 6;
    
    c.write("shot " + player + " " + damage + " " + facingLeft + " " + x + " " + y);
  }
  
  void show() {
    noFill();
    stroke(255, 0, 0);
    rect(x, y, w, h);
    image(shot, x, y);
  }
  
  void update() {
    if(facingLeft)
      x-= speed;
    else
      x+= speed;
      
    if (x < -w)
      shots.remove(this);
    if (x > width)
      shots.remove(this);
    
    for(int i = 0; i < players.size(); i++)
      if (collidingWithPlayer(players.get(i))) {
        players.get(i).takeDamage(damage);
        shots.remove(this);
      }
  }
  
  boolean collidingWithPlayer(Player _p) {
    if(x + w > _p.position.x && x < _p.position.x + _p._width && y + h > _p.position.y && y < _p.position.y + _p._height) return true;
    return false;
  }
}
