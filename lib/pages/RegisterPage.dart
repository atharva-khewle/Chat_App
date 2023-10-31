

// import 'dart:js_interop';

import 'package:chatapp/Hive/thebox.dart';
import 'package:chatapp/database/utils.dart';
import 'package:chatapp/firebase/CURD.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/services/services.dart';
import 'dart:math' as math;


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin{




  final userid = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  bool showpass = true;
  late final AnimationController _controller = AnimationController(vsync: this, duration: Duration(seconds: 10))..repeat();

  //firebase functions
  firestoresrevice service = new firestoresrevice();

  // Container EnterCorrectInfo(context){
  //   return (
  //       Container(
  //         child: AlertDialog(
  //           title: Text("Please enter correct information"),
  //           actions: [
  //             TextButton(onPressed: (){
  //               Navigator.pop(context);
  //             }, child: Text("OK"))
  //           ],
  //         ),
  //       )
  //
  //   );
  // }


  void googlesignin(context)async {
    ////////////////////////////google login/////////////////////////////////
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credentials = GoogleAuthProvider.credential(
      idToken: googleAuth?.idToken,
      accessToken: googleAuth?.accessToken,
    );

    //access data
    UserCredential userdata = await FirebaseAuth.instance.signInWithCredential(credentials);

    //data
    print(userdata.user?.photoURL.toString());


    String? idd = userdata.user?.displayName ;
    String? idphoto = userdata.user?.photoURL ;
    //////////////////////////firebase data store/////////////////////////

    if (await service.checkemailexistance(userdata.user?.email)){
      //email exists
    }else{
      //no email registered
      //register email
      await service.addUserData(idd, idd, "12345678", idphoto, userdata.user?.email, "please change password");
    }

    /////////////////////////////zimkit login//////////////////////////




    if ((idd == null) ){
      print("error occured");
    }else {

      await ZIMKit().connectUser(
          id:idd,
          name: idd,

          avatarUrl: idphoto==null ? "":idphoto
      );


      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: Utils.id /*input your AppID*/,
        appSign: Utils.SignIn /*input your AppSign*/,
        userID: idd,
        userName: idd,

        plugins: [ZegoUIKitSignalingPlugin()],
      );

///////////////////////////////////hive register////////////////////

      Map<String,String> apple1={
        "connected":"yes",
        "userid":idd,
        "username":idd
      };

      box1.putinbox(apple1);
      GoRouter.of(context).go("/ChatsPage");
    }
  }








  void googleSignOut()async {
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
    print("++++++++++++++++++++++++++++=signed out from forebase and google++++++++++++++++++++++++++++++");
  }


  Future WrongInfo(context){
    return showDialog(context: context, builder: (context){
      return Container(
        child: AlertDialog(
          contentPadding: EdgeInsets.all(2),
          title: Text("Please enter correct info...",
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.w500,
            fontSize: 20
          ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("OK"))
          ],
        ),
      );
    });
  }

  Future UserAlreadyExistsPopup(context){
    return showDialog(context: context, builder: (context){
      return Container(
        child: AlertDialog(
          contentPadding: EdgeInsets.all(2),
          title: Text("User Already Exists...",
            style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
                fontSize: 20
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("OK"))
          ],
        ),
      );
    });
  }

  Future filleachfieldPopup(context){
    return showDialog(context: context, builder: (context){
      return Container(
        child: AlertDialog(
          contentPadding: EdgeInsets.all(2),
          title: Text("Please fill required information",
            style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
                fontSize: 20
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("OK"))
          ],
        ),
      );
    });
  }


  Future Loadingpopup(context){
    return showDialog(context: context, builder: (context){
      return Container(
        child: AlertDialog(
          contentPadding: EdgeInsets.all(2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      );
    });
  }




  void zimloginhive(String userid,String username)async{

    await ZIMKit().connectUser(
        id:userid,
        name: username,

        avatarUrl: ""
    );


    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: Utils.id /*input your AppID*/,
      appSign: Utils.SignIn /*input your AppSign*/,
      userID: userid,
      userName: username,

      plugins: [ZegoUIKitSignalingPlugin()],
    );
    GoRouter.of(context).go("/ChatsPage");


  }


userbox box1 = new userbox();








@override
  void initState() {
    // TODO: implement initState

    super.initState();


    final data1;
    data1 = box1.getdata();

    if(data1["connected"]=="yes"){



      zimloginhive(data1["userid"], data1["username"]);



    }
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // set your stuff here
    final data1;
    data1 = box1.getdata();

    if(data1["connected"]=="yes"){
      zimloginhive(data1["userid"], data1["username"]);
    }
  }





  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(CupertinoIcons.dot_square),
          onPressed: (){
            print("jfllllllllllllllllllllllllllllllllll");
            WrongInfo(context);

          },
        ),
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

                          SizedBox(height: 17,),
                          Text("O R I O N  C H A T",
                          style: GoogleFonts.raleway(fontSize: 30,color: Colors.deepPurple.shade800),
                          ),

                          SizedBox(height: 17,),
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
                          //pass
                          Padding(
                            padding: const EdgeInsets.fromLTRB(60, 10, 60, 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: 35,
                                color: Color(0xffA177E7).withOpacity(0.65),

                                child: TextFormField(

                                  style: TextStyle(color: Colors.white),

                                  controller: userName,

                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.white),
                                    contentPadding:
                                    EdgeInsets.only(left: 15, bottom: 11, top: 1, right: 15),
                                    hintText: "User_Name",

                                    border: InputBorder.none,

                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4,),
                          //userid
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
                          SizedBox(height: 4,),
                          //pass
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
                                      ,color: Colors.deepPurple.shade500.withOpacity(0.7),
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

                          SizedBox(height: 16,),

                          // MaterialButton(
                          //   onPressed: (){},
                          //   child: Text("R E G I S T E R",
                          //     style: GoogleFonts.exo(
                          //       color: Colors.deepPurple,
                          //       fontSize: 25,
                          //       // fontWeight: FontWeight.bold
                          //     ),
                          //   ),
                          // ),

                          ElevatedButton(
                              onPressed: ()async {



                                //
                                // String name = "{pass:${password.text},url:,desc: All is Well}";
                                // List<String> str = name.replaceAll("{","").replaceAll("}","").split(",");
                                // Map<String,dynamic> result = {};
                                // for(int i=0;i<str.length;i++){
                                //   List<String> s = str[i].split(":");
                                //   result.putIfAbsent(s[0].trim(), () => s[1].trim());
                                // }
                                // print(result["pass"]);






                                print("start isssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");

                                if((userName.text=="")||(userid.text=="")||(password.text=="")){
                                  filleachfieldPopup(context);
                                }else{



                                if(await service.checkuserexistance(userid.text)){
                                  //user exist so popup

                                 UserAlreadyExistsPopup(context);
                                }
                                else{

                                  //registers user








                                  await ZIMKit().connectUser(
                                      id: userid.text,
                                      name: userName.text,

                                  );



                                  ZegoUIKitPrebuiltCallInvitationService().init(
                                    appID: Utils.id /*input your AppID*/,
                                    appSign: Utils.SignIn /*input your AppSign*/,
                                    userID: userid.text,
                                    userName: userName.text,
                                    plugins: [ZegoUIKitSignalingPlugin()],
                                  );


                                  // sent to firebase
                                  await service.addUserData(userName.text, userid.text, password.text, "", "", "all is welll");


                                  //hive store
                                  //saving data in storage hive
                                  Map<String,String> apple1={
                                    "connected":"yes",
                                    "userid":userid.text,
                                    "username":userName.text
                                  };

                                  box1.putinbox(apple1);

                                  GoRouter.of(context).go("/ChatsPage");

                                }

                                }

                                print("end isssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
                                print(                  ZIMKit().currentUser()?.baseInfo.userName);
                                print(                  ZIMKit().currentUser()?.extendedData);




















                                },
                            style:  ElevatedButton.styleFrom(
                              fixedSize: Size(210, 40),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xffA177E7), // Text Color (Foreground color)
                            ),
                              child: Text("Register",style: GoogleFonts.exo(fontWeight:FontWeight.w500,fontSize: 20),),

                          ),

                          SizedBox(height: 5,),

                          Container(
                            width: 230,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account ?",
                                  style: TextStyle(color: Colors.grey.shade500,fontSize: 12,fontWeight: FontWeight.bold,),
                                ),
                                GestureDetector(
                                  child: Text(" Sign in",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),),
                                  onTap: (){
                                    GoRouter.of(context).go("/Login");
                                  },
                                )
                              ],
                            ),
                          ),




                          SizedBox(height: 45),
                          Container(
                            // height: 1,
                            width: 500,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 1,
                                  width: 65,
                                  color: Colors.deepPurpleAccent.shade100,

                                ),
                                SizedBox(width: 8,),
                                Text(
                                  "continue with google",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.5,
                                    color: Colors.deepPurpleAccent.shade100,

                                  ),
                                ),
                                SizedBox(width: 8,),

                                Container(
                                  height: 1,
                                  width: 65,
                                  color: Colors.deepPurpleAccent.shade100,

                                )

                              ],
                            ),
                          ),

                          // SizedBox(height: 20,),

                          // Text("Google Auth",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xffA177E7)),),

                          SizedBox(height: 8,),


                          ClipRRect(
                            borderRadius: BorderRadius.circular(300),
                            child: Container(
                              width: 92,
                              height: 92,
                              child: MaterialButton(
                                onPressed: ()async{
                                  googlesignin(context);
                                },
                                child:Container(

                                  width: 60,
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Transform.scale(
                                          scale: 0.87,
                                          child: Image.asset("assets/google.png",)),
                                      // Text("Google Sign in",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                      // Icon(Icons.login),
                                    ],
                                  ),
                                ),


                              ),
                            ),
                          ),


                          // ElevatedButton(
                          //   onPressed: (){
                          //     googlesignin(context);
                          //   },
                          //   style:  ElevatedButton.styleFrom(
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(10.0),
                          //     ),
                          //
                          //     foregroundColor: Colors.white,
                          //     backgroundColor: Color(0xffA177E7), // Text Color (Foreground color)
                          //   ),
                          //   // child: Text("Login / Register",),
                          //   child:Container(
                          //     width: 150,
                          //     height: 42,
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //       children: [
                          //         Text("Register",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          //         Icon(Icons.login),
                          //       ],
                          //     ),
                          //   ),
                          // ),


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

