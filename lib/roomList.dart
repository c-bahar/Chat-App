import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:test_social/model/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomList extends StatefulWidget {
  @override
  RoomListState createState() => RoomListState();
}

class RoomListState extends State<RoomList> {
  final roomController = new TextEditingController();
  bool showModal = false;

  Widget roomList() {
    if (showModal) {
      return Expanded(
          child: Center(
              child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: roomController,
              decoration: InputDecoration(
                  hintText: 'Enter room name',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueGrey,
                    ),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey))),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            createRoom(),
          ],
        ),
      )));
    } else {
      return Flexible(
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('rooms').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return new ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, int index) {
                  if (snapshot.hasData) {
                    DocumentSnapshot document = snapshot.data.documents[index];
                    return ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) =>
                            (new GestureDetector(
                              onTap: () {
                                model.changeRoomName(document['name']);
                                Navigator.pushNamed(context, '/chat');
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(10),
                                decoration: new BoxDecoration(
                                    color: Color.fromRGBO(240, 240, 240, 1),
                                    border: new Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    )),
                                child: Text(
                                  document['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19,
                                  ),
                                ),
                              ),
                            )));
                  }
                },
                itemCount: snapshot.data.documents.length,
              );
            }),
      );
    }
  }

  Future<void> loadRoom() async {
    await Firestore.instance
        .collection('rooms')
        .document(roomController.text)
        .setData({
      'name': roomController.text,
    });

    setState(() {
      showModal = false;
    });

    roomController.clear();
    await Navigator.pushNamed(context, '/chat');
  }

  Widget createRoom() {
    return ScopedModelDescendant<UserModel>(
        builder: (context, child, model) => Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                    backgroundColor: Colors.blueGrey,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          showModal = false;
                        });
                        roomController.clear();
                      },
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.blueGrey,
                    child: IconButton(
                      icon: Icon(Icons.add_circle),
                      onPressed: () {
                        model.changeRoomName(roomController.text);
                        loadRoom();
                      },
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget createIcon() {
    return ScopedModelDescendant<UserModel>(
        builder: (context, child, model) => (new IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                setState(() {
                  showModal = true;
                });
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          createIcon(),
        ],
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          roomList(),
        ],
      )),
    );
  }
}
