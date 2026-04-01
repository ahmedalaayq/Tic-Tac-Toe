import 'dart:async';
import 'dart:math' as math;
import 'package:rxdart/rxdart.dart';

enum BoardState { done, play }

class BoardService {
  late BehaviorSubject<List<List<String>>> _board;
  BehaviorSubject<List<List<String>>> get board$ => _board;

  late BehaviorSubject<String> _player;
  BehaviorSubject<String> get player$ => _player;

  late BehaviorSubject<MapEntry<BoardState, String>> _boardState$;
  BehaviorSubject<MapEntry<BoardState, String>> get boardState$ => _boardState$;

  late BehaviorSubject<MapEntry<int, int>> _score$;
  BehaviorSubject<MapEntry<int, int>> get score$ => _score$;

  late String _start;
  bool _isProcessing = false;
  Timer? _botMoveTimer;

  BoardService() {
    _initStreams();
  }

  void setStart(String player) {
    _start = player;
    _player.add(player);
  }

  void newMove(int i, int j) {
    // ✅ FIXED: Prevent moves during processing or game over
    if (_boardState$.value.key != BoardState.play || _isProcessing) return;

    final board = _cloneBoard();

    // ✅ FIXED: Check if cell is already occupied
    if (board[i][j] != ' ') return;

    _isProcessing = true;

    final player = _player.value;
    board[i][j] = player;
    _board.add(board);

    if (_checkWinner(i, j, board)) {
      _endGame(player);
      return;
    }

    if (isBoardFull(board)) {
      _endGame('');
      return;
    }

    switchPlayer();

    // ✅ FIXED: Add proper delay before bot move
    _botMoveTimer?.cancel();
    _botMoveTimer = Timer(const Duration(milliseconds: 500), () {
      _isProcessing = false;
      if (_boardState$.value.key == BoardState.play) {
        botMove();
      }
    });
  }

  void botMove() {
    // ✅ FIXED: Double-check state before bot moves
    if (_boardState$.value.key != BoardState.play || _isProcessing) return;

    _isProcessing = true;

    final board = _cloneBoard();
    final player = _player.value;

    final emptyCells = <List<int>>[];

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == ' ') {
          emptyCells.add([i, j]);
        }
      }
    }

    if (emptyCells.isEmpty) {
      _isProcessing = false;
      return;
    }

    // ✅ IMPROVED: Check for winning move first
    for (var cell in emptyCells) {
      final testBoard = _cloneBoard();
      testBoard[cell[0]][cell[1]] = player;

      if (_checkWinner(cell[0], cell[1], testBoard)) {
        _applyBotMove(cell[0], cell[1]);
        return;
      }
    }

    // ✅ IMPROVED: Check for blocking opponent's winning move
    final opponent = player == 'X' ? 'O' : 'X';
    for (var cell in emptyCells) {
      final testBoard = _cloneBoard();
      testBoard[cell[0]][cell[1]] = opponent;

      if (_checkWinner(cell[0], cell[1], testBoard)) {
        _applyBotMove(cell[0], cell[1]);
        return;
      }
    }

    // ✅ IMPROVED: Prefer center, then corners, then edges
    final center = [1, 1];
    if (board[center[0]][center[1]] == ' ') {
      _applyBotMove(center[0], center[1]);
      return;
    }

    final corners = [
      [0, 0],
      [0, 2],
      [2, 0],
      [2, 2],
    ];
    final availableCorners = corners
        .where((c) => board[c[0]][c[1]] == ' ')
        .toList();
    if (availableCorners.isNotEmpty) {
      final corner =
          availableCorners[math.Random().nextInt(availableCorners.length)];
      _applyBotMove(corner[0], corner[1]);
      return;
    }

    // Fallback to random
    final rnd = math.Random();
    final move = emptyCells[rnd.nextInt(emptyCells.length)];
    _applyBotMove(move[0], move[1]);
  }

  void _applyBotMove(int i, int j) {
    final board = _cloneBoard();
    final player = _player.value;

    board[i][j] = player;
    _board.add(board);

    if (_checkWinner(i, j, board)) {
      _endGame(player);
      return;
    }

    if (isBoardFull(board)) {
      _endGame('');
      return;
    }

    switchPlayer();
    _isProcessing = false;
  }

  void _endGame(String winner) {
    _isProcessing = false;
    _botMoveTimer?.cancel();

    if (winner.isNotEmpty) {
      _updateScore(winner);
    }
    _boardState$.add(MapEntry(BoardState.done, winner));
  }

  void _updateScore(String winner) {
    final current = _score$.value;
    if (winner == 'O') {
      _score$.add(MapEntry(current.key, current.value + 1));
    } else if (winner == 'X') {
      _score$.add(MapEntry(current.key + 1, current.value));
    }
  }

  bool _checkWinner(int x, int y, List<List<String>> board) {
    final player = board[x][y];
    if (player == ' ') return false;

    // Check row
    if (board[x].every((e) => e == player)) return true;

    // Check column
    if (board.every((row) => row[y] == player)) return true;

    // Check diagonal
    if (x == y &&
        List.generate(3, (i) => board[i][i]).every((e) => e == player)) {
      return true;
    }

    // Check anti-diagonal
    if (x + y == 2 &&
        List.generate(3, (i) => board[i][2 - i]).every((e) => e == player)) {
      return true;
    }

    return false;
  }

  bool isBoardFull(List<List<String>> board) {
    return board.every((row) => row.every((cell) => cell != ' '));
  }

  List<List<String>> _cloneBoard() {
    return _board.value.map((row) => List<String>.from(row)).toList();
  }

  void resetBoard() {
    _isProcessing = false;
    _botMoveTimer?.cancel();

    _board.add([
      [' ', ' ', ' '],
      [' ', ' ', ' '],
      [' ', ' ', ' '],
    ]);

    _player.add(_start);
    _boardState$.add(const MapEntry(BoardState.play, ''));

    // If bot starts, add delay
    if (_start == 'O') {
      _botMoveTimer = Timer(const Duration(milliseconds: 800), () {
        if (_boardState$.value.key == BoardState.play) {
          botMove();
        }
      });
    }
  }

  void newGame() {
    _botMoveTimer?.cancel();
    _isProcessing = false;
    resetBoard();
    _score$.add(const MapEntry(0, 0));
  }

  void _initStreams() {
    _board = BehaviorSubject.seeded([
      [' ', ' ', ' '],
      [' ', ' ', ' '],
      [' ', ' ', ' '],
    ]);

    _player = BehaviorSubject.seeded('X');
    _boardState$ = BehaviorSubject.seeded(const MapEntry(BoardState.play, ''));
    _score$ = BehaviorSubject.seeded(const MapEntry(0, 0));
    _start = 'X';
  }

  void switchPlayer() {
    final current = _player.value;
    _player.add(current == 'X' ? 'O' : 'X');
  }

  void dispose() {
    _botMoveTimer?.cancel();
    _board.close();
    _player.close();
    _boardState$.close();
    _score$.close();
  }
}
