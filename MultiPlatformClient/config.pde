void parseConfig() {
  try {
    JSONObject config = loadJSONObject("config.json");
  } 
  catch (Exception e) {
    System.err.println("Can't read config.json!");
  }
}
