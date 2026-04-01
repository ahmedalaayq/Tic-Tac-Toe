/// Represents the current state of the game
enum GameState {
  playing,
  finished;

  /// Converts GameState to JSON
  String toJson() => name;

  /// Creates GameState from JSON
  static GameState fromJson(String json) {
    return GameState.values.firstWhere(
      (e) => e.name == json,
      orElse: () => GameState.playing,
    );
  }
}

/// Represents the player type
enum Player {
  human,
  ai;

  /// Converts Player to JSON
  String toJson() => name;

  /// Creates Player from JSON
  static Player fromJson(String json) {
    return Player.values.firstWhere(
      (e) => e.name == json,
      orElse: () => Player.human,
    );
  }
}
