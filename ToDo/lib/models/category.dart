class Category {
  int? id;
  String? name;
  String? description;

  categotyMap() {
    var mapping = Map<String, dynamic>();
    mapping["id"] = id;
    mapping["name"] = name;
    mapping["description"] = description;

    return mapping;
  }
}
