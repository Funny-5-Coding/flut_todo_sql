import 'package:flutter/material.dart';
import 'package:flutter_todo_sql/routes/routes.dart';
import 'package:flutter_todo_sql/services/todo_service.dart';
import 'package:flutter_todo_sql/services/user_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserService()),
          ChangeNotifierProvider(create: (context) => TodoService()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: RouteManager.loginPage,
          onGenerateRoute: RouteManager.generateRoute,
        ),
      );
}
