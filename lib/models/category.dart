class CategoryModel{
  String? id;
  String? name, desc;

  CategoryModel({this.id, this.name, this.desc});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> data) => CategoryModel(
    id: data['id'],
    name: data['name'],
    desc: data['desc'],
  );
}