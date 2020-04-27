class Shot {
  int player;
  int damage;
  boolean facingLeft;
  int x;
  int y;
  int w;
  int h;
  int speed;
  
  Shot(int _player, int _damage, boolean _facingLeft, int _x, int _y) {
    player = _player;
    damage = _damage;
    facingLeft = _facingLeft;
    x = _x;
    y = _y;
    w = 50;
    h = 15;
    speed = 6;
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
    
    for(int i = 0; i < clients.size(); i++)
      if (collidingWithPlayer(players.get(i)) && i != selId) {
        //players.get(i).takeDamage(damage);
        shots.remove(this);
      }
  }
  
  boolean collidingWithPlayer(Point _p) {
    if(x + w > _p.x && x < _p.x + pWidth && y + h > _p.y && y < _p.y + pHeight)
      return true;
    return false;
  }
}
