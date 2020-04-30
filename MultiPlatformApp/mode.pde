JSONArray modes;
JSONObject modeInfo, mode;

void parseGameMode() {
  modes = loadJSONArray("modes.json");
  
  for (int i = 0; i < modes.size(); i++) {
    if (modes.getJSONObject(i).getString("name").equals(gameMode))
      modeInfo = modes.getJSONObject(i);
  }
  
  mode = loadJSONObject(modeInfo.getString("file"));
  
}
