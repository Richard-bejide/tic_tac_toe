import 'package:flutter/material.dart';
import 'game_button.dart';
import 'custom_dialog.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonsList;
  List<int> player1; //stores the IDs of player 1  chosen square tiles
  List<int> player2; //stores the IDs of player 2  chosen square tiles
  int activePlayer; //current player

  @override
  void initState() {
    super.initState();
    buttonsList = doInit();
  }

  List<GameButton> doInit() {
    player1 = [];
    player2 = [];
    activePlayer = 1; //player1 will be the first player

    var gameButtons = <GameButton>[
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9),
    ];

    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = 'X'; //changes tile title to X
        gb.bg = Colors.red; //changes tile color to red
        activePlayer = 2; //changes active player to 2
        player1.add(gb.id); //stores tile ID  in player1
      } else {
        //i.e if active player is 2
        gb.text = '0';
        gb.bg = Colors.black;
        activePlayer = 1;
        player2.add(gb.id);
      }

      gb.enabled =
          false; //changes enabled property to false so that each tile can only be pressed once

      if (checkWinner() == -1) {
        //i.e if game is still ongoing
        if (buttonsList.every((p) => p.text != '')) {
          // i.e  if all tiles have been pressed
          showDialog(
              context: context,
              builder: (_) => CustomDialog(
                  title: ' Game Tied',
                  content: 'Press the reset button to start again',
                  callback: resetGame));
        } else {
          activePlayer == 2
              ? autoPlay()
              : null; //calls autoPlay if activePlayer is 2
        }
      }
    });
  }

  void autoPlay() {
    var emptyCells = new List();
    var list = new List.generate(9, (i) => i + 1);
    for (var cellID in list) {
      if (!(player1.contains(cellID) || player2.contains(cellID))) {
        emptyCells.add(cellID);
      }
    }

    var r = new Random();
    var randIndex = r.nextInt(emptyCells.length - 1);
    var cellID = emptyCells[randIndex];
    int i = buttonsList.indexWhere((p) => p.id == cellID);
    playGame(buttonsList[i]);
  }

  int checkWinner() {
    int winner = -1;
    if (player1.contains(1) && player1.contains(2) && player1.contains(3)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(2) && player2.contains(3)) {
      winner = 2;
    }

    // row 2
    if (player1.contains(4) && player1.contains(5) && player1.contains(6)) {
      winner = 1;
    }
    if (player2.contains(4) && player2.contains(5) && player2.contains(6)) {
      winner = 2;
    }

    // row 3
    if (player1.contains(7) && player1.contains(8) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(7) && player2.contains(8) && player2.contains(9)) {
      winner = 2;
    }

    // col 1
    if (player1.contains(1) && player1.contains(4) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(4) && player2.contains(7)) {
      winner = 2;
    }

    // col 2
    if (player1.contains(2) && player1.contains(5) && player1.contains(8)) {
      winner = 1;
    }
    if (player2.contains(2) && player2.contains(5) && player2.contains(8)) {
      winner = 2;
    }

    // col 3
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }

    //diagonal
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }

    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }
    if (winner != -1) {
      if (winner == 1) {
        showDialog(
            context: context,
            builder: (_) => CustomDialog(
                title: 'Player 1 won',
                content: 'Press the reset button to start again',
                callback: resetGame));
      } else {
        showDialog(
            context: context,
            builder: (_) => CustomDialog(
                title: 'Player 2 won',
                content: 'Press the reset button to start again',
                callback: resetGame));
      }
    }

    return winner;
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      buttonsList = doInit(); //re initializes buttonsList
    });
  }

  Padding _gameRules(String rule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      child: Text(rule,
          style: TextStyle(
              fontSize: 18.0, letterSpacing: 1.0, fontWeight: FontWeight.bold)),
    );
  }

  FlatButton _helpButton() {
    return FlatButton(
      child: Icon(
        Icons.help,
        color: Colors.white,
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                title: Text('RULES FOR TIC-TAC-TOE'),
                content: Column(children: <Widget>[
                  _gameRules(
                      "1. The game is played on a grid that\'s 3 squares by 3 squares."),
                  _gameRules(
                      " 2. You are X, your friend (or the computer in this case) is O. Players take turns putting their marks in empty squares."),
                  _gameRules(
                      "3. The first player to get 3 of her marks in a row (up, down, across, or diagonally) is the winner."),
                  _gameRules(
                      "4. When all 9 squares are full, the game is over. If no player has 3 marks in a row, the game ends in a tie."),
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          child: Text('Back',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 21.0,
                                  fontWeight: FontWeight.w900)),
                          onTap: () {
                            Navigator.pop(context);
                          }))
                ])));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tic-Tac-Toe'),
          actions: [_helpButton()],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                //Creates a scrollable, 2D array of widgets that are
                //created on demand The constructor is appropriate for
                //grid views with a large (or infinite) number of children
                //because the builder is called only for those children that are actually visible
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 60.0),
                  itemCount: buttonsList.length,
                  itemBuilder: (context, i) => SizedBox(
                      height: 100.0,
                      width: 100.0,
                      child: RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        onPressed: () {
                          //calls playGame if tile has not been pressed
                          buttonsList[i].enabled
                              ? playGame(buttonsList[i])
                              : null;
                        },
                        child: Text(buttonsList[i].text,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0)),
                        color: buttonsList[i].bg,
                        // disabledColor: buttonsList[i].bg,
                      )),
                  //Creates a delegate that makes grid layouts with a fixed number of tiles in the cross axis
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 9.0,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 9.0),
                ),
              ),
              RaisedButton(
                  onPressed: () {
                    setState(() {
                      buttonsList = doInit();
                    });
                  },
                  child: Text('Reset',
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  color: Colors.red,
                  padding: EdgeInsets.all(20.0))
            ]));
  }
}
