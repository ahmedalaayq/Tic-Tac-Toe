import 'cell_state.dart';
import 'position.dart';

/// Represents a single move in the game
class Move {
  final int row;
  final int col;
  final CellState mark;
  final DateTime timestamp;

  const Move({
    required this.row,
    required this.col,
    required this.mark,
    required this.timestamp,
  });

  /// Creates a Move from a Position and mark
  factory Move.fromPosition(Position position, CellState mark) {
    return Move(
      row: position.row,
      col: position.col,
      mark: mark,
      timestamp: DateTime.now(),
    );
  }

  /// Gets the position of this move
  Position get position => Position(row, col);

  /// Creates a Move from JSON
  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      row: json['row'] as int,
      col: json['col'] as int,
      mark: CellState.fromJson(json['mark'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Converts Move to JSON
  Map<String, dynamic> toJson() {
    return {
      'row': row,
      'col': col,
      'mark': mark.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Move(row: $row, col: $col, mark: $mark, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Move &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col &&
          mark == other.mark;

  @override
  int get hashCode => row.hashCode ^ col.hashCode ^ mark.hashCode;
}
