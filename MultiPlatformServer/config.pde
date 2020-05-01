void parseConfig() {
  try {
    JSONObject config = loadJSONObject("config.json");

    map = config.getString("map");
    gameMode = config.getString("game-mode");
  } 
  catch (Exception e) {
    System.err.println("Can't read config.json!");
  }
}
