
import 'package:chatapp/pages/call/VideoCallpage.dart';
import 'package:chatapp/pages/call/VoiceCallPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zego_zimkit/services/services.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../firebase/CURD.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {


  String? imgurl = null;
  String othersdesc = "error occured";
  firestoresrevice service = new firestoresrevice();
  Future<int> getphoto()async{

    String? temp= await service.getimage();
    if(temp !=null) {
      setState(() {
        imgurl = temp;
      });
    }
    return 0;
  }



  @override
  void initState() {
    // TODO: implement initState
    // imgurl = service.getimgurl();
    getphoto();

    super.initState();
  }

  Future<bool> setothersdesc(String oid)async{
    final a = await service.getothersdescription(oid);
    if(a!=null) {
      setState(() {
        othersdesc = a;
      });
      return true;

    }

    return false;
  }

  //update uername popup
  Future descriptionPopup(BuildContext context,String oid){
    String a = " \"  $othersdesc  \" ";
    String b = "by $oid";
    return showDialog(
        context: context,
        builder: (context){
          return   StatefulBuilder(builder:(context,StateSetter setState){
            return Container(
              child: AlertDialog(
                contentPadding: EdgeInsets.all(2),
                // title: Center(
                //   child: Text("New Username",
                //     style: TextStyle(
                //         color: Colors.deepPurple,
                //         fontWeight: FontWeight.w500,
                //         fontSize: 22
                //     ),
                //   ),
                // ),

                content: Container(
                  height: 150,
                  width: double.infinity,

                  color: Colors.deepPurple.shade50,
                  child: Center(
                    child: Container(
                      // color: Colors.red,
                      constraints: BoxConstraints(
                        minHeight: 100
                      ),
                      width: 200,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [

                            Container(
                              child: Text(a,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.exo(
                                    color: Colors.deepPurple.shade300,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Text(b,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.exo(

                                  color: Colors.deepPurple.shade300,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),


              ),
            );
          });
        });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.deepPurple.shade50,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffA177E7),
        onPressed: (){
          print("floating button");
        },
        child:           PopupMenuButton(

            // position: PopupMenuPosition.over,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3)
            ),
            icon: Icon(CupertinoIcons.add,color: Colors.white,),

            itemBuilder:(context){
              return[
                PopupMenuItem(
                  value: "New Chat",
                  child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text("NewChat",maxLines: 1,),

                  ),
                  onTap: (){
                    ZIMKit().showDefaultNewPeerChatDialog(context);
                  },
                ),
                PopupMenuItem(
                  value: "Join Group",
                  child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text("Join Group",maxLines: 1,),

                  ),
                  onTap: (){
                    ZIMKit().showDefaultJoinGroupDialog(context);
                  },
                ),
                PopupMenuItem(
                  value: "New Group",
                  child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text("Create Group",maxLines: 1,),

                  ),
                  onTap: (){

                    ZIMKit().showDefaultNewGroupChatDialog(context);
                  },
                ),

              ];
            }
        ),

      ),
      appBar: AppBar(
        title: Text("  Chats",style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: 27,
          // fontWeight: FontWeight.bold
        ),),
        backgroundColor: Color(0xffA177E7),
        actions: [




          GestureDetector(
            onTap: (){
              GoRouter.of(context).go("/ProfilePage");
            },
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color:Colors.deepPurple.shade50,
                      width: 1
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5000.0) //                 <--- border radius here
                  ),
                ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(350),
                child: Container(
                  width: 33,
                  height: 33,
                  child:(imgurl==null || imgurl==""?
                  Image.asset("assets/u.jpg",)
                      :
                  Image.network(imgurl!,
                    scale: 0.59,
                    fit: BoxFit.cover,
                  )
                  ),
                ),
              ),
            )
          ),


          SizedBox(width: 24,)
        ],
      ),
      body: ZIMKitConversationListView(


        onLongPress: (context, conversation, longPressDownDetails, defaultAction) {
          final conversationBox = context.findRenderObject()! as RenderBox;
          final offset = conversationBox.localToGlobal(Offset(0, conversationBox.size.height / 2));

          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              longPressDownDetails.globalPosition.dx,
              offset.dy,
              longPressDownDetails.globalPosition.dx,
              offset.dy,
            ),
            items: [
              const PopupMenuItem(value: 0, child: Text('Delete')),
              if (conversation.type == ZIMConversationType.group) const PopupMenuItem(value: 1, child: Text('Quit'))
            ],
          ).then((value) {
            switch (value) {
              case 0:
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirm'),
                      content: const Text('Do you want to delete this conversation?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            ZIMKit().deleteConversation(conversation.id, conversation.type);
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                break;
              case 1:
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirm'),
                      content: const Text('Do you want to leave this group?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            ZIMKit().leaveGroup(conversation.id);
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                break;
            }
          });
        },


        onPressed: (context,conversation,defaultAction){

          Navigator.push(context, MaterialPageRoute(
            builder: (context){
              return ZIMKitMessageListPage(

                messageListLoadingBuilder: (context,widget){
                  return Container(child:Image.asset("assets/bg.jpg",
                    fit: BoxFit.cover,

                  ),);
                },


                messageListBackgroundBuilder: (context, defaultWidget) {
                  return Container(
                    color: Colors.white,
                    child:Image.asset("assets/bg.jpg",
                      fit: BoxFit.cover,

                    ),
                  );
                },


                appBarBuilder: (context, defaultAppBar) {
                  return AppBar(
                    backgroundColor: Color(0xffA177E7),
                    title: Row(
                      children: [
                        CircleAvatar(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: GestureDetector(
                              onTap: ()async{
                                if(conversation.type.name=="group"){
                                  showDefaultUserListDialog(context, conversation.id);

                                }else{

                                  await setothersdesc(conversation.id);


                                  // showUserDescriptionDialog(context, othersdesc,conversation.id);
                                  descriptionPopup(context, conversation.id);
                                  print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");

                                }
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                child: Expanded(child: conversation.icon),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: ()async{
                                  if(conversation.type.name=="group"){
                                    showDefaultUserListDialog(context, conversation.id);

                                  }else{

                                    await setothersdesc(conversation.id);


                                    // showUserDescriptionDialog(context, othersdesc,conversation.id);
                                    descriptionPopup(context, conversation.id);
                                    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");

                                  }
                                },
                                child: Text(conversation.name, style: const TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold), overflow: TextOverflow.clip)),
                            GestureDetector(
                                onTap: ()async{
                                  if(conversation.type.name=="group"){
                                    showDefaultUserListDialog(context, conversation.id);

                                  }else{

                                    await setothersdesc(conversation.id);


                                    // showUserDescriptionDialog(context, othersdesc,conversation.id);
                                    descriptionPopup(context, conversation.id);
                                    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");

                                  }
                                },
                                child: Text(conversation.id, style: const TextStyle(fontSize: 12,color: Colors.white), overflow: TextOverflow.clip))
                          ],
                        )
                      ],
                    ),
                    actions: [
                      IconButton(
                          icon: const Icon(Icons.local_phone,color: Colors.white,),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  print(conversation.type.name);
                                  return VoiceCallPage(reciever: conversation.id, calltype: conversation.type.name);
                                },
                              ),
                            );
                          }),

                      IconButton(
                          icon: const Icon(Icons.videocam,color: Colors.white,),
                          onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              print(conversation.type.name);
                              return VideoCallPage(reciever: conversation.id, calltype: conversation.type.name);
                            },
                          ),
                        );
                      }),
                    ],
                  );
                },


                messageItemBuilder: (context, message, defaultWidget){
                  return Theme(
                    data: ThemeData(primaryColor: Colors.deepPurpleAccent.shade100),
                    child: defaultWidget,
                  );
                },


                inputDecoration: InputDecoration(

                  hintText: "Type a message",

                ),


                inputBackgroundDecoration: BoxDecoration(
                  // color:  Color(0xffA177E7).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),


                ),
                appBarActions: [


                  PopupMenuButton(

                      position: PopupMenuPosition.under,
                      shape: RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(3)
                      ),
                      splashRadius: 1,

                      icon: Icon(Icons.more_vert),

                      itemBuilder:(context){
                        return [
                          // PopupMenuItem(
                          //
                          //   value: "Video Call",
                          //   child: Center(child: Icon(CupertinoIcons.video_camera_solid)),
                          //   onTap: (){
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) {
                          //           return VideoCallPage();
                          //         },
                          //       ),
                          //     );
                          //   },
                          // ),


                          (conversation.type == ZIMConversationType.group?

                          PopupMenuItem(
                            value: "Group Members",
                            child: Center(child: Icon(Icons.people_alt_outlined)),
                            onTap: (){
                              showDefaultUserListDialog(context, conversation.id);
                            },
                          ):
                          PopupMenuItem(child: Container(width: 1,))
                          ),

                        ];
                      }
                  ),






                ],
                  conversationID: conversation.id,
                conversationType: conversation.type,
              );
            }
          ));
        },
      ),
    );
  }
}


class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  String? selectedValue; // Change the type to String?

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      value: selectedValue,
      items: <String?>['Option 1', 'Option 2', 'Option 3', 'Option 4']
          .map((String? value) {
        return DropdownMenuItem<String?>(
          value: value,
          child: Text(value ?? ''), // Handle the possibility of null
        );
      }).toList(),
      onChanged: (String? newValue) { // Change the parameter type to String?
        setState(() {
          selectedValue = newValue;
        });
      },
    );
  }
}




Future<dynamic> showDefaultUserListDialog(BuildContext context, String groupID) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('MemberList', style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w600)),
                const SizedBox(height: 5),
                ValueListenableBuilder(
                  valueListenable: ZIMKit().queryGroupMemberList(groupID),
                  builder: (BuildContext context,
                      List<ZIMGroupMemberInfo> memberList, Widget? child) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: 200,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                        scrollDirection: Axis.vertical,
                        itemCount: memberList.length,
                        itemBuilder: (context, index) {
                          final member = memberList[index];
                          return GestureDetector(
                            onTap: () async {},
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Container(

                                    child: Image.network(
                                      member.memberAvatarUrl.isEmpty || member.memberAvatarUrl==""
                                          ? 'https://robohash.org/${member
                                          .userID}.png?set=set4'
                                          : member.memberAvatarUrl,
                                      fit: BoxFit.cover,
                                    ),
                                    width: 70,
                                    height: 70,
                                  ),
                                  Text(
                                    memberList[index].userName,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      });
}

Future<dynamic> showUserDescriptionDialog(BuildContext context, String desc,String oid) {
  String a = " \"  $desc  \" ";
  String b = "by $oid";
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(4),topRight: Radius.circular(4)),
            child: Container(
              height: 150,
              width: double.infinity,

              color: Colors.deepPurple.shade50,
              child: Center(
                child: Container(
                  color: Colors.red,
                  height: 100,
                  width: 300,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        Text(a,
                          style: GoogleFonts.imperialScript(
                            color: Colors.deepPurple.shade300,
                            fontWeight: FontWeight.bold,
                            fontSize: 28
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(b,
                          style: GoogleFonts.imperialScript(
                              color: Colors.deepPurple.shade300,
                              fontWeight: FontWeight.w600,
                              fontSize: 20
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ),
          ),
        );
      });
}


