void parseConfig() {
  try {
    JSONObject config = loadJSONObject("config.json");
    JSONArray pluginPaths = config.getJSONArray("plugins");
    
    ArrayList<JSONObject> plugins = new ArrayList<JSONObject>();
    
    for (int i = 0; i < pluginPaths.size(); i++)
      plugins.add(loadJSONObject(pluginPaths.getString(i)));
    
    pluginHandler(plugins);
  } 
  catch (Exception e) {
    System.err.println("Can't read config.json!");
  }
}
