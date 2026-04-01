import '../models/cell_state.dart';
import '../models/position.dart';

/// Detects winning conditions and draw states on the tic-tac-toe board
class WinDetector {
  /// Checks if the last move at (row, col) resulted in a win
  bool checkWin(List<List<CellState>> board, int row, int col) {
    final mark = board[row][col];

    // Can't win with an empty cell
    if (mark == CellState.empty) {
      return false;
    }

    return checkRow(board, row, mark) ||
        checkColumn(board, col, mark) ||
        checkDiagonal(board, mark) ||
        checkAntiDiagonal(board, mark);
  }

  /// Checks if the specified row has three matching marks
  bool checkRow(List<List<CellState>> board, int row, CellState mark) {
    for (int col = 0; col < board[row].length; col++) {
      if (board[row][col] != mark) {
        return false;
      }
    }
    return true;
  }

  /// Checks if the specified column has three matching marks
  bool checkColumn(List<List<CellState>> board, int col, CellState mark) {
    for (int row = 0; row < board.length; row++) {
      if (board[row][col] != mark) {
        return false;
      }
    }
    return true;
  }

  /// Checks if the main diagonal (top-left to bottom-right) has three matching marks
  bool checkDiagonal(List<List<CellState>> board, CellState mark) {
    for (int i = 0; i < board.length; i++) {
      if (board[i][i] != mark) {
        return false;
      }
    }
    return true;
  }

  /// Checks if the anti-diagonal (top-right to bottom-left) has three matching marks
  bool checkAntiDiagonal(List<List<CellState>> board, CellState mark) {
    final n = board.length;
    for (int i = 0; i < n; i++) {
      if (board[i][n - 1 - i] != mark) {
        return false;
      }
    }
    return true;
  }

  /// Gets the winning positions if the game is won, null otherwise
  List<Position>? getWinningPositions(List<List<CellState>> board) {
    final n = board.length;

    // Check rows
    for (int row = 0; row < n; row++) {
      final mark = board[row][0];
      if (mark != CellState.empty && checkRow(board, row, mark)) {
        return List.generate(n, (col) => Position(row, col));
      }
    }

    // Check columns
    for (int col = 0; col < n; col++) {
      final mark = board[0][col];
      if (mark != CellState.empty && checkColumn(board, col, mark)) {
        return List.generate(n, (row) => Position(row, col));
      }
    }

    // Check main diagonal
    final diagMark = board[0][0];
    if (diagMark != CellState.empty && checkDiagonal(board, diagMark)) {
      return List.generate(n, (i) => Position(i, i));
    }

    // Check anti-diagonal
    final antiDiagMark = board[0][n - 1];
    if (antiDiagMark != CellState.empty &&
        checkAntiDiagonal(board, antiDiagMark)) {
      return List.generate(n, (i) => Position(i, n - 1 - i));
    }

    return null;
  }

  /// Checks if the board is completely filled (no empty cells)
  bool isBoardFull(List<List<CellState>> board) {
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        if (board[row][col] == CellState.empty) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if the game is a draw (board full with no winner)
  bool isDraw(List<List<CellState>> board) {
    return isBoardFull(board) && getWinningPositions(board) == null;
  }
}
