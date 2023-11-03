// YOUTUBE IMP VIDEOS
//1. FOR PICKING AND UPLOADING FILES
//https://www.youtube.com/watch?v=3x92z0oHbtY

import 'package:chatapp/database/utils.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/game/Games.dart';
import 'package:chatapp/game/dodge.dart';
import 'package:chatapp/game/flappybird.dart';
import 'package:chatapp/pages/ChatsPage.dart';
import 'package:chatapp/pages/LoginPage.dart';
import 'package:chatapp/pages/ProfilePage.dart';
import 'package:chatapp/pages/RegisterPage.dart';
import 'package:chatapp/pages/call/VideoCallpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/services/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //initislise hive
  await Hive.initFlutter();
  await Hive.openBox("one");
  await Hive.openBox("two");


  final navigatorKey = GlobalKey<NavigatorState>();

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);


  ZIMKit().init(
      appID: Utils.id,
    appSign: Utils.SignIn,
  );

  ZegoUIKit().initLog().then((value) {
    ///  Call the `useSystemCallingUI` method
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(MyApp0(navigatorKey: navigatorKey));
  });
  // runApp(MyApp0(navigatorKey: navigatorKey,));
}

class MyApp0 extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp0({    required this.navigatorKey,
    super.key});

  @override
  State<MyApp0> createState() => _MyApp0State();
}

class _MyApp0State extends State<MyApp0> {
  @override
  // TODO: implement widget
  MyApp0 get widget => super.widget;
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      navigatorKey: widget.navigatorKey,
        builder: (context,state){
          return MyApp();
        }
    );
  }
}


class MyApp extends StatelessWidget {

  MyApp({
    super.key

  });

  GoRouter router = GoRouter(routes: [
    ShellRoute(routes: [

      //
      // GoRoute(
      //     path: "/",
      //     builder: (context,state)=>GameWidget()
      // ),


      GoRoute(
          path: "/",
          builder: (context,state)=>LoginPage()
      ),

      GoRoute(
          path: "/Login",
          builder: (context,state)=>LoginPage()
      ),
      GoRoute(
          path: "/Register",
          builder: (context,state)=>RegisterPage()
      ),
      GoRoute(
          path: "/ChatsPage",
          builder: (context,state)=>ChatsPage()
      ),
      // GoRoute(
      //     path: "/CallPage",
      //     builder: (context,state)=>VideoCallPage()
      // ),
      GoRoute(
          path: "/SpaceGame",
          builder: (context,state)=>GameWidget()
      ),
      GoRoute(
          path: "/flappybird",
          builder: (context,state)=>FlappyBirdGame()
      ),
      GoRoute(
          path: "/ProfilePage",
          builder: (context,state)=>ProfilePage()
      ),
      GoRoute(
          path: "/AllGames",
          builder: (context,state)=>AllGames()
      ),




    ],
        builder: (context,state,child){
          return Scaffold(
              body: child,
              backgroundColor: Colors.blue.shade50,
              bottomNavigationBar:Container(
                height: 1,
                color: Colors.black,
              )
          );
        }
    ),



  ]);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(
        fontFamily: "exo-Light",
        primaryColor: Colors.deepPurple.shade100,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
