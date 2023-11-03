import 'package:chatapp/database/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_zimkit/services/services.dart';

class VideoCallPage extends StatefulWidget {
  final String reciever;
  final String calltype;
  VideoCallPage({super.key,
    required this.calltype,
    required this.reciever,
  });

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  String callID="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getvidcallid();
  }
  String getvidcallid(){
    final id ;


    if((widget.reciever).compareTo(ZIMKit().currentUser()!.baseInfo.userID) >0 ) {
      id = "${widget.calltype}" + "${ZIMKit()
          .currentUser()
          ?.baseInfo
          .userID}";
    }else{
      id = "${widget.calltype}" + "${widget.reciever}" ;
    }

    setState(() {
      callID = id;
    });


    return id;
  }

  @override
  // TODO: implement widget
  VideoCallPage get widget => super.widget;


  @override
  Widget build(BuildContext context) {
    print("the id is ++++++++++++++++++++++++++++++++++++++++$callID+++++++++++++++++++++++++++++++++++=");
    return ZegoUIKitPrebuiltCall(
      appID: Utils.id, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: Utils.SignIn, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID:    ZIMKit().currentUser()!.baseInfo.userID,
      userName:    ZIMKit().currentUser()!.baseInfo.userName,
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.groupVideoCall()
        ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(buttons: [
          ZegoMenuBarButtonName.toggleCameraButton,
          ZegoMenuBarButtonName.toggleMicrophoneButton,
          ZegoMenuBarButtonName.hangUpButton,
          ZegoMenuBarButtonName.chatButton,
          ZegoMenuBarButtonName.toggleScreenSharingButton,
          ZegoMenuBarButtonName.minimizingButton,
          ZegoMenuBarButtonName.showMemberListButton,
        ])
        ..onOnlySelfInRoom = (context) {
          Navigator.of(context).pop();
          // GoRouter.of(context).go("/ChatsPage");

  },
    );
  }
}
