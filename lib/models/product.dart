
class ProductModel{
  String? id, name, img, desc, cateId;
  double? price;

  ProductModel({this.id, this.name, this.desc, this.img, this.price, this.cateId});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'img': img,
      'price': '$price',
      'cateId': cateId,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> data) => ProductModel(
    id: data['id'],
    name: data['name'],
    desc: data['desc'],
    img: data['img'],
    price: double.parse(data['price']),
    cateId: data['cateId'],
  );
}