/// Represents difficulty levels for AI
enum DifficultyLevel {
  easy,
  medium,
  hard;

  /// Converts DifficultyLevel to JSON
  String toJson() => name;

  /// Creates DifficultyLevel from JSON
  static DifficultyLevel fromJson(String json) {
    return DifficultyLevel.values.firstWhere(
      (e) => e.name == json,
      orElse: () => DifficultyLevel.medium,
    );
  }
}

/// Represents game mode
enum GameMode {
  singlePlayer,
  twoPlayer;

  /// Converts GameMode to JSON
  String toJson() => name;

  /// Creates GameMode from JSON
  static GameMode fromJson(String json) {
    return GameMode.values.firstWhere(
      (e) => e.name == json,
      orElse: () => GameMode.singlePlayer,
    );
  }
}

/// Represents player statistics
class Statistics {
  final int totalGames;
  final int wins;
  final int losses;
  final int draws;
  final Map<DifficultyLevel, int> winsPerDifficulty;
  final int currentStreak;
  final int longestStreak;

  const Statistics({
    this.totalGames = 0,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
    this.winsPerDifficulty = const {},
    this.currentStreak = 0,
    this.longestStreak = 0,
  });

  /// Calculates win rate as a percentage (0.0 to 1.0)
  double get winRate => totalGames > 0 ? wins / totalGames : 0.0;

  /// Creates a copy with updated values
  Statistics copyWith({
    int? totalGames,
    int? wins,
    int? losses,
    int? draws,
    Map<DifficultyLevel, int>? winsPerDifficulty,
    int? currentStreak,
    int? longestStreak,
  }) {
    return Statistics(
      totalGames: totalGames ?? this.totalGames,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
      winsPerDifficulty: winsPerDifficulty ?? this.winsPerDifficulty,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
    );
  }

  /// Creates Statistics from JSON
  factory Statistics.fromJson(Map<String, dynamic> json) {
    final winsPerDifficultyJson =
        json['winsPerDifficulty'] as Map<String, dynamic>?;
    final winsPerDifficulty = <DifficultyLevel, int>{};

    if (winsPerDifficultyJson != null) {
      winsPerDifficultyJson.forEach((key, value) {
        final difficulty = DifficultyLevel.fromJson(key);
        winsPerDifficulty[difficulty] = value as int;
      });
    }

    return Statistics(
      totalGames: json['totalGames'] as int? ?? 0,
      wins: json['wins'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      draws: json['draws'] as int? ?? 0,
      winsPerDifficulty: winsPerDifficulty,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
    );
  }

  /// Converts Statistics to JSON
  Map<String, dynamic> toJson() {
    final winsPerDifficultyJson = <String, int>{};
    winsPerDifficulty.forEach((key, value) {
      winsPerDifficultyJson[key.toJson()] = value;
    });

    return {
      'totalGames': totalGames,
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'winsPerDifficulty': winsPerDifficultyJson,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
    };
  }

  @override
  String toString() {
    return 'Statistics(totalGames: $totalGames, wins: $wins, losses: $losses, draws: $draws, winRate: ${(winRate * 100).toStringAsFixed(1)}%)';
  }
}
