void initCharacters() {
  JSONArray charactersObj = loadJSONArray("characters.json");
  
  for (int i = 0; i < charactersObj.size(); i++)
    characters.put(charactersObj.getJSONObject(i).getString("name"), charactersObj.getJSONObject(i));
  for (int i = 0; i < customCharacters.size(); i++)
    characters.put(customCharacters.get(i).getString("name"), customCharacters.get(i));
}

void initCharacter() {
  selCharacter = characters.get(character);
}
