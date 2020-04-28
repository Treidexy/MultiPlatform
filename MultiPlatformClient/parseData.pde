void parseData() {
  try {
    cInput = c.readString(); 
    input = cInput.split("\n");
    data = split(input[0], ' ');

    println(cInput);

    if (data[0].equals("id")) {
      id = Integer.valueOf(data[1]);
    }

    //camera.update();

    player.update();

    c.write(id + " " + player.position.x + " " + player.position.y + "\n");
    background(100, 100, 255);
    for (int i = 0; i < input.length; i++) {
      data = split(input[i], ' ');

      switch(data[0]) {
      case "c":
        if (data[1].equals(String.valueOf(id))) {
          players.get(int(data[1])).setPos(float(data[2]), float(data[3]));
        } else {
          if (players.get(int(data[1])) == null)
            players.add(int(data[1]), new Player(false));
          
          players.get(int(data[1])).setPos(float(data[2]), float(data[3]));
        }
        break;
      case "cp":
        if (data[1].equals(String.valueOf(id))) {
          switch(data[2]) {
            case "hp":
              player.health = float(data[3]);
              break;
            case "":
          }
        }
        break;
      case "shot":
        shots.add(new Shot(int(data[1]), int(data[2]), boolean(data[3]), int(data[4]), int(data[5])));
        break;
      case "pc":
        while (players.size() < int(data[1])) {
          players.add(new Player(false));
        }
        break;
      case "dc":
        players.remove(int(data[1]));
        break;
      }
    }
  } 
  catch (Exception e) {
    System.err.println(e);
  }
}
