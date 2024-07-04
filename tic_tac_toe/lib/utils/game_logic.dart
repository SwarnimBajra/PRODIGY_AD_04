class Player {
  static const x = "X";
  static const o = "O";
  static const empty = "";
}

class Game {
  static final boardlength = 9; // board of 3*3 blocks;
  static final blocSize = 100.0;

  //Creating the empty board
  List<String>? board;

  static List<String>? initGameBoard() =>
      List.generate(boardlength, (index) => Player.empty);

  List<int>? winnerCheck(
      String player, int index, List<int> scoreboard, int gridSize) {
    int row = index ~/ 3;
    int col = index % 3;
    int score = player == "X" ? 1 : -1;

    scoreboard[row] += score;
    scoreboard[gridSize + col] += score;
    if (row == col) scoreboard[2 * gridSize] += score;
    if (gridSize - 1 - col == row) scoreboard[2 * gridSize + 1] += score;

    if (scoreboard.contains(3) || scoreboard.contains(-3)) {
      if (scoreboard[row] == 3 || scoreboard[row] == -3) {
        return List.generate(3, (i) => row * 3 + i);
      }
      if (scoreboard[gridSize + col] == 3 || scoreboard[gridSize + col] == -3) {
        return List.generate(3, (i) => i * 3 + col);
      }
      if (scoreboard[2 * gridSize] == 3 || scoreboard[2 * gridSize] == -3) {
        return List.generate(3, (i) => i * 3 + i);
      }
      if (scoreboard[2 * gridSize + 1] == 3 ||
          scoreboard[2 * gridSize + 1] == -3) {
        return List.generate(3, (i) => (i + 1) * 3 - i - 1);
      }
    }
    return null;
  }
}
