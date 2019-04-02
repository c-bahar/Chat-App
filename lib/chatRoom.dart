import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:test_social/model/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final chatController = TextEditingController();

  Widget send() {
    String roomName =
        ScopedModel.of<UserModel>(context, rebuildOnChange: true).roomName;
    String name =
        ScopedModel.of<UserModel>(context, rebuildOnChange: true).name;
    Firestore.instance
        .collection('rooms')
        .document(roomName)
        .collection('messages')
        .add({
      'user': name,
      'message': chatController.text,
      'created_at': DateTime.now(),
    });
  }

  Widget textInput() {
    return Container(
      decoration: new BoxDecoration(
        color: Color.fromRGBO(240, 240, 250, 1),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.message,
            color: Color.fromRGBO(100, 100, 150, 0.9),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          Expanded(
            flex: 1,
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: chatController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                filled: true,
                fillColor: Color.fromRGBO(250, 250, 250, 1),
                hintText: "Enter your text",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(150, 150, 250, 1),
                    )),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(150, 150, 250, 1),
                  ),
                ),
              ),
            ),
          ),
          new IconButton(
              icon: Icon(Icons.send, color: Color.fromRGBO(100, 100, 150, 0.9)),
              onPressed: () {
                send();
                chatController.clear();
              }),
        ],
      ),
    );
  }

  Widget chat() {
    String roomName =
        ScopedModel.of<UserModel>(context, rebuildOnChange: true).roomName;
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('rooms')
          .document(roomName)
          .collection('messages')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (context, int index) {
              String name =
                  ScopedModel.of<UserModel>(context, rebuildOnChange: true)
                      .name;
              DocumentSnapshot document = snapshot.data.documents[index];
              bool isMyMessage = false;
              if (document['user'] == name) {
                isMyMessage = true;
              }
              return isMyMessage
                  ? myMessage(document['user'], document['message'])
                  : messages(document['user'], document['message']);
            },
            itemCount: snapshot.data.documents.length,
          );
        } else {
          return new Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget topBar() {
    String roomName =
        ScopedModel.of<UserModel>(context, rebuildOnChange: true).roomName;
    return AppBar(
      backgroundColor: Color.fromRGBO(240, 240, 250, 1),
      title: Text('$roomName'),
    );
  }

  Widget myMessage(String userName, String message) {
    return Container(
      margin: EdgeInsets.only(right: 0, bottom: 7, left: 200),
      padding: EdgeInsets.only(left: 10, right: 5),
      decoration: new BoxDecoration(
        border: new Border.all(color: Colors.blueGrey, width: 1),
        borderRadius: new BorderRadius.circular(10),
        color: Color.fromRGBO(100, 100, 200, 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$userName',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2),
          ),
          Text(
            '$message',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Padding(
            padding: EdgeInsets.all(2),
          ),
        ],
      ),
    );
  }

  Widget messages(String userName, String message) {
    return Container(
      margin: EdgeInsets.only(left: 3, right: 200, bottom: 7),
      padding: EdgeInsets.only(left: 10, right: 5),
      decoration: new BoxDecoration(
        border: new Border.all(color: Colors.blueGrey, width: 1),
        borderRadius: new BorderRadius.circular(10),
        color: Color.fromRGBO(100, 100, 200, 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$userName',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2),
          ),
          Text(
            '$message',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Padding(
            padding: EdgeInsets.all(2),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(235, 235, 235, 1.0),
        body: Container(
            child: Column(
          children: <Widget>[
            topBar(),
            Expanded(
              child: chat(),
            ),
            textInput(),
          ],
        )));
  }
}
