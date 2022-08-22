import 'package:flutter/material.dart';
import 'package:flutter_todo_sql/models/todo.dart';
import 'package:flutter_todo_sql/models/user.dart';
import 'package:flutter_todo_sql/services/todo_service.dart';
import 'package:flutter_todo_sql/services/user_service.dart';
import 'package:flutter_todo_sql/widgets/dialogs.dart';
import 'package:flutter_todo_sql/widgets/todoCard.dart';
import 'package:provider/provider.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TextEditingController todoController;

  @override
  void initState() {
    super.initState();
    todoController = TextEditingController();
  }

  @override
  void dispose() {
    todoController.dispose();
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
            colors: [Colors.purple, Colors.blue],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text('Create a new TODO'),
                              content: TextField(
                                decoration: InputDecoration(
                                    hintText: 'Please enter TODO'),
                                controller: todoController,
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text('Save'),
                                  onPressed: () async {
                                    if (todoController.text.isEmpty) {
                                      showSnackBar(context,
                                          'Please enter a todo first, then save');
                                    } else {
                                      var username = context
                                          .read<UserService>()
                                          .currentUser
                                          .username;

                                      Todo todo = Todo(
                                        username: username,
                                        title: todoController.text.trim(),
                                        created: DateTime.now(),
                                      );

                                      if (context
                                          .read<TodoService>()
                                          .todos
                                          .contains(todo))
                                        showSnackBar(context,
                                            'Duplicate value. Please try again');
                                      else {
                                        var result = await context
                                            .read<TodoService>()
                                            .createTodo(todo);

                                        if (result == 'OK') {
                                          showSnackBar(context,
                                              'New todo successfully added');
                                          todoController.text = '';
                                        } else
                                          showSnackBar(context, result);

                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Selector<UserService, User>(
                  selector: (context, value) => value.currentUser,
                  builder: (context, value, child) => Text(
                    '${value.name}\`s Todo list',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 20,
                  ),
                  child: Consumer<TodoService>(
                    builder: (context, value, child) => ListView.builder(
                      itemCount: value.todos.length,
                      itemBuilder: (context, index) =>
                          TodoCard(todo: value.todos[index]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
