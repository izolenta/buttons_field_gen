class BoardCell
{
  int color;
  bool isMarked = false;
  bool isExcluded = false;
  final int x;
  final int y;

  BoardCell(this.color, this.x, this.y);
}