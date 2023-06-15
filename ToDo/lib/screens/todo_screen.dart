import 'package:todo/models/todo.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/services/category_service.dart';
import 'package:todo/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var todoTitleController = TextEditingController();
  var todoDescriptionController = TextEditingController();
  var todoDateController = TextEditingController();

  var _selectedValue;
  var _categories = <DropdownMenuItem<String>>[];

  @override
  void initState() {
    super.initState();
    _loadCotegories();
  }

  _loadCotegories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategory();
    categories.forEach((cate) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(cate["name"]),
          value: cate["name"],
        ));
      });
    });
  }

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        todoDateController.text = DateFormat("dd-MM-yyyy").format(_dateTime);
      });
    }
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: todoTitleController,
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "Write Todo Title",
              ),
            ),
            TextField(
              controller: todoDescriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                hintText: "Write Todo Description",
              ),
            ),
            TextField(
              controller: todoDateController,
              decoration: InputDecoration(
                labelText: "Date",
                hintText: "Pick Todo Date",
                prefixIcon: InkWell(
                  onTap: () {
                    _selectedTodoDate(context);
                  },
                  child: Icon(Icons.calendar_today),
                ),
              ),
            ),
            DropdownButtonFormField(
              value: _selectedValue,
              hint: Text("Category"),
              items: _categories,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () async {
                var todoObject = Todo();
                todoObject.title = todoTitleController.text;
                todoObject.description = todoDescriptionController.text;
                todoObject.todoDate = todoDateController.text;
                todoObject.category = _selectedValue.toString();
                todoObject.isFinished = 0;

                var _todoService = TodoService();
                var result = await _todoService.saveTodo(todoObject);
                if (result > 0) {
                  print(result);
                  _showSuccessSnackBar(Text("Saved"));
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const HomeScreen()));
                }
              },
              color: Colors.blue,
              child: Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
