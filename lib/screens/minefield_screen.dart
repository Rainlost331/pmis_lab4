import 'package:flutter/material.dart';
import 'package:personal_information_manager/models/minefield.dart';

class MinefieldScreen extends StatefulWidget {
  @override
  _MinefieldScreenState createState() => _MinefieldScreenState();
}

class _MinefieldScreenState extends State<MinefieldScreen> {
  late Minefield minefield;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      minefield = Minefield(rows: 10, cols: 10, mines: 10);
    });
  }

  Widget _buildGrid() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(minefield.rows, (row) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(minefield.cols, (col) {
            final cell = minefield.grid[row][col];
            return GestureDetector(
              onTap: () {
                setState(() {
                  minefield.revealCell(row, col);
                });
              },
              onLongPress: () {
                setState(() {
                  minefield.toggleFlag(row, col);
                });
              },
              child: Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: cell.isRevealed ? (cell.isMine ? Colors.red : Colors.grey) : Colors.blue,
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: cell.isRevealed
                      ? cell.isMine
                      ? Icon(Icons.clear, color: Colors.black)
                      : Text(cell.numberOfMines > 0 ? cell.numberOfMines.toString() : '')
                      : cell.isFlagged
                      ? Icon(Icons.flag, color: Colors.yellow)
                      : null,
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minefield Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGrid(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNewGame,
              child: Text('New Game'),
            ),
          ],
        ),
      ),
    );
  }
}
