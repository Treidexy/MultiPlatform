void parseData() {
  for (int i = 0; i < clients.size(); i++) {
    c = clients.get(i);
    try {
      if (c.active()) {
        background(272);
        framesNoFeedback = 0;
        
        selId = i;

        cInput = c.readString();
        input = cInput.split("\n");

        //println("IN:", "s", cInput);

        for (int j = 0; j < input.length; j++) {
          String pubMsg = null; 
          String[] data = split(input[j], ' ');

          if (data[0].equals(String.valueOf(selId))) {
            pubMsg = "c " + i + " " + data[1] + " " + data[2];

            players.get(i).setPos(int(data[1]), int(data[2]));
            //players.get(i).isCrough
          }

          switch (data[0]) {
          case "shot":
            shots.add(new Shot(int(data[1]), int(data[2]), boolean(data[3]), int(data[4]), int(data[5])));
            pubMsg = input[j];
            println(pubMsg);
            break;
          case "dc":
            if (data[1].equals(String.valueOf(i))) {
              pubMsg = "dc " + i;

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
