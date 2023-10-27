import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GameWidget extends StatefulWidget {
  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  late double playerX;
  double playerSpeed = 5.0;
  List<Obstacle> obstacles = [];
  double maxYSpacing = 200; // Adjust this value to control the vertical spacing
  double minXSpacing = 150; // Adjust this value to control the minimum horizontal spacing
  Random random = Random();
  bool gameOver = false;
  double obstacleSpeed = 5.0;
  int elapsedTime = 0; // Track the time elapsed

  bool isIncreasingSpeed = false;
  double initialSpeed = 5.0;
  int speedIncreaseInterval = 50; //


  int currentScore = 0;
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    playerX = 150;
    loadHighScore();

    addObstacles();
    startGameLoop();
  }

  //storing hif=ghscire

  void loadHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore_spacegame') ?? 0;
    });
  }

  void saveHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore_spacegame', highScore);
  }

  // Update the high score and save it if needed
  void updateHighScore() {
    if (currentScore > highScore) {
      highScore = currentScore;
      saveHighScore();
    }
  }


  void addObstacles() {
    obstacles.clear(); // Clear existing obstacles
    double initialY = -200; // Set the initial Y-axis position
    double lastX = -100; // Initialize with a value to ensure initial spacing

    for (var i = 0; i < 5; i++) {
      double randomX = lastX + minXSpacing + random.nextDouble() * 50; // Generate random X-axis value with minimum spacing
      double randomY = random.nextDouble() * 200 - 400; // Generate random Y-axis value within a specified range
      obstacles.add(Obstacle(randomX, initialY, obstacleSpeed));
      lastX = randomX;
      initialY -= maxYSpacing; // Adjust Y-axis spacing for the next obstacle
    }
  }

  void startGameLoop() {
    Future.delayed(Duration(milliseconds: 20), () {
      if (!gameOver) {
        setState(() {
          updateGame();
          startGameLoop();
        });
      }
    });
  }

  void updateGame() {
    setState(() {
      if (gameOver) {
        // When the game is over, reset obstacles immediately and wait a bit before removing the "Game Over" state
        obstacles.forEach((obstacle) {
          obstacle.updatePosition();
          if (obstacle.y > 610) {
            obstacle.y = -200;
            obstacle.x = random.nextDouble() * 350;
            obstacle.speed = obstacleSpeed; // Update the speed of the obstacle
          }
        });

        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            gameOver = false;
          });
        });
      } else {
        elapsedTime += 20; // Increment the time elapsed (20 milliseconds per game loop)

        if (elapsedTime >= speedIncreaseInterval && !isIncreasingSpeed) {
          // Increase speed every speedIncreaseInterval milliseconds
          obstacleSpeed += 0.5; // Increase the speed by 1.0, you can adjust this value
          currentScore +=10;
          isIncreasingSpeed = true; // Mark that the speed has been increased
          print('Elapsed Time: ${elapsedTime / 1000} seconds');
          print('Obstacle Speed: $obstacleSpeed');

          // Update the speed of existing obstacles
          for (var obstacle in obstacles) {
            obstacle.speed = obstacleSpeed;
          }
        }

        if (elapsedTime >= 1000) {
          // Reset the elapsed time after 1 second (1000 milliseconds)
          elapsedTime = 0;
          isIncreasingSpeed = false;// Reset the speed increase flag
        }

        for (var obstacle in obstacles) {
          obstacle.updatePosition();
          if (obstacle.y > 800) {
            obstacle.y = -200;
            obstacle.x = random.nextDouble() * 350;
            obstacle.speed = obstacleSpeed; // Update the speed of the obstacle
          }

          if (obstacle.collidesWithPlayer(playerX)) {
            setState(() {
              gameOver = true;
              updateHighScore();

            });

            break;
          }
        }
      }
    });
  }

  void restartGame() {
    currentScore=0;
    obstacles.clear();
    playerX = 150;
    addObstacles(); // Add obstacles when restarting the game
    startGameLoop();
    gameOver = false;
    elapsedTime = 0; // Reset the time elapsed
    obstacleSpeed = 2.0; // Reset obstacle speed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            playerX += details.delta.dx;
          });
        },
        onTap: () {
          if (gameOver) {

            restartGame();
          }
        },
        child: Stack(
          children: [
            Container(
              color: Colors.black,
            ),
            Positioned(
              child: RotatedBox(
                  quarterTurns: 3,
                  child: Transform.scale(
                      scale: 1,
                      child: Image.asset("assets/starbg.gif"))
              ),
            ),
            Positioned(
              top: 170,
              child: RotatedBox(
                  quarterTurns: 3,
                  child: Transform.scale(
                      scale: 1,
                      child: Image.asset("assets/starbg.gif"))
              ),
            ),
            Positioned(
              top: 460,
              child: RotatedBox(
                  quarterTurns: 3,
                  child: Transform.scale(
                      scale: 1,
                      child: Image.asset("assets/starbg.gif"))
              ),
            ),

            CustomPaint(
              size: Size(400, 700), // Adjust the height to accommodate the ground level at 650
              painter: GamePainter(playerX, obstacles, gameOver,),
            ),
            Positioned(
              top: 600,
              left: 102,
              child: Container(
                child: (gameOver
                    ? ElevatedButton(

                  onPressed: () {
                    setState(() {
                      restartGame();
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))) ,
                  ),

                  child: Text('Restart Game',style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                )
                    : null),
              ),
            ),

            Positioned(
              top: 320,
              left: MediaQuery. of(context). size. width /4.8,
              child:Container(
                // color: Colors.red,
                width: 200,
                child: Center(
                  child:  gameOver?

                  Text("GAME OVER",style: GoogleFonts.exo(color: Colors.redAccent,fontSize: 35,fontWeight: FontWeight.bold),):
                  Text("")
                  ,
                ),
              )

              ,
            ),
            Positioned(
              top: 440,
              left: MediaQuery. of(context). size. width /4.8,
              child:Container(
                // color: Colors.red,
                width: 200,
                child: Center(
                  child:  ( gameOver?

                  Text("${currentScore}",style: TextStyle(color: Colors.white,fontSize: 55,fontWeight: FontWeight.bold),):
                  Text("")),
                ),
              )

              ,
            ),
            Positioned(
              top: 145,
              left: MediaQuery. of(context). size. width /4.8,
              child:Container(
                // color: Colors.red,
                width: 200,
                child: Center(
                  child:  ( gameOver?

                  Text("${highScore}",style: TextStyle(color: Colors.white,fontSize: 80,fontWeight: FontWeight.bold),):
                  Text("")),
                ),
              )

              ,
            ),
            Positioned(
              top: 40,
              left: MediaQuery. of(context). size. width /1.5,
              child:Container(
                // color: Colors.red,
                width: 100,
                child: Center(
                  child:  ( gameOver?
                  Text(""):
                  Text("${highScore}",style: TextStyle(color: Colors.blue,fontSize: 40,fontWeight: FontWeight.bold),)

                  ),
                ),
              )

              ,
            ),
            Positioned(
              top: 110,
              left: MediaQuery. of(context). size. width /1.5,
              child:Container(
                // color: Colors.red,
                width: 100,
                child: Center(
                  child:  ( gameOver?
                  Text(""):
                  Text("${currentScore}",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),)

                  ),
                ),
              )

              ,
            ),
            Positioned(
              top: 40,
              left: 5,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))) ,
                ),
                child: Icon(CupertinoIcons.back,color: Colors.white,),
                onPressed: (){
                  GoRouter.of(context).go("/AllGames");                },
              ),
            ),


          ],
        ),
      ),
      // Show the button only when the game is over
    );
  }
}

// class GamePainter extends CustomPainter {
//   final double playerX;
//   final List<Obstacle> obstacles;
//   final bool gameOver;
//
//   GamePainter(this.playerX, this.obstacles, this.gameOver);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final playerPaint = Paint()..color = Colors.blue;
//     final obstaclePaint = Paint()..color = Colors.red;
//     final groundPaint = Paint()..color = Colors.black;
//
//
//
//
//     canvas.drawRect(Rect.fromLTWH(0, 650, size.width, 1), groundPaint); // Adjust the ground level to 650
//
//     if (!gameOver) {
//
//       canvas.drawRect(Rect.fromLTWH(playerX, 600, 50, 50), playerPaint); // Adjust the player's position
//
//       for (var obstacle in obstacles) {
//         canvas.drawRect(Rect.fromLTWH(obstacle.x, obstacle.y, 50, 50), obstaclePaint);
//       }
//     } else {
//       final gameOverTextPaint = Paint()..color = Colors.black;
//       final textSpan = TextSpan(
//         style: GoogleFonts.spaceMono(fontSize: 3, color: gameOverTextPaint.color),
//       );
//
//       final textPainter = TextPainter(
//         text: textSpan,
//         textDirection: TextDirection.ltr,
//       );
//
//       textPainter.layout(minWidth: 0, maxWidth: size.width);
//       textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, size.height / 3.7));
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }



Color getRandomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(100), // Red component (0-255)
    random.nextInt(200), // Green component (0-255)
    random.nextInt(50), // Blue component (0-255)
  );
}

Color getRandomRedOrOrangeColor() {
  final List<Color> colors = [
    Colors.red,
    // Colors.orange,
    Colors.deepOrange,
    Colors.redAccent,
    // Colors.orangeAccent,
  ];

  final Random random = Random();
  final int randomIndex = random.nextInt(colors.length);
  return colors[randomIndex];
}


Color getRandomBlueColor() {
  final List<Color> colors = [
    Colors.blue,
    Colors.lightBlue,
    Colors.blueAccent,
    // Colors.lightBlueAccent,
    // Colors.cyan,
  ];

  final Random random = Random();
  final int randomIndex = random.nextInt(colors.length);
  return colors[randomIndex];
}


Color getRandomGreenColor() {
  final List<Color> colors = [
    Colors.green,
    Colors.lightGreen,
    Colors.greenAccent,
    Colors.lightGreenAccent,
    Colors.teal,
    Colors.tealAccent,
  ];

  final Random random = Random();
  final int randomIndex = random.nextInt(colors.length);
  return colors[randomIndex];
}


class GamePainter extends CustomPainter {
  final double playerX;
  final List<Obstacle> obstacles;
  final bool gameOver;

  GamePainter(this.playerX, this.obstacles, this.gameOver);

  @override
  void paint(Canvas canvas, Size size) {
    final playerPaint = Paint()..color = Colors.blue.shade600;
    final playerPaint2 = Paint()..color = Colors.blue.shade50;
    final playerPaint3 = Paint()..color = getRandomGreenColor();
    final obstaclePaint = Paint()..color = getRandomRedOrOrangeColor();
    final obstaclePaint2 = Paint()..color = Colors.white;
    final groundPaint = Paint()..color = Colors.black;

    final groundPath = Path()
      ..moveTo(0, 650)
      ..lineTo(size.width, 650);

    canvas.drawPath(groundPath, groundPaint);

    if (!gameOver) {

      final playerPath2 = Path()
        ..moveTo(playerX + 25, 670-50)
        ..lineTo(playerX+10, 650-50)
        ..lineTo(playerX + 40, 650-50)
        ..close();

      canvas.drawPath(playerPath2, playerPaint3);


      final playerPath3 = Path()
        ..moveTo(playerX + 25, 600-50)
        ..lineTo(playerX-10, 650-50)
        ..lineTo(playerX + 60, 650-50)
        ..close();

      canvas.drawPath(playerPath3, playerPaint2);


      final playerPath = Path()
        ..moveTo(playerX + 25, 600-50)
        ..lineTo(playerX, 650-50)
        ..lineTo(playerX + 50, 650-50)
        ..close();

      canvas.drawPath(playerPath, playerPaint);

      for (var obstacle in obstacles) {


        final obstaclePath3 = Path()
          ..moveTo(obstacle.x+15, obstacle.y) // Inverted order of points
          ..lineTo(obstacle.x + 35, obstacle.y) // Inverted order of points
          ..lineTo(obstacle.x + 25, obstacle.y -55) // Inverted order of points
          ..close();

        canvas.drawPath(obstaclePath3, obstaclePaint);


        final obstaclePath2 = Path()
          ..moveTo(obstacle.x-10, obstacle.y) // Inverted order of points
          ..lineTo(obstacle.x + 60, obstacle.y) // Inverted order of points
          ..lineTo(obstacle.x + 25, obstacle.y + 50) // Inverted order of points
          ..close();

        canvas.drawPath(obstaclePath2, obstaclePaint2);


        final obstaclePath = Path()
          ..moveTo(obstacle.x, obstacle.y) // Inverted order of points
          ..lineTo(obstacle.x + 50, obstacle.y) // Inverted order of points
          ..lineTo(obstacle.x + 25, obstacle.y + 50) // Inverted order of points
          ..close();

        canvas.drawPath(obstaclePath, obstaclePaint);



      }
    } else {
      final gameOverTextPaint = Paint()..color = Colors.white;
      final textSpan = TextSpan(
        style: TextStyle(fontSize: 36, color: gameOverTextPaint.color),
        text: '',
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: 0, maxWidth: size.width);
      textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, size.height / 3.7));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}




class Obstacle {
  double x;
  double y;
  double speed;

  Obstacle(this.x, this.y, this.speed);

  void updatePosition() {
    y += speed;
  }

  bool collidesWithPlayer(double playerX) {
    if (x < playerX + 50 && x + 50 > playerX && y < 600 + 50-50 && y + 50 > 600-50) {
      return true;
    }
    return false;
  }
}

