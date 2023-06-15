import 'package:todo/models/category.dart';
import 'package:todo/repositories/repository.dart';

class CategoryService {
  Repository? _repository;

  CategoryService() {
    _repository = Repository();
  }

  saveCategory(Category category) async {
    return await _repository?.insertData("categories", category.categotyMap());
  }

  readCategory() async {
    return await _repository?.readData("categories");
  }

  readCategoryById(categotyId) async {
    return await _repository?.readDataById("categories", categotyId);
  }

  updateCategory(Category category) async {
    return await _repository?.updateData("categories", category.categotyMap());
  }

  deleteCategory(categoryId) async {
    return await _repository?.deleteData("categories", categoryId);
  }
}
