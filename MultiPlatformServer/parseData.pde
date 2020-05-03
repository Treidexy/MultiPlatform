void parseData() {
  for (int i = 0; i < clients.size(); i++) {
    c = clients.get(i);
    try {
      background(69);

      text(players.size() + " player(s) active", width/2, height/2 - 45);

      framesNoFeedback = 0;

      selId = i;

      cInput = c.readString();
      inputs = cInput.split("\n");

      for (String input : inputs) {
        String pubMsg = null; 
        String[] data = split(input, ' ');

        if (data[0].equals(String.valueOf(selId))) {
            pubMsg = "c " + selId + " " + data[1] + " " + data[2] + " " + players.get(selId).health + " " + data[4] + " " + data[5] + " " + data[6];

          players.get(selId).setPos(int(data[1]), int(data[2]));
          players.get(selId).isCrouching = boolean(data[3]);
          players.get(selId).facingLeft = boolean(data[4]);

          players.get(selId).w = int(data[5]);
          players.get(selId).h = int(data[6]);

          players.get(selId).inActiveFrames = 0;
        }

        switch (data[0]) {
        case "shot":
          shots.add(new Shot(int(data[1]), int(data[2]), boolean(data[3]), int(data[4]), int(data[5])));
          pubMsg = input;
          break;
        case "dc":
          disposeClient(int(data[1]));
          pubMsg = input;
          break;
        }

        for (int l = 0; l < clients.size(); l++)
          clients.get(l).write(pubMsg + "\n");
      }
    } 
    catch(Exception e) {
      if (showErr)
        System.err.println(e);
    }
  }
}
