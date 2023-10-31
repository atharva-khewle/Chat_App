
import 'package:chatapp/pages/call/Callpage.dart';
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
  firestoresrevice service = new firestoresrevice();

  @override
  void initState() {
    // TODO: implement initState
    imgurl = service.getimgurl();

    super.initState();
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




          MaterialButton(
            onPressed: (){
              GoRouter.of(context).go("/ProfilePage");
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Container(
                width: 25,
                height: 25,
                child:(
                    imgurl==null?
                    Image.asset("assets/u.jpg",)
                        :
                    Image.network(imgurl!,scale: 0.6,)
                ),
              ),
            )
          ),


          SizedBox(width: 0,)
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
                          PopupMenuItem(

                            value: "Video Call",
                            child: Center(child: Icon(CupertinoIcons.video_camera_solid)),
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CallPage();
                                  },
                                ),
                              );
                            },
                          ),


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
                                  Image.network(
                                    member.memberAvatarUrl.isEmpty
                                        ? 'https://robohash.org/${member
                                        .userID}.png?set=set4'
                                        : member.memberAvatarUrl,
                                    fit: BoxFit.cover,
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