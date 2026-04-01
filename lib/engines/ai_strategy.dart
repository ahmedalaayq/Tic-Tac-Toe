import 'dart:math' as math;
import '../models/cell_state.dart';
import '../models/position.dart';
import 'win_detector.dart';

/// Abstract strategy for AI move selection
abstract class AIStrategy {
  /// Selects the best move for the AI given the current board state
  Position selectMove(List<List<CellState>> board, CellState aiMark);
}

/// Easy AI that makes random valid moves
class EasyAI implements AIStrategy {
  final math.Random _random;

  EasyAI({math.Random? random}) : _random = random ?? math.Random();

  @override
  Position selectMove(List<List<CellState>> board, CellState aiMark) {
    final validMoves = _getValidMoves(board);
    
    if (validMoves.isEmpty) {
      throw StateError('No valid moves available');
    }

    return validMoves[_random.nextInt(validMoves.length)];
  }

  List<Position> _getValidMoves(List<List<CellState>> board) {
    final moves = <Position>[];
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        if (board[row][col] == CellState.empty) {
          moves.add(Position(row, col));
        }
      }
    }
    return moves;
  }
}

/// Medium AI that plays optimally 50% of the time, randomly otherwise
class MediumAI implements AIStrategy {
  final math.Random _random;
  final HardAI _hardAI;
  final EasyAI _easyAI;

  MediumAI({math.Random? random})
      : _random = random ?? math.Random(),
        _hardAI = HardAI(),
        _easyAI = EasyAI(random: random);

  @override
  Position selectMove(List<List<CellState>> board, CellState aiMark) {
    // 50% chance to play optimally, 50% chance to play randomly
    if (_random.nextDouble() < 0.5) {
      return _hardAI.selectMove(board, aiMark);
    } else {
      return _easyAI.selectMove(board, aiMark);
    }
  }
}

/// Hard AI that uses minimax algorithm with alpha-beta pruning for optimal play
class HardAI implements AIStrategy {
  final WinDetector _winDetector = WinDetector();

  @override
  Position selectMove(List<List<CellState>> board, CellState aiMark) {
    final opponentMark = aiMark == CellState.x ? CellState.o : CellState.x;
    
    Position? bestMove;
    int bestScore = -1000;

    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        if (board[row][col] == CellState.empty) {
          // Try this move
          board[row][col] = aiMark;
          
          // Calculate score using minimax
          final score = _minimax(board, 0, false, aiMark, opponentMark, -1000, 1000);
          
          // Undo move
          board[row][col] = CellState.empty;
          
          // Update best move
          if (score > bestScore) {
            bestScore = score;
            bestMove = Position(row, col);
          }
        }
      }
    }

    if (bestMove == null) {
      throw StateError('No valid moves available');
    }

    return bestMove;
  }

  /// Minimax algorithm with alpha-beta pruning
  int _minimax(
    List<List<CellState>> board,
    int depth,
    bool isMaximizing,
    CellState aiMark,
    CellState opponentMark,
    int alpha,
    int beta,
  ) {
    // Check terminal states
    final score = _evaluateBoard(board, aiMark, opponentMark);
    if (score != 0) {
      return score - depth; // Prefer faster wins
    }

    if (_winDetector.isBoardFull(board)) {
      return 0; // Draw
    }

    if (isMaximizing) {
      int maxScore = -1000;
      
      for (int row = 0; row < board.length; row++) {
        for (int col = 0; col < board[row].length; col++) {
          if (board[row][col] == CellState.empty) {
            board[row][col] = aiMark;
            final score = _minimax(board, depth + 1, false, aiMark, opponentMark, alpha, beta);
            board[row][col] = CellState.empty;
            
            maxScore = math.max(maxScore, score);
            alpha = math.max(alpha, score);
            
            if (beta <= alpha) {
              break; // Beta cutoff
            }
          }
        }
      }
      
      return maxScore;
    } else {
      int minScore = 1000;
      
      for (int row = 0; row < board.length; row++) {
        for (int col = 0; col < board[row].length; col++) {
          if (board[row][col] == CellState.empty) {
            board[row][col] = opponentMark;
            final score = _minimax(board, depth + 1, true, aiMark, opponentMark, alpha, beta);
            board[row][col] = CellState.empty;
            
            minScore = math.min(minScore, score);
            beta = math.min(beta, score);
            
            if (beta <= alpha) {
              break; // Alpha cutoff
            }
          }
        }
      }
      
      return minScore;
    }
  }

  /// Evaluates the board state
  /// Returns 10 if AI wins, -10 if opponent wins, 0 otherwise
  int _evaluateBoard(List<List<CellState>> board, CellState aiMark, CellState opponentMark) {
    // Check all possible winning positions
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        if (board[row][col] != CellState.empty) {
          if (_winDetector.checkWin(board, row, col)) {
            return board[row][col] == aiMark ? 10 : -10;
          }
        }
      }
    }
    
    return 0;
  }
}
