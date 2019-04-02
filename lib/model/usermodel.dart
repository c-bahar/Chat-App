import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
var chat = new List();
String name;
String roomName;

changeEmail(String str){
  name = str;
  notifyListeners();
}
changeRoomName(String str){
  roomName = str;
  notifyListeners();
}
addList(String str){
  chat.add(str);
  notifyListeners();
}
}