import 'dart:math';

class Minefield {
  final int rows;
  final int cols;
  final int mines;
  late List<List<Cell>> grid;
  bool gameOver = false;

  Minefield({required this.rows, required this.cols, required this.mines}) {
    grid = List.generate(rows, (r) => List.generate(cols, (c) => Cell(row: r, col: c)));
    _placeMines();
    _calculateNumbers();
  }

  void _placeMines() {
    int placedMines = 0;
    Random random = Random();
    while (placedMines < mines) {
      int row = random.nextInt(rows);
      int col = random.nextInt(cols);
      if (!grid[row][col].isMine) {
        grid[row][col].isMine = true;
        placedMines++;
      }
    }
  }

  void _calculateNumbers() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!grid[r][c].isMine) {
          grid[r][c].numberOfMines = _countAdjacentMines(r, c);
        }
      }
    }
  }

  int _countAdjacentMines(int row, int col) {
    int count = 0;
    for (int r = row - 1; r <= row + 1; r++) {
      for (int c = col - 1; c <= col + 1; c++) {
        if (r >= 0 && r < rows && c >= 0 && c < cols && grid[r][c].isMine) {
          count++;
        }
      }
    }
    return count;
  }

  void revealCell(int row, int col) {
    if (grid[row][col].isRevealed || grid[row][col].isFlagged || gameOver) return;
    grid[row][col].isRevealed = true;

    if (grid[row][col].isMine) {
      gameOver = true;
    } else if (grid[row][col].numberOfMines == 0) {
      for (int r = row - 1; r <= row + 1; r++) {
        for (int c = col - 1; c <= col + 1; c++) {
          if (r >= 0 && r < rows && c >= 0 && c < cols) {
            revealCell(r, c);
          }
        }
      }
    }
  }

  void toggleFlag(int row, int col) {
    if (!grid[row][col].isRevealed) {
      grid[row][col].isFlagged = !grid[row][col].isFlagged;
    }
  }
}

class Cell {
  final int row;
  final int col;
  bool isMine = false;
  bool isRevealed = false;
  bool isFlagged = false;
  int numberOfMines = 0;

  Cell({required this.row, required this.col});
}
