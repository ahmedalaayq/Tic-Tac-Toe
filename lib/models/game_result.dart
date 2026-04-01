import 'position.dart';
import 'game_state.dart';

/// Represents the outcome of a game
enum GameOutcome {
  win,
  loss,
  draw;

  /// Converts GameOutcome to JSON
  String toJson() => name;

  /// Creates GameOutcome from JSON
  static GameOutcome fromJson(String json) {
    return GameOutcome.values.firstWhere(
      (e) => e.name == json,
      orElse: () => GameOutcome.draw,
    );
  }
}

/// Represents the result of a completed game
class GameResult {
  final GameOutcome outcome;
  final Player? winner;
  final List<Position>? winningPositions;
  final DateTime timestamp;

  const GameResult({
    required this.outcome,
    this.winner,
    this.winningPositions,
    required this.timestamp,
  });

  /// Creates a GameResult from JSON
  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      outcome: GameOutcome.fromJson(json['outcome'] as String),
      winner: json['winner'] != null
          ? Player.fromJson(json['winner'] as String)
          : null,
      winningPositions: json['winningPositions'] != null
          ? (json['winningPositions'] as List)
                .map((e) => Position.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Converts GameResult to JSON
  Map<String, dynamic> toJson() {
    return {
      'outcome': outcome.toJson(),
      'winner': winner?.toJson(),
      'winningPositions': winningPositions?.map((e) => e.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'GameResult(outcome: $outcome, winner: $winner, timestamp: $timestamp)';
  }
}
