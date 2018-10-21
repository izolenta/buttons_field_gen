import 'package:buttons_field_gen/src/util/board/board.dart';
import 'package:buttons_field_gen/src/util/board/board_solver.dart';
import 'package:buttons_field_gen/src/util/pseudo_random.dart';

class FieldIndexGenerator {
  static int generate(int size, int minTurns) {
    PseudoRandom rand = new PseudoRandom();
    int next = rand.nextInt(999999999);
    while (true) {
      BoardSolver solver = new BoardSolver();
      Board board = new Board(size, next);
      List<int> turns = solver.trySolveBoard(board, 5);
      if (turns.length <= minTurns) {
        return next;
      }
      next++;
    }
  }
}
