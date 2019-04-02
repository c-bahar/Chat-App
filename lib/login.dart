import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:test_social/model/usermodel.dart';

class MyLogin extends StatefulWidget {
  @override
  MyLoginScreen createState() => MyLoginScreen();
}

class MyLoginScreen extends State<MyLogin> {
  final nameController = new TextEditingController();
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: formUI(context),
    );
  }

  Widget nameInput() {
    return Container(
      margin: const EdgeInsets.all(25),
      decoration: BoxDecoration(),
      child: TextFormField(
        controller: nameController,
        style: TextStyle(
          color: Color.fromRGBO(75, 75, 100, 1),
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(225, 225, 225, 0.9),
          prefixIcon: Icon(
            Icons.person,
            color: Color.fromRGBO(100, 100, 200, 0.9),
          ),
          hintText: "john",
          hintStyle: TextStyle(
            color: Color.fromRGBO(100, 100, 100, 1),
          ),
          labelText: "Username",
          labelStyle: TextStyle(
            color: Color.fromRGBO(100, 100, 100, 1),
          ),
          contentPadding: EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide:
                BorderSide(color: Color.fromRGBO(100, 100, 200, 0.9), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: Color.fromRGBO(100, 100, 200, 0.9),
                width: 1,
              )),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: Color.fromRGBO(100, 50, 50, 1),
                width: 1.5,
              )),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: Color.fromRGBO(100, 50, 50, 1),
                width: 1.5,
              )),
          errorStyle: TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(225, 225, 225, 0.9),
            fontWeight: FontWeight.bold,
          ),
        ),
        validator: validateName,
      ),
    );
  }

  Widget login() {
    return ScopedModelDescendant<UserModel>(
        builder: (context, child, model) => new RaisedButton(
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  model.changeEmail(nameController.text.trim());
                  nameController.clear();
                  Navigator.pushReplacementNamed(context, '/roomlist');
                }
              },
              color: Color.fromRGBO(100, 100, 150, 0.9),
            ));
  }

  Widget formUI(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: new DecorationImage(
      //       image: new AssetImage("/Users/caferbahar/Desktop/test_social/lib/assets/background.jpg"),
      //       fit: BoxFit.cover,
      //     ),
      // ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            nameInput(),
            login(),
          ],
        ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return "Enter E-mail Address";
    } else if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  String validateName(String value) {
    if (value.isEmpty) {
      return 'Enter name';
    } else {
      return null;
    }
  }
}
