import 'package:flutter/material.dart';
import 'package:flutter_todo_sql/pages/login.dart';
import 'package:flutter_todo_sql/pages/register.dart';
import 'package:flutter_todo_sql/pages/todo_page.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String registerPage = '/registerPage';
  static const String todoPage = '/todoPage';

  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => Login(),
        );
      case registerPage:
        return MaterialPageRoute(
          builder: (context) => Register(),
        );
      case todoPage:
        return MaterialPageRoute(
          builder: (context) => TodoPage(),
        );
      default:
        throw FormatException('Route not found! Check routes again!');
    }
  }
}
