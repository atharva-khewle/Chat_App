import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class AllGames extends StatefulWidget {
  const AllGames({super.key});

  @override
  State<AllGames> createState() => _AllGamesState();
}

class _AllGamesState extends State<AllGames> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: ()
              {
                GoRouter.of(context).go("/ProfilePage");
              }, icon: Icon(CupertinoIcons.back,color: Colors.white,)),
              Center(
                child: Text("Games",style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 22,
                  // fontWeight: FontWeight.bold
                ),),
              ),
              IconButton(onPressed: ()
              {
              }, icon: Icon(Icons.check_box_outline_blank,color: Colors.transparent,)),

            ],
          ),

          backgroundColor: Color(0xffA177E7),

        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(width: MediaQuery.of(context).size.width,height: 0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(

                  onTap: (){
                    GoRouter.of(context).go("/flappybird");

                  },
                  child: InkWell(
                    splashColor: Colors.purple,
                    highlightColor: Colors.purple,
                    child: Container(
                      width: 330,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple.shade200),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(
                        child: Container(

                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.landscape_outlined,color: Color(0xffA177E7),size: 30,),
                              Container(
                                width: 190,
                                height: 50,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text("Flappy Bat",style: TextStyle(
                                    color: Color(0xff825db7),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                              ),),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(CupertinoIcons.arrow_right,color: Color(0xffA177E7),size: 25,),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(

                  onTap: (){
                    GoRouter.of(context).go("/SpaceGame");

                  },
                  child: InkWell(
                    splashColor: Colors.purple,
                    highlightColor: Colors.purple,
                    child: Container(
                      width: 330,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple.shade200),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(
                        child: Container(

                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(CupertinoIcons.paperplane,color: Color(0xffA177E7),size: 30,),
                              Container(
                                width: 190,
                                height: 50,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text("Orion's Flight",style: TextStyle(
                                    color: Color(0xff825db7),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15
                              ),),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(CupertinoIcons.arrow_right,color: Color(0xffA177E7),size: 25,),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],


          ),
        ),
      ),
    );
  }
}
