import 'package:flutter/material.dart';
import 'package:test_social/chatRoom.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:test_social/model/usermodel.dart';
import 'package:test_social/login.dart';
import 'package:test_social/roomList.dart';


void main() {

  final user = UserModel();

  runApp(
    ScopedModel<UserModel>(
      model: user,
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyLogin(),
        '/chat' : (context) => ChatRoom(),
        '/roomlist' : (context) => RoomList(),
      },
    );
  }
}
