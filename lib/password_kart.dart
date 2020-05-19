import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passwordvault/model/item.dart';
import 'package:passwordvault/password_store.dart';
import 'package:passwordvault/services/database_creator.dart';
import 'package:passwordvault/services/services_password_vault.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:passwordvault/services/password_lock.dart';

PasswordLock _passwordLock = PasswordLock();

class PasswordKart extends StatefulWidget {
  @override
  _PasswordKartState createState() => _PasswordKartState();
}

class _PasswordKartState extends State<PasswordKart> {
  final _formKey = GlobalKey<FormState>();
  Future<List<Item>> future;

  @override
  void initState() {
    super.initState();
    future = ServicesPasswordVault.getAllUItem();
  }

  Future<void> _showMyDialog(Item item) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Text(
                    item.application,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                  width: 300.0,
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  color: Colors.grey[50],
                  child: ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      title: Text('${item.username}')),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  color: Colors.grey[50],
                  child: ListTile(
                      leading: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      title: Text(
                          '${_passwordLock.unlockPassword(item.password)}')),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.red,
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Column buildItem(Item item) {
//    String subValue = "Username: ${item.username}\nPassword: ${item.password}";
    return Column(
      children: <Widget>[
        ListTile(
          leading: Container(
            width: 50.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
            child: Text(
              '${item.application[0]}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.white),
            ),
          ),
          title: Text(
            '${item.application}',
            style: TextStyle(fontSize: 22.0),
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right
          ),
          onTap: () {
            _navigateToUpdatePasswordStoreItem(context, item.id);
          },
          onLongPress: () {
            setState(() {
              _showMyDialog(item);
            });
          },
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Vault'),
      ),
      body: ListView(
        children: <Widget>[
          FutureBuilder<List<Item>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children:
                      snapshot.data.map((item) => buildItem(item)).toList(),

                );
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          _navigateToNewPasswordStoreItem(context);
        },
      ),
    );
  }

  _navigateToNewPasswordStoreItem(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => PasswordStore()));
    if (result == null) {
      setState(() {
        future = ServicesPasswordVault.getAllUItem();
      });
    }
  }

  _navigateToUpdatePasswordStoreItem(BuildContext context, int itemID) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PasswordStore(itemID: itemID)));
    if (result == null) {
      setState(() {
        future = ServicesPasswordVault.getAllUItem();
      });
    }
  }
}
