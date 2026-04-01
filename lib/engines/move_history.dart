import '../models/cell_state.dart';
import '../models/move.dart';

/// Manages the history of moves in a game for undo and replay functionality
class MoveHistory {
  final List<Move> _moves;

  /// Creates a new empty MoveHistory
  MoveHistory() : _moves = [];

  /// Gets all moves in chronological order
  List<Move> get moves => List.unmodifiable(_moves);

  /// Gets the number of moves recorded
  int get length => _moves.length;

  /// Checks if there are any moves in the history
  bool get isEmpty => _moves.isEmpty;

  /// Checks if there are moves in the history
  bool get isNotEmpty => _moves.isNotEmpty;

  /// Records a move in the history
  void addMove(Move move) {
    _moves.add(move);
  }

  /// Gets the last move, or null if no moves exist
  Move? getLastMove() {
    if (_moves.isEmpty) {
      return null;
    }
    return _moves.last;
  }

  /// Removes and returns the last move (for undo), or null if no moves exist
  Move? popMove() {
    if (_moves.isEmpty) {
      return null;
    }
    return _moves.removeLast();
  }

  /// Gets all moves in chronological order
  List<Move> getAllMoves() {
    return List.unmodifiable(_moves);
  }

  /// Clears all moves from the history
  void clear() {
    _moves.clear();
  }

  /// Reconstructs the board state at a specific move index
  /// Returns a 3x3 board with the state after the move at [moveIndex]
  /// If moveIndex is -1, returns an empty board
  List<List<CellState>> reconstructBoardAt(int moveIndex) {
    // Create empty 3x3 board
    final board = List.generate(3, (_) => List.filled(3, CellState.empty));

    // Apply moves up to and including moveIndex
    final endIndex = moveIndex < 0 ? -1 : moveIndex;
    for (int i = 0; i <= endIndex && i < _moves.length; i++) {
      final move = _moves[i];
      board[move.row][move.col] = move.mark;
    }

    return board;
  }

  /// Gets the board state after all recorded moves
  List<List<CellState>> getCurrentBoard() {
    return reconstructBoardAt(_moves.length - 1);
  }

  /// Creates a MoveHistory from a list of moves
  factory MoveHistory.fromMoves(List<Move> moves) {
    final history = MoveHistory();
    for (final move in moves) {
      history.addMove(move);
    }
    return history;
  }

  /// Creates a MoveHistory from JSON
  factory MoveHistory.fromJson(List<dynamic> json) {
    final moves = json
        .map((e) => Move.fromJson(e as Map<String, dynamic>))
        .toList();
    return MoveHistory.fromMoves(moves);
  }

  /// Converts MoveHistory to JSON
  List<Map<String, dynamic>> toJson() {
    return _moves.map((move) => move.toJson()).toList();
  }

  @override
  String toString() {
    return 'MoveHistory(moves: ${_moves.length})';
  }
}
