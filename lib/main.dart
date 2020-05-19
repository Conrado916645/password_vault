import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passwordvault/services/database_creator.dart';
import 'password_kart.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      home:  PasswordKart()
      ,
    );
  }
}
