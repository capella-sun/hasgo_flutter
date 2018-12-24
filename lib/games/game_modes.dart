/// Game Mode Enumeration
/// There should be a separate child directory for each game mode
enum GameMode { HIDE_AND_SEEK }

GameMode gameModeFromString(String value) {
  assert(value != null);
  assert(value.isNotEmpty);
  return GameMode.values
      .firstWhere((e) => e.toString().toUpperCase() == value.toUpperCase());
}

String getGameModeDisplayName(GameMode mode) {
  assert(mode != null);
  switch (mode) {
    case GameMode.HIDE_AND_SEEK: return 'Hide \& Seek';
    default: return ''; // Should never happen
  }
}