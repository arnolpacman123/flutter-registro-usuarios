import 'package:flutter/material.dart';
import 'package:registro_de_usuarios/pages/add_edit_client_page.dart';
import 'package:registro_de_usuarios/pages/home_page.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de usuarios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.route,
      routes: {
        HomePage.route: (context) => HomePage(),
        AddEditClientPage.route: (context) => const AddEditClientPage(false),
      },
    );
  }
}