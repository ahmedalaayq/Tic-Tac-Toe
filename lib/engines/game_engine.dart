import '../models/cell_state.dart';
import '../models/game_state.dart';
import '../models/position.dart';
import '../models/move.dart';
import '../models/game_result.dart';
import 'win_detector.dart';
import 'move_history.dart';

/// Core game engine that manages board state, move validation, and game rules
class GameEngine {
  final WinDetector _winDetector;
  final MoveHistory _moveHistory;

  List<List<CellState>> _board;
  GameState _state;
  CellState _currentPlayer;

  /// Creates a new GameEngine with an empty board
  GameEngine({
    WinDetector? winDetector,
    MoveHistory? moveHistory,
    CellState initialPlayer = CellState.x,
  }) : _winDetector = winDetector ?? WinDetector(),
       _moveHistory = moveHistory ?? MoveHistory(),
       _board = List.generate(3, (_) => List.filled(3, CellState.empty)),
       _state = GameState.playing,
       _currentPlayer = initialPlayer;

  /// Gets the current board state (immutable copy)
  List<List<CellState>> get board =>
      List.generate(3, (row) => List.from(_board[row]));

  /// Gets the current game state
  GameState get state => _state;

  /// Gets the current player's mark
  CellState get currentPlayer => _currentPlayer;

  /// Gets the move history
  MoveHistory get moveHistory => _moveHistory;

  /// Gets the win detector
  WinDetector get winDetector => _winDetector;

  /// Makes a move at the specified position
  /// Returns true if the move was successful, false otherwise
  bool makeMove(int row, int col) {
    // Validate the move
    if (!isValidMove(row, col)) {
      return false;
    }

    // Place the mark
    _board[row][col] = _currentPlayer;

    // Record the move in history
    _moveHistory.addMove(
      Move(row: row, col: col, mark: _currentPlayer, timestamp: DateTime.now()),
    );

    // Check for game end
    if (_winDetector.checkWin(_board, row, col)) {
      _state = GameState.finished;
    } else if (_winDetector.isBoardFull(_board)) {
      _state = GameState.finished;
    }

    // Switch player if game is still ongoing
    if (_state == GameState.playing) {
      _switchPlayer();
    }

    return true;
  }

  /// Checks if a move at the specified position is valid
  bool isValidMove(int row, int col) {
    // Check if game is still playing
    if (_state != GameState.playing) {
      return false;
    }

    // Check bounds
    if (row < 0 || row >= 3 || col < 0 || col >= 3) {
      return false;
    }

    // Check if cell is empty
    return _board[row][col] == CellState.empty;
  }

  /// Gets all valid move positions
  List<Position> getValidMoves() {
    final validMoves = <Position>[];

    if (_state != GameState.playing) {
      return validMoves;
    }

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (_board[row][col] == CellState.empty) {
          validMoves.add(Position(row, col));
        }
      }
    }

    return validMoves;
  }

  /// Checks for game end and returns the result if game is over
  GameResult? checkGameEnd() {
    if (_state != GameState.finished) {
      return null;
    }

    final winningPositions = _winDetector.getWinningPositions(_board);

    if (winningPositions != null) {
      // Someone won
      final winnerMark =
          _board[winningPositions.first.row][winningPositions.first.col];
      return GameResult(
        outcome: GameOutcome.win,
        winner: Player.human, // This will be determined by the caller
        winningPositions: winningPositions,
        timestamp: DateTime.now(),
      );
    } else {
      // Draw
      return GameResult(
        outcome: GameOutcome.draw,
        winner: null,
        winningPositions: null,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Resets the board to empty state
  void resetBoard({CellState? initialPlayer}) {
    _board = List.generate(3, (_) => List.filled(3, CellState.empty));
    _state = GameState.playing;
    _currentPlayer = initialPlayer ?? CellState.x;
    _moveHistory.clear();
  }

  /// Undoes the last move
  /// Returns true if undo was successful, false if no moves to undo
  bool undoMove() {
    final lastMove = _moveHistory.popMove();
    if (lastMove == null) {
      return false;
    }

    // Restore board state
    _board = _moveHistory.reconstructBoardAt(_moveHistory.length - 1);

    // If board is empty, use initial state
    if (_moveHistory.isEmpty) {
      _board = List.generate(3, (_) => List.filled(3, CellState.empty));
    }

    // Reset game state to playing
    _state = GameState.playing;

    // Determine current player based on move count
    final moveCount = _moveHistory.length;
    _currentPlayer = moveCount % 2 == 0 ? CellState.x : CellState.o;

    return true;
  }

  /// Switches the current player
  void _switchPlayer() {
    _currentPlayer = _currentPlayer == CellState.x ? CellState.o : CellState.x;
  }

  /// Loads a board state from move history
  void loadFromHistory(
    List<Move> moves, {
    CellState initialPlayer = CellState.x,
  }) {
    resetBoard(initialPlayer: initialPlayer);

    for (final move in moves) {
      makeMove(move.row, move.col);
    }
  }

  /// Creates a copy of the current board
  List<List<CellState>> copyBoard() {
    return List.generate(3, (row) => List.from(_board[row]));
  }
}
