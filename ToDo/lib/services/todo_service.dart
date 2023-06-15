import 'package:todo/repositories/repository.dart';

import '../models/todo.dart';

class TodoService {
  Repository? _repository;

  TodoService() {
    _repository = Repository();
  }

  saveTodo(Todo todo) async {
    return await _repository?.insertData("todos", todo.todoMap());
  }

  readTodos() async {
    return await _repository?.readData("todos");
  }

  //readTodoById(todoId) async {
  //  return await _repository?.readDataById("todos", todoId);
  //}

  //updateTodo(Todo todo) async {
  //  return await _repository?.updateData("todos", todo.todoMap());
  //}

  deleteTodo(todoId) async {
    return await _repository?.deleteData("todos", todoId);
  }

  readTodosByCategory(category) async {
    return await _repository?.readDataByColumnName(
        "todos", "category", category);
  }
}
