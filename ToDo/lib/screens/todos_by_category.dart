import 'package:todo/services/todo_service.dart';
import 'package:flutter/material.dart';

import '../models/todo.dart';

class TodosByCategory extends StatefulWidget {
  //const TodosByCategory({Key? key}) : super(key: key);

  final String category;
  TodosByCategory({required this.category});

  @override
  _TodosByCategoryState createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  List<Todo> _todoList = <Todo>[];
  TodoService _todoService = TodoService();

  @override
  void initState() {
    super.initState();
    getTodosByCategories();
  }

  getTodosByCategories() async {
    var todos = await _todoService.readTodosByCategory(this.widget.category);
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo["id"];
        model.title = todo["title"];
        model.description = todo["description"];
        model.todoDate = todo["todoDate"];

        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.category),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _todoList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 8,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_todoList[index].title.toString()),
                          ],
                        ),
                        subtitle: Text(_todoList[index].description.toString()),
                        trailing: Text(_todoList[index].todoDate.toString()),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
