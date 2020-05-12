class Settings {
  JSONObject currentSettings, defaultSettings;
  Settings() {

    defaultSettings = new JSONObject();
    currentSettings = new JSONObject();
    defaultSettings.setBoolean("drawSecondsHand", true);
    JSONArray defaultUsedDebugOverlays = new JSONArray();
    defaultUsedDebugOverlays.setBoolean(0, false);
    defaultUsedDebugOverlays.setBoolean(1, false);
    defaultUsedDebugOverlays.setBoolean(2, false);
    defaultUsedDebugOverlays.setBoolean(3, false);
    defaultUsedDebugOverlays.setBoolean(4, false);
    defaultSettings.setJSONArray("usedDebugOverlays", defaultUsedDebugOverlays);
    defaultSettings.setBoolean("fullScreen", false);
    defaultSettings.setInt("Width", 854);
    defaultSettings.setInt("Height", 480);
    defaultSettings.setInt("clockIndex", 0);
  }
  void saveToFile(String path) {
    saveJSONObject(currentSettings, path);
  }
  void loadFromFile(String path) {
    currentSettings = loadJSONObject(path);
  }
  void apply(String type) {
    JSONObject using;
    if (type=="default") {
      using = defaultSettings;
    } else {
      using = currentSettings;
    }
    if (using.getBoolean("fullScreen"))
      fullScreen();
    else
      surface.setSize(using.getInt("Width"), using.getInt("Height"));
    clockIndex = using.getInt("clockIndex");
    usedDebugOverlays = using.getJSONArray("usedDebugOverlays").getBooleanArray();
    useDebug.setSelected(usedDebugOverlays[0]);
    FPSShown.setSelected(usedDebugOverlays[1]);
    DateTimeShown.setSelected(usedDebugOverlays[2]);
    showOquadCalls.setSelected(usedDebugOverlays[3]);
    showHandAndMod.setSelected(usedDebugOverlays[4]);
    f=using.getBoolean("fullScreen");
  }
}
