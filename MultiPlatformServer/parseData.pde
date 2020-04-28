void parseData() {
  for (int i = 0; i < clients.size(); i++) {
    c = clients.get(i);
    
    selId = i;
    
    try {
      if (c.active()) {
        background(272);
        framesNoFeedback = 0;

        cInput = c.readString();
        input = cInput.split("\n");

        //println("IN:", "s", cInput);

        for (int j = 0; j < input.length; j++) {
          String pubMsg = null; 
          String[] data = split(input[j], ' ');

          if (data[0].equals(String.valueOf(i))) {
            pubMsg = "c " + i + " " + data[1] + " " + data[2];

            players.get(i).x = int(data[1]);
            players.get(i).y = int(data[2]);
          }

          switch (data[0]) {
          case "shot":
            shots.add(new Shot(int(data[1]), int(data[2]), boolean(data[3]), int(data[4]), int(data[5])));
            pubMsg = input[j];
            break;
          case "dispose":
            if (data[1].equals(String.valueOf(i))) {
              pubMsg = "dispose " + i;

              clients.remove(i);

              for (int l = 0; l < clients.size(); l++) {
                clients.get(l).write("id " + l + "\n");
                //println("OUT:", "id " + l + "\n");
              }
            }
            break;
          }

          for (int l = 0; l < clients.size(); l++)
            clients.get(l).write(pubMsg + "\n");
          //println("OUT:", pubMsg);
        }
        //console.draw(0, 0, width, height);
        //console.print();
      }
    } 
    catch(Exception e) {
      if (showErr)
        System.err.println(e);
    }
  }
}
