/// Represents the state of a cell on the tic-tac-toe board
enum CellState {
  empty,
  x,
  o;

  /// Converts CellState to string representation
  String toSymbol() {
    switch (this) {
      case CellState.empty:
        return ' ';
      case CellState.x:
        return 'X';
      case CellState.o:
        return 'O';
    }
  }

  /// Creates CellState from string representation
  static CellState fromSymbol(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'X':
        return CellState.x;
      case 'O':
        return CellState.o;
      default:
        return CellState.empty;
    }
  }

  /// Converts CellState to JSON
  String toJson() => name;

  /// Creates CellState from JSON
  static CellState fromJson(String json) {
    return CellState.values.firstWhere(
      (e) => e.name == json,
      orElse: () => CellState.empty,
    );
  }
}
