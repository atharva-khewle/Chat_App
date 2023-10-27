import 'package:chatapp/database/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_zimkit/services/services.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {

 final String callID="1atharva_yes";

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: Utils.id, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: Utils.SignIn, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID:    ZIMKit().currentUser()!.baseInfo.userID,
      userName:    ZIMKit().currentUser()!.baseInfo.userName,
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
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
