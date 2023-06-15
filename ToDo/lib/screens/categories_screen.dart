import 'package:todo/helpers/drawer_navigation.dart';
import 'package:todo/models/category.dart';
import 'package:todo/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  var _categoryUpdate = Category();
  var _categoryAdd = Category();
  var _categoryService = CategoryService();

  var category;

  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();

  List<Category> _categoryList = <Category>[];

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  //final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = <Category>[];
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category["name"];
        categoryModel.description = category["description"];
        categoryModel.id = category["id"];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categotyId) async {
    category = await _categoryService.readCategoryById(categotyId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'no name';
      _editCategoryDescriptionController.text =
          category[0]['description'] ?? 'no description';
    });
    _editFormDialog(context);
  }

  _addFormDialog(BuildContext context) {
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
                    _categoryAdd.name = _categoryNameController.text;
                    _categoryAdd.description =
                        _categoryDescriptionController.text;
                    var result =
                        await _categoryService.saveCategory(_categoryAdd);
                    if (result > 0) {
                      _categoryNameController.clear();
                      _categoryDescriptionController.clear();
                      Navigator.pop(context);
                      print(result);
                      getAllCategories();
                      _showSuccessSnackBar(Text("Saved"));
                    }
                  },
                  child: Text("Save",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
            ],
            title: Text("Categori Form"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                        hintText: "Write A Category", labelText: "Category"),
                  ),
                  TextField(
                    controller: _categoryDescriptionController,
                    decoration: InputDecoration(
                        hintText: "Write A description",
                        labelText: "Description"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _editFormDialog(BuildContext context) {
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
                    _categoryUpdate.id = category[0]['id'];
                    _categoryUpdate.name = _editCategoryNameController.text;
                    _categoryUpdate.description =
                        _editCategoryDescriptionController.text;
                    var result =
                        await _categoryService.updateCategory(_categoryUpdate);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllCategories();
                      _showSuccessSnackBar(Text("Updated"));
                    }
                    print(result);
                  },
                  child: Text("Update",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black))),
            ],
            title: Text("Edit Category Form"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _editCategoryNameController,
                    decoration: InputDecoration(
                        hintText: "Write A Category", labelText: "Category"),
                  ),
                  TextField(
                    controller: _editCategoryDescriptionController,
                    decoration: InputDecoration(
                        hintText: "Write A description",
                        labelText: "Description"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, categoryId) {
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
                    var result =
                        await _categoryService.deleteCategory(categoryId);
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllCategories();
                      _showSuccessSnackBar(Text("Deleted"));
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

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _globalKey,
      appBar: AppBar(
        title: Text("Categories"),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Card(
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editCategory(context, _categoryList[index].id);
                  },
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_categoryList[index].name.toString()),
                    IconButton(
                      onPressed: () {
                        _deleteFormDialog(context, _categoryList[index].id);
                      },
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    )
                  ],
                ),
                subtitle: Text(_categoryList[index].description.toString()),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
