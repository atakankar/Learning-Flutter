import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/screens/todo_screen.dart';
import 'package:todo/services/todo_service.dart';

import '../helpers/drawer_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _todoService = TodoService();

  List<Todo> _todoList = <Todo>[];

  @override
  initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoList.clear();
    var todos = await _todoService.readTodos();
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo["id"];
        model.title = todo["title"];
        model.description = todo["description"];
        model.todoDate = todo["todoDate"];
        model.category = todo["category"];
        model.isFinished = todo["isFinished"];
        _todoList.add(model);
      });
    });
  }

  _deleteFormDialog(BuildContext context, todoId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.all(8),
                    //few more styles
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.all(8),
                    //few more styles
                  ),
                  onPressed: () async {
                    var result = await _todoService.deleteTodo(todoId);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllTodos();
                    }
                    print(result);
                  },
                  child: Text("Delete",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
            ],
            title: Text("Are You Sure You Want To Delete This?"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do"),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_todoList[index].title.toString()),
                  ],
                ),
                subtitle: Text(_todoList[index].category.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_todoList[index].todoDate.toString()),
                    IconButton(
                      onPressed: () {
                        _deleteFormDialog(context, _todoList[index].id);
                      },
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TodoScreen())),
      ),
    );
  }
}
