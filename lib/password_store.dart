import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:passwordvault/model/item.dart';
import 'package:passwordvault/password_kart.dart';
import 'package:passwordvault/password_store.dart';
import 'package:passwordvault/services/database_creator.dart';
import 'package:passwordvault/services/services_password_vault.dart';

import 'package:passwordvault/services/password_lock.dart';

PasswordLock _passwordLock = PasswordLock();

class PasswordStore extends StatefulWidget {
  final int itemID;
  final String oldPassword;

  PasswordStore({this.itemID,this.oldPassword});

  @override
  _PasswordStoreState createState() => _PasswordStoreState();
}

class _PasswordStoreState extends State<PasswordStore> {
  bool passwordVisible = true;
  int _id;

  final _formKey = GlobalKey<FormState>();

  final appCon = TextEditingController();
  final usernameCon = TextEditingController();
  final passwordCon = TextEditingController();


  Codec<String, String> stringToBase64 = utf8.fuse(base64);

  @override
  void initState() {
    super.initState();
    if (widget.itemID != null) {
      readData();
    }
  }

  void readData() async {
    final item = await ServicesPasswordVault.getItem(widget.itemID);
    appCon.text = item.application;
    usernameCon.text = item.username;
    passwordCon.text = item.password;
  }

  updateItem() async {
    final item = await ServicesPasswordVault.getItem(widget.itemID);
    item.application = appCon.text;
    item.username = usernameCon.text;
   if (widget.oldPassword != passwordCon.text) item.password = _passwordLock.lockPassword(passwordCon.text);

    await ServicesPasswordVault.updateItem(item);
    setState(() {
      Navigator.pop(context, null);
    });
  }

  deleteItem() async {
    final item = await ServicesPasswordVault.getItem(widget.itemID);
    print(item.application);
    await ServicesPasswordVault.deleteItem(item);
    setState(() {
      Navigator.pop(context, null);
    });
  }

  void addItem() async {
    int count = await ServicesPasswordVault.itemCount();
    final item = Item(
        id: count,
        application: appCon.text,
        username: usernameCon.text,
        password: _passwordLock.lockPassword(passwordCon.text));
    await ServicesPasswordVault.addItem(item);
    setState(() {
      _id = item.id;
      Navigator.pop(context, null);
    });
    print(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context, null),
          ),
          title: Text('Password Vault'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    height: 120.0,
                    width: 120.0,
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Image.asset('images/privacy.png')),
                Text(
                  'PASSWORD VAULT',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0),
                ),
                SizedBox(
                  height: 50.0,
                  width: 300.0,
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                passwordStore(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container passwordStore() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
//      User App Name
          storeItem(
              icon: Icons.web,
              labelText: 'Application Name',
              controller: appCon),
//      User username
          storeItem(
              icon: Icons.person,
              labelText: 'Username',
              controller: usernameCon),
//      User password
          storeItemPassword(
              icon: Icons.lock, labelText: 'Password', controller: passwordCon),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                storeActionButton(
                    color: Colors.red,
                    value: widget.itemID == null ? 'Cancel' : 'Delete'),
                storeActionButton(
                    color: Colors.green,
                    value: widget.itemID == null ? 'Save' : 'Update'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container storeItem(
      {IconData icon, String labelText, TextEditingController controller}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      color: Colors.white,
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.blue,
            ),
          ],
        ),
        title: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: labelText,
          ),
        ),
      ),
    );
  }

  Container storeItemPassword(
      {IconData icon, String labelText, TextEditingController controller}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      color: Colors.white,
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.blue,
            ),
          ],
        ),
        title: TextFormField(
          controller: controller,
          obscureText: passwordVisible,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: labelText,
          ),
        ),
        trailing: Container(
          child: FlatButton(
            child: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              showPassword();
            },
          ),
        ),
      ),
    );
  }

  void showPassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  RaisedButton storeActionButton({Color color, String value}) {
    return RaisedButton(
      color: color,
      textColor: Colors.white,
      child: Text(value),
      onPressed: () {
        if (value == 'Save') {
          addItem();
        } else if (value == 'Update') {
          actionUpdate();
        } else if (value == 'Delete') {
          actionDelete();
        } else {
          actionCancel();
        }
      },
    );
  }

  void actionSave() {
    addItem();
  }

  void actionUpdate() {
    updateItem();
  }

  void actionDelete() {
    deleteItem();
  }

  void actionCancel() {
    Navigator.pop(context, null);
  }

  Route _gotoPasswordKart() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PasswordKart(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}
