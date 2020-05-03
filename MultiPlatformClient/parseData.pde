void parseData() {
  try {
    cInput = c.readString(); 
    input = cInput.split("\n");
    for (String in : input) {
      data = split(in, ' ');

      if (data[0].equals("id")) {
        id = Integer.valueOf(data[1]);
      }

      switch(data[0]) {
      case "setting":
        initMap(data[1]);

        player = new Player(true);
        camera = new Camera();
        break;
      case "c":
        if (data[1].equals(String.valueOf(id))) {
          players.get(int(data[1])).setPos(float(data[2]), float(data[3]));
        } else {
          while (players.get(int(data[1])) == null)
            players.add(new Player(false));
          players.get(int(data[1])).setPos(float(data[2]), float(data[3]));
          players.get(int(data[1])).facingLeft = boolean(data[5]);
          players.get(int(data[1]))._width = int(data[6]);
          players.get(int(data[1]))._height = int(data[7]);
        }
        break;
      case "cp":
        if (data[1].equals(String.valueOf(id))) {
          switch(data[2]) {
          case "hp":
            player.health = int(data[3]);
            break;
          }
        } else {
          switch(data[2]) {
          case "hp":
            players.get(int(data[1])).health = int(data[3]);
            break;
          }
        }
        break;
      case "shot":
        shots.add(new Shot(int(data[1]), int(data[2]), boolean(data[3]), int(data[4]), int(data[5])));
        break;
      case "pc":
        for (int j = players.size(); j  < int(data[1]); j++) {
          players.add(new Player(false));
          players.get(j).setId(j);
        }
        break;
      case "dc":
        players.remove(int(data[1]));
        break;
      }
    }
  } 
  catch (Exception e) {
  }
}
