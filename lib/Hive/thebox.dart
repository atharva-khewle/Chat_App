
import 'package:hive/hive.dart';

class userbox{
  final boxref = Hive.box("one");

  void putinbox(Map<String,String> apple){
    boxref.put("userdata", apple);
  }

  Map<String, String> getdata() {
    final userData = boxref.get("userdata");
    if (userData is Map<String, String>) {
      return userData;
    } else {
      return {"connected":"no"};
    }
  }


  void deleteuserdata(){
    boxref.delete("userdata");
  }



}

class connectedornot{
  final boxref = Hive.box("two");


  void putinbox(String a,int key){
    boxref.put(key, a);
  }

  String getdata(int key) {
    if (boxref.get(key) is String) {
      return boxref.get(key);
    } else {
      return "no";
    }  }


  void deleteuserdata(int key){
    boxref.delete(key);
  }

}