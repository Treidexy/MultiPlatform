void parseData() {
  try {
    cInput = c.readString(); 
    input = cInput.split("\n");
    data = split(input[0], ' ');

    //println(cInput);

    if (data[0].equals("id")) {
      id = Integer.valueOf(data[1]);
    }

    for (String in : input) {
      data = split(in, ' ');

      switch(data[0]) {
      case "map":
        map = data[1];
        break;
      case "c":
        if (data[1].equals(String.valueOf(id))) {
          players.get(int(data[1])).setPos(float(data[2]), float(data[3]));
        } else {
          while (players.get(int(data[1])) == null)
            players.add(new Player(false));
          players.get(int(data[1])).setPos(float(data[2]), float(data[3]));
          players.get(int(data[1])).isCrouching = boolean(data[5]);
          players.get(int(data[1])).facingLeft = boolean(data[6]);
        }
        break;
      case "cp":
        println(1);
        if (data[1].equals(String.valueOf(id))) {
          println(2);
          switch(data[2]) {
          case "hp":
            player.health = int(data[3]);
            println(in, player.health, int(data[3]));
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
    e.getCause();
  }
}
