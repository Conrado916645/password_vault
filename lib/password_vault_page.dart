import 'package:flutter/material.dart';
import 'package:passwordvault/password_store.dart';

class PasswordVaultPage extends StatefulWidget {
  @override
  _PasswordVaultPageState createState() => _PasswordVaultPageState();
}

class _PasswordVaultPageState extends State<PasswordVaultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Vault'),
      ),
      body:  SafeArea(
        child: PasswordStore(),
      ),
    );
  }
}
