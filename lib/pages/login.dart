import 'package:flutter/material.dart';
import 'package:flutter_todo_sql/routes/routes.dart';
import 'package:flutter_todo_sql/services/todo_service.dart';
import 'package:flutter_todo_sql/services/user_service.dart';
import 'package:flutter_todo_sql/widgets/app_textfield.dart';
import 'package:flutter_todo_sql/widgets/button.dart';
import 'package:flutter_todo_sql/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple,
              Colors.blue,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                  ),
                ),
                AppTextField(
                  controller: usernameController,
                  labelText: 'Please enter username',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: VioletButton(
                    text: 'Continue',
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (usernameController.text.isEmpty)
                        showSnackBar(
                            context, 'Please enter the username first');
                      else {
                        var result = await context
                            .read<UserService>()
                            .getUser(usernameController.text.trim());
                        if (result != 'OK')
                          showSnackBar(context, result);
                        else {
                          var username =
                              context.read<UserService>().currentUser.username;
                          context.read<TodoService>().getTodos(username);
                          Navigator.of(context)
                              .pushNamed(RouteManager.todoPage);
                        }
                      }
                    },
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteManager.registerPage);
                  },
                  child: Text('Register a new User'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
