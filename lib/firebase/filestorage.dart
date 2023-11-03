import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FileStorage{
  final FirebaseStorage storage = FirebaseStorage.instance;


  Future<String> uploadfileandgiveurl(String fpath,String fname)async{
    File filex = File(fpath);

    try{
      print("started");
      TaskSnapshot snapshot = await storage.ref("files/$fname").putFile(filex);

      final url = await snapshot.ref.getDownloadURL();
      print("end$url");
      return url;
    } on FirebaseException catch(e){
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$e");
      return "error";
    }

  }
}