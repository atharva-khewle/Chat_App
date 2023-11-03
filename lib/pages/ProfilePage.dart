import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chatapp/Hive/thebox.dart';
import 'package:chatapp/firebase/filestorage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
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
  String? username;
  String? userid;
  String? password;
  String? description;
  bool passswordvisibility=false;
  firestoresrevice service = new firestoresrevice();
  final updatedusername = TextEditingController();
  final updatedpassword1 = TextEditingController();
  final updatedpassword2 = TextEditingController();
  final updateddesc = TextEditingController();

  final faccount =  FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState

  getphoto();
  getname();
  getpass();
  getdesc();
  super.initState();
  }





  Future<int> getphoto()async{

    String? temp= await service.getimage();
    if(temp !=null) {
      setState(() {
        imgurl = temp;
      });
    }
    return 0;
  }

  void getname()async{

    String? temp= await service.getusername();
    setState((){
      username= temp;

    });
}


  void getpass()async{

    String? temp= await service.getpassword();
    setState((){
      password= temp;

    });
  }

  void getdesc()async{

    String? temp= await service.getdescription();
    setState((){
      description= temp;

    });
  }








//   https://www.youtube.com/watch?v=3x92z0oHbtY
//photos selected
  PlatformFile? selectedphoto;
  String photopath="";
  UploadTask? uploadedtask;

Future selectfile(setState)async{
    final res = await FilePicker.platform.pickFiles();
    if(res ==null){return ;}
    print("done}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}$photopath");

    setState(() {
      selectedphoto = res.files.first;

      photopath = selectedphoto!.path!;

    });
    print("done}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}$photopath");



}




// Future uploadphoto(setState)async{
//   final path = "files/${selectedphoto?.name}";
//   final file = File(selectedphoto!.path!);
//
//   final onlinestorageref =  FirebaseStorage.instance.ref().child(path);
//   uploadedtask = onlinestorageref.putFile(file);
//
//   final snapshot = await uploadedtask?.whenComplete(() => {print("uploaded++++++++++++++++++++++++++++++++++++++++")});
//
//
// }
FileStorage storagedb = new FileStorage();










  void googleSignOut()async {
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
    print("++++++++++++++++++++++++++++=signed out from forebase and google++++++++++++++++++++++++++++++");
  }


//zimkit update image
  Future<ZIMUserAvatarUrlUpdatedResult> zimupdateUserAvatarUrl(String userAvatarUrl)async{
    try {
      ZIMUserAvatarUrlUpdatedResult result =
          await ZIM.getInstance()!.updateUserAvatarUrl(userAvatarUrl);
      return result;

      //The logic of successful modification is written here
    } catch (onError) {
      print("errotr while updating iamge ______________________________________________________");
      ZIMUserAvatarUrlUpdatedResult result =
      await ZIM.getInstance()!.updateUserAvatarUrl(userAvatarUrl);

      return result;
      
    }
  }

//zimkiot update username
  Future<ZIMUserNameUpdatedResult> zimupdateUserName(String userName)async{
    try {
      ZIMUserNameUpdatedResult result =
          await ZIM.getInstance()!.updateUserName(userName);
      return result;
    }  catch (onError) {
      print("errotr while updating iamge ______________________________________________________");
      ZIMUserNameUpdatedResult result =
      await ZIM.getInstance()!.updateUserName(userName);
      return result;

    }
  }







//hive
  userbox box1 = new userbox();
  connectedornot box2 = new connectedornot();


//uploading image popup
  Future uploadimgpopup(context){
    return showDialog(
        context: context,
        builder: (context){
      return   StatefulBuilder(builder:(context,StateSetter setState){
        return Container(
          child: AlertDialog(
            contentPadding: EdgeInsets.all(2),
            title: Center(
              child: Text("Choose Avatar",
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                    fontSize: 22
                ),
              ),
            ),

            content: Container(
              height: 260,
              // color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color:Color(0xffA177E7),
                              width: 3.1
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(5000.0) //                 <--- border radius here
                          ),
                        ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2000),
                        child: Container(
                          height: 200,
                          width: 200,
                          // color: Colors.pink,




                          child: (
                              photopath==""?
                              (
                                  imgurl==null || imgurl ==""?
                                  Image.asset("assets/u.jpg",
                                    fit: BoxFit.cover,

                                  )
                                      :
                                  Image.network(imgurl!,
                                    scale: 0.59,
                                    fit: BoxFit.cover,

                                  )
                              )
                                  :
                          Image.file(
                            File(photopath!,),
                            fit: BoxFit.cover,

                          )
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(selectedphoto==null ? "Orion.jpg" : selectedphoto!.name,
                    style: TextStyle(
                      color: Color(0xffA177E7),
                      fontWeight: FontWeight.w500,
                      fontSize: 17
                    ),
                    )
                    // color: Colors.blue,
                    // child: Text(selectedphoto.name,)
                  ),

                ],
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            actions: [
              MaterialButton(
                child: Text("Select Image"
                  ,style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                  ),
                ),
                color: Color(0xffA177E7),
                onPressed: ()async{
                  await selectfile(setState);
                },
              ),

              //upload
              MaterialButton(
                child: Text("Upload"
                  ,style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                  ),
                ),
                color: Color(0xffA177E7),
                onPressed: ()async{
                  storagedb.uploadfileandgiveurl(photopath, selectedphoto!.name).then((value) => {
                  Navigator.pop(context),
                    service.updatephoto(ZIMKit().currentUser()!.baseInfo.userID, value),
                    getname(),
                    zimupdateUserAvatarUrl(value),
                    setState((){
                      imgurl=value;

                      // getphoto();
                    }),
                    imgurl= value,
                    print("uploadedddddddddddddddddddddddddddddddddddddddddddddddddddddddddd"),

                  });



                  // uploadphoto(setState);

                },
              ),

            ],
          ),
        );
      });
    });
  }


  Future seeimgpopup(context){
    return showDialog(
        context: context,
        builder: (context){
      return   StatefulBuilder(builder:(context,StateSetter setState){
        return Container(
          child: AlertDialog(
            contentPadding: EdgeInsets.all(2),
            // title: Center(
            //   child: Text("Choose Avatar",
            //     style: TextStyle(
            //         color: Colors.deepPurple,
            //         fontWeight: FontWeight.w500,
            //         fontSize: 22
            //     ),
            //   ),
            // ),

            content: Container(
              height: 250,
              child: (imgurl==null || imgurl ==""?
              Image.asset("assets/u.jpg",)
                  :
              Image.network(imgurl!,
                scale: 0.59,
                fit: BoxFit.cover,
              )
            ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),

          ),
        );
      });
    });
  }


  void setnewusername(){
      setState(() {
        username = updatedusername.text;
        updatedusername.text = "";
      });

  }
  void setnewdesc(){
      setState(() {
        description = updateddesc.text;
        updateddesc.text = "";
      });

  }
  void setnewpass(){
    setState(() {
      password = updatedpassword1.text;
      updatedpassword2.text = "";
      updatedpassword1.text = "";
    });

  }


  //update uername popup
  Future usernameEditPopup(context){
    return showDialog(
        context: context,
        builder: (context){
          return   StatefulBuilder(builder:(context,StateSetter setState){
            return Container(
              child: AlertDialog(
                contentPadding: EdgeInsets.all(2),
                title: Center(
                  child: Text("New Username",
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w500,
                        fontSize: 22
                    ),
                  ),
                ),

                content: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(

                      color: Color(0xffA177E7).withOpacity(0.7),
                      height: 35,
                      child: TextFormField(

                        style: TextStyle(color: Colors.white),

                        controller: updatedusername,

                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 1, right: 15),
                          hintText: "Username",

                          border: InputBorder.none,

                        ),
                      ),
                    ),
                  ),
                ),



                // content: ClipRRect(
                //   borderRadius: BorderRadius.circular(4),
                //   child: Container(
                //       color: Color(0xffA177E7).withOpacity(0.7),
                //       height: 90,
                //       child : TextField(
                //         controller: groupIDController,
                //         keyboardType: TextInputType.text,
                //         decoration: const InputDecoration(
                //           border: OutlineInputBorder(),
                //           labelText: 'Group ID',
                //         ),
                //       ),
                //
                //
                //   ),
                // ),



                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),

                actions: [
                  MaterialButton(
                    child: Text("Cancel"
                      ,style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                    ),
                    color: Color(0xffA177E7),
                    onPressed: (){
                      Navigator.pop(context);
                    },

                  ),
                  MaterialButton(
                    child: Text("Update"
                      ,style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                    ),
                    color: Color(0xffA177E7),
                    onPressed: ()async{

            if(updatedusername.text!="") {
              await service.updateusername(ZIMKit()
                  .currentUser()!
                  .baseInfo
                  .userID, updatedusername.text);
              await zimupdateUserName(updatedusername.text);
              setnewusername();
              Navigator.pop(context);
            }

                    },

                  ),
                ],

              ),
            );
          });
        });
  }



  //update description popup
  Future descEditPopup(context){
    return showDialog(
        context: context,
        builder: (context){
          return   StatefulBuilder(builder:(context,StateSetter setState){
            return Container(
              child: AlertDialog(
                contentPadding: EdgeInsets.all(2),
                title: Center(
                  child: Text("New description",
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w500,
                        fontSize: 22
                    ),
                  ),
                ),

                content: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(

                      color: Color(0xffA177E7).withOpacity(0.7),
                      height:120,
                      child: TextFormField(

                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: updateddesc,

                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 1, right: 15),
                          hintText: "Type...",

                          border: InputBorder.none,

                        ),
                      ),
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),

                actions: [
                  MaterialButton(
                    child: Text("Cancel"
                      ,style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                    ),
                    color: Color(0xffA177E7),
                    onPressed: (){
                      Navigator.pop(context);
                    },

                  ),
                  MaterialButton(
                    child: Text("Update"
                      ,style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                    ),
                    color: Color(0xffA177E7),
                    onPressed: ()async{
                      if(updateddesc.text!="") {
            await service.updatedescription(ZIMKit().currentUser()!.baseInfo.userID, updateddesc.text);
            setnewdesc();
            Navigator.pop(context);
            }
                    },

                  ),
                ],

              ),
            );
          });
        });
  }



  //update passowrd popup
  Future passwordEditPopup(context){
    return showDialog(
        context: context,
        builder: (context){
          return   StatefulBuilder(builder:(context,StateSetter setState){
            return Container(
              child: AlertDialog(
                contentPadding: EdgeInsets.all(2),
                title: Center(
                  child: Text("Update Password",
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w500,
                        fontSize: 22
                    ),
                  ),
                ),

                content: Container(
                  constraints: BoxConstraints(
                    maxHeight: 148
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 25, 30, 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(

                            color: Color(0xffA177E7).withOpacity(0.7),
                            height: 35,
                            child: TextFormField(

                              style: TextStyle(color: Colors.white),

                              controller: updatedpassword1,

                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                contentPadding:
                                EdgeInsets.only(left: 15, bottom: 11, top: 1, right: 15),
                                hintText: "New password",

                                border: InputBorder.none,

                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(

                            color: Color(0xffA177E7).withOpacity(0.7),
                            height: 35,
                            child: TextFormField(

                              style: TextStyle(color: Colors.white),

                              controller: updatedpassword2,

                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                contentPadding:
                                EdgeInsets.only(left: 15, bottom: 11, top: 1, right: 15),
                                hintText: "Confirm Password",

                                border: InputBorder.none,

                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),

                actions: [
                  MaterialButton(
                    child: Text("Cancel"
                      ,style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                    ),
                    color: Color(0xffA177E7),
                    onPressed: (){
                      Navigator.pop(context);
                    },

                  ),
                  MaterialButton(
                    child: Text("Update"
                      ,style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                    ),
                    color: Color(0xffA177E7),
                    onPressed: ()async{
                      if(updatedpassword1.text!=""  &&   updatedpassword1.text!=""  && updatedpassword1.text == updatedpassword2.text) {
                        await service.updatepassword(ZIMKit().currentUser()!.baseInfo.userID, updatedpassword2.text);
                        setnewpass();
                        Navigator.pop(context);
                      }
                    },

                  ),
                ],

              ),
            );
          });
        });
  }



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



          GoRouter.of(context).go("/Login");



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
                  SizedBox(height: 35,),
                  //photo
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: (){
                          seeimgpopup(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:Color(0xffA177E7),
                                width: 3.1
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5000.0) //                 <--- border radius here
                            ),
                          ),

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(75),
                            child: Container(
                              height: 145,
                              width: 145,
                              // color: Colors.purpleAccent,
                              // child: Image.asset("assets/u.jpg",),
                              // child: Image.network("https://picsum.photos/200"),
                              child: (
                                  imgurl==null || imgurl ==""?
                                  Image.asset("assets/u.jpg",)
                                      :
                                  Image.network(imgurl!,
                                    scale: 0.59,
                                    fit: BoxFit.cover,

                                  )
                              ),
                            ),
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
                                      uploadimgpopup(context).then((value) {});
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
                  SizedBox(height: 14,),
                  // Image.network("https://firebasestorage.googleapis.com/v0/b/orionchat-flutter.appspot.com/o/files%2Fjon-r8AFUpRp0J0-unsplash.jpg?alt=media&token=acd75dba-7f84-4c5d-9c26-1e2fa2b1d8ad"),
                  Container(
                    // color: Colors.deepPurple.shade200,
                    width: 250,
                    height: 1.5,
                  ),
                  SizedBox(height: 20,),
                  //username
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
                                      "${username}",
                                      style: TextStyle(
                                        color: Color(0xff825db7),
                                        overflow: TextOverflow.visible
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: (){
                                  usernameEditPopup(context);
                                },
                                icon: Icon(Icons.edit,color: Color(0xffA177E7),)),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 13,),
                  //id
                  Container(
                    width: 330,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple.shade200),
                        borderRadius: BorderRadius.circular(5)
                    ),

                    //userID
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
                  SizedBox(height: 13,),
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
                  SizedBox(height: 13,),
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
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  passswordvisibility = !passswordvisibility;
                                });
                              },
                              child: Icon(
                                (passswordvisibility==false?
                                CupertinoIcons.eye_slash
                                    :
                                CupertinoIcons.eye
                                )
                          ,color: Color(0xffA177E7),),
                            ),

                            Container(
                              width: 190,
                              child: Row(
                                children: [
                                  Flexible(
                                    child:Text(

                                      // "${(result["pass"]==null || result["pass"] =="")?"please set password":result["pass"]}",
                                      passswordvisibility == true
                                          ? "$password"
                                          : '${password?.replaceAll(RegExp(r"."), "○")}'
                                      ,
                                      style: TextStyle(


                                          color: Color(0xff825db7),
                                        fontWeight: FontWeight.bold
                                      ),
                                      overflow: TextOverflow.visible,

                                    ),


                                  )
                                ],
                              ),
                            ),
                            IconButton(onPressed: (){
                              passwordEditPopup(context);
                            }, icon: Icon(Icons.edit,color: Color(0xffA177E7),)),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 13,),
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
                                    // result["desc"]==null?"i am human :}":result["desc"]
                                    "$description",
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

                            IconButton(onPressed: (){
                              descEditPopup(context);

                            }, icon: Icon(Icons.edit,color: Color(0xffA177E7),)),

                          ],
                        ),
                      ),
                    ),
                  ),







                ],
              ),
              Column(
                children: [



                  SizedBox(height: 25,),
                  Container(
                    color: Colors.deepPurple.shade200,
                    width: 250,
                    height: 1.5,
                  ),
                  SizedBox(height: 18,),
                  ElevatedButton(
                    onPressed: ()async{
                      ZegoUIKitPrebuiltCallInvitationService().uninit();

                       googleSignOut();
                      ZIMKit().disconnectUser();
                      box1.deleteuserdata();
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
                  SizedBox(height: 12,),
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
