import 'package:buttons_field_gen/src/util/board/board.dart';

class BoardSolver
{
  List<int> _turnsFound;
  int _cellsOpen;
  Board _currentBoard;
  List<int> trySolveBoard(Board board, int depth) {
    var turns = new List<int>();
    _currentBoard = board.clone();
    while (!_currentBoard.isBoardSolved())
    {
      _cellsOpen = board.markedCount;
      _turnsFound = new List<int>();
      _makeStep(_currentBoard, depth, new List<int>());
      //turns.addAll(_turnsFound);
      _currentBoard.makeTurn(_turnsFound.first);
      turns.add(_turnsFound.first);
    }
    return turns;
  }

  void _makeStep(Board board, int depth, List<int> turns)
  {
    for (int i = 0; i < 6; i++) {
      List<int> turnsClone = turns.toList();
      if (i == board.activeColor) continue;
      Board clone = board.clone();
      clone.makeTurn(i);
      var marked = clone.markedCount;
      if (marked > board.markedCount) {
        turnsClone.add(i);
        if (_cellsOpen < marked || (_cellsOpen == marked && _turnsFound.length > turnsClone.length)) {
          _cellsOpen = marked;
          _turnsFound = turnsClone.toList();
          //_currentBoard = clone.clone();
        }
        if (depth > 1) {
          _makeStep(clone, depth - 1, turnsClone);
        }
      }
    }
  }
}