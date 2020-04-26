class Shot {
  int player;
  float damage;
  boolean facingLeft;
  int x;
  int y;
  int w;
  int h;
  int speed;
  
  Shot(int _player, float _damage, boolean _facingLeft, int _x, int _y) {
    player = _player;
    damage = _damage;
    facingLeft = _facingLeft;
    x = _x;
    y = _y;
    w = 50;
    h = 50;
    speed = 6;
  }
  
  void show() {
    noFill();
    stroke(255, 0, 0);
    rect(x, y, w, h);
  }
  
  void update() {
    if(facingLeft) x-= speed;
    else x+= speed;
    for(int i = 0; i < players.size(); i++) if (collidingWithPlayer(players.get(i))) players.get(i).takeDamage(damage);
  }
  
  boolean collidingWithPlayer(Player _p) {
    if(x + w > _p.position.x && x < _p.position.x + _p._width && y + h > _p.position.y && y < _p.position.y + _p._height) return true;
    return false;
  }
}
