// import 'dart:async';
// import 'dart:math'; // Import the math library
// import 'package:flutter/material.dart';
//
// class FlappyBirdGame extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Flappy Bird'),
//         ),
//         body: GameScreen(),
//       ),
//     );
//   }
// }
//
// class GameScreen extends StatefulWidget {
//   @override
//   _GameScreenState createState() => _GameScreenState();
// }
//
// class _GameScreenState extends State<GameScreen> {
//   double birdY = 0;
//   double birdYVelocity = 0;
//   double gravity = 0.0085;
//   double pipeX = 1.2;
//   double pipeWidth = 0.2;
//   double pipeGap = 0.3;
//   Timer? gameTimer;
//   bool isGameOver = false;
//   Random random = Random(); // Create a random number generator
//
//   @override
//   void initState() {
//     super.initState();
//     startGame();
//   }
//
//   void checkCollisions() {
//     // Calculate the position of the bird and the pipes
//     double birdX = MediaQuery.of(context).size.width / 2;
//     double birdTop = birdY * MediaQuery.of(context).size.height;
//     double birdBottom = birdTop + 50; // Assuming bird height is 50
//
//     double pipeLeft = pipeX * MediaQuery.of(context).size.width;
//     double pipeRight = pipeLeft + 100; // Assuming pipe width is 100
//     double pipeGapTop = pipeGap * MediaQuery.of(context).size.height;
//     double pipeGapBottom = pipeGapTop + 150; // Assuming pipe gap height is 150
//
//     if ((birdX + 50 > pipeLeft && birdX < pipeRight) &&
//         (birdTop < pipeGapTop || birdBottom > pipeGapBottom)) {
//       // Collision occurred
//       gameOver();
//     }
//   }
//
//   void startGame() {
//     birdY = 0.1;
//     birdYVelocity = 0;
//     pipeX = 1.2;
//     isGameOver = false;
//
//     gameTimer = Timer.periodic(Duration(milliseconds: 60), (timer) {
//       birdYVelocity += gravity;
//       birdY += birdYVelocity;
//
//       if (birdY > 1) {
//         birdY = 1;
//         birdYVelocity = 0;
//       }
//
//       pipeX -= 0.04;
//       if (pipeX < -0.3) {
//         pipeX = 1.2; // Reset the pipe position
//         pipeGap = random.nextDouble() * 0.45; // Randomize the pipe gap
//       }
//
//       if (pipeX > 0.2 && pipeX < 0.4) {
//         if (birdY < pipeGap || birdY > pipeGap + 0.15) {
//           gameOver();
//         }
//       }
//
//       if (birdY < 0) {
//         gameOver();
//       }
//
//       setState(() {});
//     });
//   }
//
//   void gameOver() {
//     gameTimer?.cancel();
//     isGameOver = true;
//   }
//
//   void restartGame() {
//     startGame();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (!isGameOver) {
//           setState(() {
//             birdYVelocity = -0.053;
//           });
//         } else {
//           restartGame();
//         }
//       },
//       child: Container(
//         color: Colors.lightBlue.shade100,
//         child: Stack(
//           children: <Widget>[
//             Positioned(
//               left: 100,
//               top: birdY * MediaQuery.of(context).size.height,
//               child: Bird(),
//             ),
//             Positioned(
//               left: pipeX * MediaQuery.of(context).size.width,
//               top: 0,
//               child: Pipe(pipeHeight: pipeGap * MediaQuery.of(context).size.height),
//             ),
//             Positioned(
//               left: pipeX * MediaQuery.of(context).size.width,
//               top: pipeGap * MediaQuery.of(context).size.height + 150,
//               child: Pipe(pipeHeight: (1 - pipeGap) * MediaQuery.of(context).size.height - 150),
//             ),
//             Positioned(
//               top: 10,
//               right: 10,
//               child: Text(
//                 "Game Over: ${isGameOver ? 'Yes' : 'No'}",
//                 style: TextStyle(fontSize: 20, color: Colors.white),
//               ),
//             ),
//             if (isGameOver)
//               Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Game Over",
//                       style: TextStyle(fontSize: 40, color: Colors.red),
//                     ),
//                     Text(
//                       "Tap to restart",
//                       style: TextStyle(fontSize: 20, color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     gameTimer?.cancel();
//     super.dispose();
//   }
// }
//
// class Bird extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 50,
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.black,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }
//
// class Pipe extends StatelessWidget {
//   final double pipeHeight;
//
//   Pipe({required this.pipeHeight});
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         color: Colors.green,
//         width: 20,
//         height: pipeHeight,
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Import shared_preferences

class FlappyBirdGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        // appBar: AppBar(
        //   title: Center(child: Text('THE   BAT')),
        //   backgroundColor: Colors.black.withOpacity(0),
        // ),


        body: GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double birdY = 0;
  double birdYVelocity = 0;
  double gravity = 0.0085;
  double pipeX = 1.2;
  double pipeWidth = 0.2;
  double pipeGap = 0.3;
  int score = 0;
  int highScore = 0; // Add high score variable
  Timer? gameTimer;
  bool isGameOver = false;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    startGame();
    loadHighScore(); // Load high score from storage
  }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore_flappybird') ?? 0;
    });
  }

  Future<void> saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('highScore_flappybird', highScore);
  }

  void checkCollisions() {
    double birdX = MediaQuery.of(context).size.width / 2;
    double birdTop = (birdY * MediaQuery.of(context).size.height);
    double birdBottom = birdTop + 50;

    double pipeLeft = pipeX * MediaQuery.of(context).size.width;
    double pipeRight = pipeLeft + 100;
    double pipeGapTop = (pipeGap * MediaQuery.of(context).size.height);
    double pipeGapBottom = pipeGapTop +150;

    if ((birdX + 50 > pipeLeft && birdX < pipeRight) &&
        (birdTop < pipeGapTop || birdBottom > pipeGapBottom)) {
      gameOver();
    }
  }

  // void startGame() {
  //   birdY = 0.1;
  //   birdYVelocity = 0;
  //   pipeX = 1.2;
  //   score = 0;
  //   isGameOver = false;
  //
  //   gameTimer = Timer.periodic(Duration(milliseconds: 60), (timer) {
  //     birdYVelocity += gravity;
  //     birdY += birdYVelocity;
  //
  //     if (birdY > 1) {
  //       birdY = 1;
  //       birdYVelocity = 0;
  //     }
  //
  //     pipeX -= 0.04;
  //     if (pipeX < -0.3) {
  //       pipeX = 1.2;
  //       pipeGap = random.nextDouble() * 0.45;
  //     }
  //
  //     if (pipeX > 0.2 && pipeX < 0.4) {
  //       if (birdY < pipeGap || birdY > pipeGap + 0.15) {
  //         gameOver();
  //       }
  //     }
  //
  //     if (birdY < 0) {
  //       gameOver();
  //     }
  //
  //     if (pipeX < 0.2 && pipeX > 0.1) {
  //       score++;
  //       if (score > highScore) {
  //         highScore = score;
  //         saveHighScore(); // Save high score to storage
  //       }
  //     }
  //
  //     setState(() {});
  //   });
  // }
  void startGame() {
    birdY = 0.1;
    birdYVelocity = 0;
    pipeX = 1.2;
    score = 0;
    isGameOver = false;

    gameTimer = Timer.periodic(Duration(milliseconds: 60), (timer) {
      birdYVelocity += gravity;
      birdY += birdYVelocity;

      if (birdY > 1) {
        birdY = 1;
        birdYVelocity = 0;
      }

      pipeX -= 0.04;
      if (pipeX < -0.3) {
        pipeX = 1.2;
        pipeGap = 0.21 + random.nextDouble() * 0.26; // Gap between 0.21 and 0.47
      }

      if (pipeX > 0.2 && pipeX < 0.4) {
        if (birdY < pipeGap || birdY > pipeGap + 0.15) {
          gameOver();
        }
      }

      if (birdY < 0) {
        gameOver();
      }

      if (pipeX < 0.2 && pipeX > 0.1) {
        score++;
        if (score > highScore) {
          highScore = score;
          saveHighScore();
        }
      }

      setState(() {});
    });
  }

  void gameOver() {
    gameTimer?.cancel();
    isGameOver = true;
  }

  void restartGame() {
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isGameOver) {
          setState(() {
            birdYVelocity = -0.052;
          });
        } else {
          restartGame();
        }
      },
      child: Container(
        color: Colors.black54,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 660,
              left: 0,
              child:Container(
                color: Colors.brown.shade500,
                height: 40,
                width: 480,

              ),
            ),


            Positioned(
              top: 0,
              left: 0,
              child:Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.diagonal3Values(-1.0, 1.0, 1.0), // Reverse along the X-axis
                  child: Image.asset("assets/cloud.gif",)
              ),
            ),

            Positioned(
              top: 350,
              left: 0,
              child:Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.diagonal3Values(-1.0, 1.0, 1.0), // Reverse along the X-axis
                  child: Image.asset("assets/cloud.gif",)
              ),
            ),

            Positioned(
              left: 100,
              top: birdY * MediaQuery.of(context).size.height,
              child: Bird(),
            ),
            Positioned(
              left: pipeX * MediaQuery.of(context).size.width,
              top: 0,
              child: Pipe(pipeHeight: pipeGap * MediaQuery.of(context).size.height),
            ),
            Positioned(
              left: pipeX * MediaQuery.of(context).size.width,
              top: pipeGap * MediaQuery.of(context).size.height + 150,
              child: Pipe(pipeHeight: (1 - pipeGap) * MediaQuery.of(context).size.height - 150),
            ),




            Positioned(
              // top: 645,
              top: 700,
              left: 0,
              child:Container(
                color: Colors.brown.shade500,
                height: 400,
                width: 480,

              ),
            ),
            Positioned(
              top: 567,
              left: 145,
              child: Column(
                children: [
                  Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.diagonal3Values(0.6, 0.6, 0.6), // Reverse along the X-axis
                      child: Image.asset("assets/dog.gif",)
                  )

                ],
              ),
            ),


            Positioned(
              top: 50,
              right: 10,
              child:Text(
                "Score: $score",
                style: GoogleFonts.exo(fontSize: 20, color: Colors.white),
              ),
            ),





            Positioned(
              top: 600,
              left: 255,
              child: Column(
                children: [
                  Text(
                    "$highScore", // Display high score
                    style: GoogleFonts.exo(fontSize: 40, color: Colors.grey.shade800,fontWeight: FontWeight.bold),
                  ),


                ],
              ),
            ),
            Positioned(
              top: 40,
              left: 10,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))) ,

                ),
                child: Icon(CupertinoIcons.back,color: Colors.white,),
                onPressed: (){
                  GoRouter.of(context).go("/AllGames");                },
              ),
            ),


            if (isGameOver)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Game Over",
                      style: GoogleFonts.exo(fontSize: 50, color: Colors.red,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Tap to restart",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }
}

class Bird extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(-1.5, 1.5, 1.5), // Reverse along the X-axis
          child: Image.asset("assets/bat.gif",)
      ),
     
    );
  }
}

class Pipe extends StatelessWidget {
  final double pipeHeight;

  Pipe({required this.pipeHeight});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
        color: Colors.black.withOpacity(0.75),
        width: 20,
        height: pipeHeight,
      ),
    );
  }
}

