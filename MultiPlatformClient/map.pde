void displayMap(String mapId) {
  while (platforms.size() > 0)
    platforms.remove(platforms.size() - 1);
  
  switch(mapId) {
    case "sky_map":
      background(sky_map[0]);
      platforms.add(new Platform(300, 700, 400, 50, sky_map[1]));
      platforms.add(new Platform(800, 500, 400, 50, sky_map[1]));
      platforms.add(new Platform(250, 450, 400, 50, sky_map[1]));
      platforms.add(new Platform(650, 300, 400, 50, sky_map[1]));
      break;
    case "hell_map":
      background(hell_map[0]);
      platforms.add(new Platform(300, 500, 500, 50, hell_map[1]));
      platforms.add(new Platform(50, 250, 400, 50, hell_map[1]));
      platforms.add(new Platform(600, 700, 500, 50, hell_map[1]));
      platforms.add(new Platform(900, 250, 400, 50, hell_map[1]));
      break;
  }
}
