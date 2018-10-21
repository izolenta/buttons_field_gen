import 'dart:math';

import 'package:buttons_field_gen/src/util/board/board_cell.dart';
import 'package:buttons_field_gen/src/util/pseudo_random.dart';

class Board
{
  List<BoardCell> _cells;
  List<List<BoardCell>> _rows;
  List<BoardCell> get cells => _cells;
  List<List<BoardCell>> get rows => _rows;

  List<Point> _neighbors = [
    new Point(0, -1),
    new Point(-1, 0),
    new Point(1, 0),
    new Point(0, 1)
  ];

  int get activeColor => _cells[0].color;
  int get markedCount => _cells.where((cell) => cell.isMarked).length;

  final int size;

  int seed;

  Board(this.size, this.seed, {List<BoardCell> cells: null}) {
    if (seed == null) {
      seed = PseudoRandom.randomSeed;
    }
    if (cells != null) {
      _cells = cells;
    }
    else {
      _cells = [];
      _generateBoard(seed);
    }
    _recalculateRows();
  }

  Board clone() {
    List<BoardCell> cloneCells = [];
    _cells.forEach((cell) {
      BoardCell cloneCell = new BoardCell(cell.color, cell.x, cell.y);
      cloneCell.isMarked = cell.isMarked;
      cloneCell.isExcluded = cell.isExcluded;
      cloneCells.add(cloneCell);
    });
    return new Board(size, seed, cells: cloneCells);
  }

  bool isBoardSolved()
  {
    return markedCount == size*size;
  }

  void printBoard()
  {
    for (var j = 0; j < size; j++) {
      var line = '';
      for (var i = 0; i < size; i++) {
        var cell = _getCell(i, j);
        line+='${cell.color}${cell.isMarked? "*" : " "} ';
      }
      print(line);
    }
  }

  void makeTurn(int color)
  {
    if (color != activeColor)
    {
      for (var marked in _cells.where((cell) => cell.isMarked)) {
        marked.color = color;
      }
      _markNeighbors();
    }
  }

  void _generateBoard(int seed)
  {
    PseudoRandom rand = new PseudoRandom.fromSeed(seed);
    for (int i = 0; i < size*size; i++)
    {
      _cells.add(new BoardCell(rand.nextInt(6), i%size, (i/size).floor()));
    }
    _cells[0].isMarked = true;
    _markNeighbors();
  }

  void _markNeighbors()
  {
    var markeds = _cells.where((cell) => cell.isMarked && !cell.isExcluded).toList();
    markeds.forEach((cell) => _markAround(cell));
  }

  void _markAround(BoardCell boardCell)
  {
    int excluded = 0;
    for (var neighborShift in _neighbors)
    {
      var x = boardCell.x + neighborShift.x;
      var y = boardCell.y + neighborShift.y;
      if (x < 0 || x >= size || y < 0 || y >= size) {
        excluded++;
        continue;
      };
      var cell = _getCell(x, y);
      if (cell.isMarked) {
        excluded++;
        continue;
      }
      if (cell.color != boardCell.color) continue;

      cell.isMarked = true;
      _markAround(cell);
    };
    boardCell.isExcluded = excluded == 4;
  }

  BoardCell _getCell(int x, int y) {
    return _cells[y * size + x];
  }

  void _recalculateRows() {
    _rows = [];
    for (int i=0; i<size; i++) {
      _rows.add(_cells.sublist(i*size, i*size+size));
    }
  }
}