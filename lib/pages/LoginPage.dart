

import 'package:chatapp/database/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/services/services.dart';
import 'dart:math' as math;


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{

  final userid = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  bool showpass = true;
  late final AnimationController _controller = AnimationController(vsync: this, duration: Duration(seconds: 10))..repeat();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // color: Color(0xffCCB4E7),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Container(
// color: Color(0xffAE94F5),
//                   color: Color(0xffA177E7),
                  color: Colors.deepPurple.shade50,
                  child: Stack(




                    children: [

                      Positioned(
                        // top: 300,
                        child: Container(
                          // color: Colors.red,
                          height: MediaQuery.of(context).size.height/1.04,
                          child: Transform.scale(
                            scale: 2.2,
                            // child: Image.asset("assets/login.jpg",)
                          ),
                        ),
                      ),

                      Column(
                        children: [

                          SizedBox(height: 20,),
                          Text("O R I O N  C H A T",
                            style: GoogleFonts.raleway(fontSize: 30,color: Colors.deepPurple.shade800),
                          ),

                          SizedBox(height: 20,),
                          Container(
                            height: 200,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                // child: Image.asset("assets/u.avif",opacity: AlwaysStoppedAnimation(0.8),)

                                child: Image.asset("assets/u.jpg",)

                              // child: AnimatedBuilder(
                              //   animation: _controller,
                              //   builder: (_, child) {
                              //     return Transform.rotate(
                              //       angle: _controller.value *2 * math.pi*(1),
                              //       child: child,
                              //     );
                              //   },
                              //   child: Image.asset("assets/u.avif",opacity: AlwaysStoppedAnimation(0.8),),
                              // ),

                            ),
                          ),
                          SizedBox(height: 24,),

                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(60, 10, 60, 5),
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(5),
                          //     child: Container(
                          //       height: 35,
                          //       color: Color(0xffA177E7).withOpacity(0.65),
                          //
                          //       child: TextFormField(
                          //
                          //         style: TextStyle(color: Colors.white),
                          //
                          //         controller: userName,
                          //
                          //         decoration: InputDecoration(
                          //           hintStyle: TextStyle(color: Colors.white),
                          //           contentPadding:
                          //           EdgeInsets.only(left: 15, bottom: 11, top: 1, right: 15),
                          //           hintText: "User_Name",
                          //
                          //           border: InputBorder.none,
                          //
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(height: 8,),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(60, 10, 60, 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: 35,
                                color: Color(0xffA177E7).withOpacity(0.65),

                                child: TextFormField(

                                  style: TextStyle(color: Colors.white),

                                  controller: userid,

                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.white),
                                    contentPadding:
                                    EdgeInsets.only(left: 15, bottom: 11, top: 1, right: 15),
                                    hintText: "User_Id",

                                    border: InputBorder.none,

                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8,),
                          Padding(

                            padding: const EdgeInsets.fromLTRB(60, 10, 60, 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: 35,
                                color: Color(0xffA177E7).withOpacity(0.65),

                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  controller: password,
                                  obscureText: showpass,

                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        showpass?
                                        CupertinoIcons.eye_slash_fill:
                                        CupertinoIcons.eye_fill
                                      ),
                                      onPressed: (){
                                        setState(() {
                                          showpass= !showpass;

                                        });
                                      },
                                    ),

                                    hintStyle: TextStyle(color: Colors.white),
                                    contentPadding:
                                    EdgeInsets.only(left: 15, bottom: 11, top: 1, right: 15),
                                    hintText: "Password",

                                    border: InputBorder.none,

                                  ),
                                ),
                              ),
                            ),
                          ),





                          // TextFormField(
                          //   controller: userid,
                          //   decoration: InputDecoration(
                          //     label: Text("User_id"),
                          //   ),
                          // ),

                          SizedBox(height: 20,),

                          ElevatedButton(
                            onPressed: ()async {

                              String name = "{pass:${password.text},url:,desc: All is Well}";
                              List<String> str = name.replaceAll("{","").replaceAll("}","").split(",");
                              Map<String,dynamic> result = {};
                              for(int i=0;i<str.length;i++){
                                List<String> s = str[i].split(":");
                                result.putIfAbsent(s[0].trim(), () => s[1].trim());
                              }
                              print(result["pass"]);

                              await ZIMKit().connectUser(
                                  id: userid.text,
                                  name: userName.text,
                                  avatarUrl: name
                              );



                              ZegoUIKitPrebuiltCallInvitationService().init(
                                appID: Utils.id /*input your AppID*/,
                                appSign: Utils.SignIn /*input your AppSign*/,
                                userID: userid.text,
                                userName: userName.text,
                                plugins: [ZegoUIKitSignalingPlugin()],
                              );





                              print("user issssssssssssssssssssssssssssssssssss");
                              print(                  ZIMKit().currentUser()?.baseInfo.userName);
                              print(                  ZIMKit().currentUser()?.extendedData);
                              GoRouter.of(context).go("/ChatsPage");

                            },
                            style:  ElevatedButton.styleFrom(
                              fixedSize: Size(210, 40),
                              shape: RoundedRectangleBorder(
                                
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xffA177E7), // Text Color (Foreground color)
                            ),
                            child: Text("Sign in",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

                          ),

                          SizedBox(height: 5,),
                          Container(
                            width: 230,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account ?",
                                style: TextStyle(color: Colors.grey.shade500,fontWeight: FontWeight.bold,fontSize: 12),

                                ),
                                GestureDetector(
                                  child: Text(" Register",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                                  onTap: (){
                                    GoRouter.of(context).go("/Register");
                                  },
                                )
                              ],
                            ),
                          ),



                          SizedBox(height: 75,),
                          Container(
                            height: 1,
                            width: 270,
                            color: Colors.deepPurpleAccent.shade100,

                          ),

                          SizedBox(height: 20,),

                          Text("Google Auth",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xffA177E7)),),

                          SizedBox(height: 25,),


                          ElevatedButton(
                            onPressed: (){},
                            style:  ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xffA177E7), // Text Color (Foreground color)
                            ),
                            // child: Text("Login / Register",),
                            child:Container(
                              width: 150,
                              height: 42,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Sign in",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                  Icon(Icons.login),
                                ],
                              ),
                            ),
                          ),


                        ],
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

