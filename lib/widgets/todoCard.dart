import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_sql/models/todo.dart';
import 'package:flutter_todo_sql/services/todo_service.dart';
import 'package:flutter_todo_sql/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade300,
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (context) async {
                var result = await context.read<TodoService>().deleteTodo(todo);

                if (result == 'OK')
                  showSnackBar(context, 'Successfully deleted');
                else
                  showSnackBar(context, result);
              },
              backgroundColor: Colors.purple.shade600,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: CheckboxListTile(
          checkColor: Colors.purple,
          activeColor: Colors.purple[100],
          value: todo.done,
          onChanged: (value) async {
            var result = await context.read<TodoService>().toggleTodoDone(todo);

            if (result != 'OK') showSnackBar(context, result);
          },
          subtitle: Text(
            '${todo.created.day}/${todo.created.month}/${todo.created.year}',
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              color: Colors.white,
              decoration:
                  todo.done ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
