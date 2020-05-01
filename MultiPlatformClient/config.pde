void parseConfig() {
  try {
    JSONObject config = loadJSONObject("config.json");
  } 
  catch (Exception e) {
    System.err.sln("Can't read config.json!");
  }
}
