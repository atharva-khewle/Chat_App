import 'dart:convert';

import 'package:chatapp/Hive/thebox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_zimkit/services/services.dart';

import '../firebase/CURD.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // String? name = ZIMKit().currentUser()?.userAvatarUrl;
  Map<String, dynamic> result = {};

  String? imgurl = null;
  firestoresrevice service = new firestoresrevice();

  final faccount =  FirebaseAuth.instance.currentUser;
  String? username;
  @override
  void initState() {
    // TODO: implement initState
  imgurl = service.getimgurl();

  getname();
  super.initState();
  }

  void getname()async{

    String? temp= await service.getusername();
    setState(()async {
      username= temp;

    });
}



  void googleSignOut()async {
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
    print("++++++++++++++++++++++++++++=signed out from forebase and google++++++++++++++++++++++++++++++");
  }





//hive
  userbox box1 = new userbox();
  connectedornot box2 = new connectedornot();





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: ()
            {
              GoRouter.of(context).go("/ChatsPage");
            }, icon: Icon(CupertinoIcons.back,color: Colors.white,)),
            Center(
              child: Text("DASHBOARD",style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 22,
                // fontWeight: FontWeight.bold
              ),),
            ),
            IconButton(onPressed: ()
            {
              GoRouter.of(context).go("/AllGames");
            }, icon: Icon(CupertinoIcons.gamecontroller,color: Colors.white,)),

          ],
        ),

        backgroundColor: Color(0xffA177E7),

      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){



          GoRouter.of(context).go("/");



          },
      ),


      body:SingleChildScrollView(

        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height/1.15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(


                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: MediaQuery.of(context).size.width,height: 0,),
                  SizedBox(height: 42,),
                  //photo
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: Container(
                          height: 150,
                          width: 150,
                          color: Colors.purpleAccent,
                          // child: Image.asset("assets/u.jpg",),
                          // child: Image.network("https://picsum.photos/200"),
                          child: (
                              imgurl==null?
                              Image.asset("assets/u.jpg",)
                                  :
                              Image.network(imgurl!,scale: 0.6,)
                          ),
                        ),
                      ),
                      Positioned(
                        top: 110,
                        left: 110,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(17),
                          child: Container(
                            width: 35,
                            height: 35,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: -15,
                                  top: -6,
                                  child: ElevatedButton(


                                    onPressed: (){
                                      print("jjj");
                                    },
                                    child: Icon(Icons.edit,size: 18,color: Colors.white,),
                                    style:  ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(

                                        side: BorderSide.none,
                                      ),

                                      backgroundColor: Color(0xffA177E7), // Text Color (Foreground color)
                                    ),

                                  ),
                                ),
                              ],
                            )
                          ),
                        ),
                      ),



                    ],
                  ),
                  SizedBox(height: 22,),
                  Container(
                    // color: Colors.deepPurple.shade200,
                    width: 250,
                    height: 1.5,
                  ),
                  SizedBox(height: 20,),
                  //user
                  Container(
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
                            Icon(CupertinoIcons.profile_circled,color: Color(0xffA177E7),),
                            Container(
                              width: 190,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "${ZIMKit().currentUser()?.baseInfo.userName}",
                                      style: TextStyle(
                                        color: Color(0xff825db7),
                                        overflow: TextOverflow.visible
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Color(0xffA177E7),)),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  //id
                  Container(
                    width: 330,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple.shade200),
                        borderRadius: BorderRadius.circular(5)
                    ),

                    child: Center(
                      child: Container(
                        height: 48,
                        width: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.numbers_outlined,color: Color(0xffA177E7),),
                            SizedBox(width: 20,),
                            Container(
                              width: 190,
                              child: Row(

                                children: [

                                  Flexible(
                                    child: Text(
                                      "${ZIMKit().currentUser()?.baseInfo.userID == null ? "now whats the error":ZIMKit().currentUser()?.baseInfo.userID}"
                                      ,
                                      // maxLines: 3,
                                      // overflow: TextOverflow.ellipsis,
                                      // softWrap: true,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Color(0xff825db7)
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Color(0xffA177E7),)),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  //email
                  Container(
                    width: 330,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple.shade200),
                        borderRadius: BorderRadius.circular(5)
                    ),

                    child: Center(
                      child: Container(
                        height: 48,
                        width: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.email_outlined,color: Color(0xffA177E7),),
                            SizedBox(width: 20,),
                            Container(
                              width: 190,
                              child: Row(

                                children: [

                                  Flexible(
                                    child: Text(
                                      "${faccount?.email==null ? "-": faccount?.email}"
                                      ,
                                      // maxLines: 3,
                                      // overflow: TextOverflow.ellipsis,
                                      // softWrap: true,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Color(0xff825db7)
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Color(0xffA177E7),)),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  //pass
                  Container(
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
                            Icon(Icons.password,color: Color(0xffA177E7),),

                            Container(
                              width: 190,
                              child: Row(
                                children: [
                                  Flexible(
                                    child:Text(
                                      "${(result["pass"]==null || result["pass"] =="")?"please set password":result["pass"]}",
                                      style: TextStyle(
                                          color: Color(0xff825db7)
                                      ),
                                      overflow: TextOverflow.visible,

                                    ),


                                  )
                                ],
                              ),
                            ),
                            IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Color(0xffA177E7),)),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  //desc
                  Container(
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.description_outlined,color: Color(0xffA177E7),),
                            Container(
                              width: 190,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                    result["desc"]==null?"i am human :}":result["desc"]
                                    ,
                                      // maxLines: 3,
                                      // overflow: TextOverflow.ellipsis,
                                      // softWrap: true,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                        color: Color(0xff825db7)
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Color(0xffA177E7),)),

                          ],
                        ),
                      ),
                    ),
                  ),







                ],
              ),
              Column(
                children: [



                  SizedBox(height: 20,),
                  Container(
                    color: Colors.deepPurple.shade200,
                    width: 250,
                    height: 1.5,
                  ),
                  SizedBox(height: 25,),
                  ElevatedButton(
                    onPressed: ()async{
                      ZegoUIKitPrebuiltCallInvitationService().uninit();

                       googleSignOut();
                      ZIMKit().disconnectUser();
                      // box1.deleteuserdata();
                      box2.putinbox("no", 0);
                      GoRouter.of(context).go("/");

                    },
                    style:  ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      foregroundColor: Colors.white,

                      backgroundColor: Color(0xffA177E7), // Text Color (Foreground color)
                    ),
                    // child: Text("Login / Register",),
                    child:Container(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Logout",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),

                          Icon(Icons.logout),


                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text(
                    "Version: 1.69.420",
                    style: TextStyle(
                        color: Color(0xff825db7)
                    ),
                  ),
                  SizedBox(height: 10,),



                ],
              )
            ],
          ),
        ),
      ),


      //i made this to call the other person
      // it works but only the on=ther person can hear the ringtone
      // i can add the finctionality of notification but its too much work for too less profit
      //i will focus on other things for now
      // body: Container(
      //   color: Colors.deepPurple.shade50,
      //   child: ZegoSendCallInvitationButton(
      //     isVideoCall: true,
      //     resourceID: "zegouikit_call",    // For offline call notification
      //     invitees: [
      //       ZegoUIKitUser(
      //         id: "2",
      //         name: "lll",
      //       ),
      //
      //     ],
      //   ),
      // ),
    );
  }
}
