import 'package:flutter/material.dart';
import 'package:tictactoe_tutorial/ui/theme/color.dart';
import 'package:tictactoe_tutorial/utils/game_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0; // to check the draw
  String result = "";
  List<int> scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
  List<int>? winningIndices;
  String startingPlayer = "X"; // Variable to track starting player

  Game game = Game();

  //initiate the GameBoard
  @override
  void initState() {
    super.initState();
    game.board = Game.initGameBoard();
    lastValue = startingPlayer; // Set the starting player
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "It's ${lastValue} turn".toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 58,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Stack(
            children: [
              Container(
                width: boardWidth,
                height: boardWidth,
                child: GridView.count(
                  crossAxisCount: Game.boardlength ~/ 3,
                  padding: EdgeInsets.all(16.0),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  children: List.generate(Game.boardlength, (index) {
                    return InkWell(
                      onTap: gameOver
                          ? null
                          : () {
                              if (game.board![index] == "") {
                                setState(() {
                                  game.board![index] = lastValue;
                                  turn++;
                                  winningIndices = game.winnerCheck(
                                      lastValue, index, scoreboard, 3);
                                  gameOver = winningIndices != null;

                                  if (gameOver) {
                                    result = "$lastValue is the Winner";
                                  } else if (!gameOver && turn == 9) {
                                    result = "It's a Draw!";
                                    gameOver = true;
                                  }
                                  lastValue = lastValue == "X" ? "O" : "X";
                                });
                              }
                            },
                      child: Container(
                        width: Game.blocSize,
                        height: Game.blocSize,
                        decoration: BoxDecoration(
                          color: MainColor.secondaryColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Center(
                          child: Text(
                            game.board![index],
                            style: TextStyle(
                              color: game.board![index] == "X"
                                  ? Colors.blue
                                  : Colors.pink,
                              fontSize: 64.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              if (winningIndices != null)
                CustomPaint(
                  size: Size(boardWidth, boardWidth),
                  painter: LinePainter(winningIndices!),
                ),
            ],
          ),
          SizedBox(
            height: 25.0,
          ),
          Text(
            result,
            style: TextStyle(color: Colors.white, fontSize: 54.0),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                // Toggle starting player
                startingPlayer = startingPlayer == "X" ? "O" : "X";
                // Reset the game state
                game.board = Game.initGameBoard();
                lastValue = startingPlayer;
                gameOver = false;
                turn = 0;
                result = "";
                scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
                winningIndices = null;
              });
            },
            icon: Icon(Icons.replay),
            label: Text("Repeat the Game"),
          ),
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<int> winningIndices;
  LinePainter(this.winningIndices);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    final start = getPosition(winningIndices.first, size);
    final end = getPosition(winningIndices.last, size);

    canvas.drawLine(start, end, paint);
  }

  Offset getPosition(int index, Size size) {
    double x = (index % 3) * (size.width / 3) + (size.width / 6);
    double y = (index ~/ 3) * (size.height / 3) + (size.height / 6);
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
