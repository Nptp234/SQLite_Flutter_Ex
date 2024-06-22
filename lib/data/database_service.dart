import 'package:bt_tuan6/models/category.dart';
import 'package:bt_tuan6/models/product.dart';
import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseServiceCategory{
  //singleton
  static final DatabaseServiceCategory _databaseService = DatabaseServiceCategory._internal();
  factory DatabaseServiceCategory() => _databaseService;
  DatabaseServiceCategory._internal();
  //

  //the database must be initialized before creating any tables or performing read/write operations
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  //we check if the database is present, if not, we create it using initDatabase() function
  Future<Database> initDatabase() async {
    final getDirectory = await getApplicationDocumentsDirectory();
    String path = '${getDirectory.path}/db_product.db';
    log(path);
    return await openDatabase(path, onCreate: _onCreate, version: 2);
  }

  //creates the database using  _onCreate() function
  void _onCreate(Database db, int version) async {
    await db.execute(
    'CREATE TABLE Category(id TEXT PRIMARY KEY, name TEXT, desc TEXT)');
    log('TABLE CREATED');
  }
  //

  //get list
  Future<List<CategoryModel>> getCategoyList() async {
    final db = await _databaseService.database;
    var data = await db.rawQuery('SELECT * FROM Category');
    List<CategoryModel> category =
      List.generate(data.length, (index) => CategoryModel.fromJson(data[index]));
    print(category.length);
    return category;
  }

  //insert
  Future<void> insertCategory(CategoryModel? category) async {
    final db = await _databaseService.database;
    var data = await db.rawInsert(
        'INSERT INTO Category(id, name, desc) VALUES(?,?,?)',
        [category!.id, category.name, category.desc]);
    log('inserted $data');
  }

  //edit
  Future<void> editCategory(CategoryModel category) async {
    final db = await _databaseService.database;
    var data = await db.rawUpdate(
        'UPDATE Category SET name=?,desc=? WHERE ID=?',
        [category.name, category.desc, category.id]);
    log('updated $data');
  }

  //delete
  Future<void> deleteCategory(String id) async {
    final db = await _databaseService.database;
    var data = await db.rawDelete('DELETE from Category WHERE id=?', [id]);
    log('deleted $data');
  }

}

class DatabaseServiceProduct{
  //singleton
  static final DatabaseServiceProduct _databaseService = DatabaseServiceProduct._internal();
  factory DatabaseServiceProduct() => _databaseService;
  DatabaseServiceProduct._internal();
  //

  //the database must be initialized before creating any tables or performing read/write operations
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  //we check if the database is present, if not, we create it using initDatabase() function
  Future<Database> initDatabase() async {
    final getDirectory = await getApplicationDocumentsDirectory();
    String path = '${getDirectory.path}/db_product2.db';
    log(path);
    return await openDatabase(path, onCreate: _onCreate, version: 2);
  }

  //creates the database using  _onCreate() function
  void _onCreate(Database db, int version) async {
    await db.execute(
    'CREATE TABLE Product(id TEXT PRIMARY KEY, name TEXT, desc TEXT, img TEXT, price TEXT, cateId TEXT)');
    log('TABLE CREATED');
  }
  //

  //get list
  Future<List<ProductModel>> getProductList() async {
    final db = await _databaseService.database;
    var data = await db.rawQuery('SELECT * FROM Product');
    List<ProductModel> product =
      List.generate(data.length, (index) => ProductModel.fromJson(data[index]));
    print(product.length);
    return product;
  }

  //get list by cateId
  Future<List<ProductModel>> getProductListByCateId(String cateId) async {
    final db = await _databaseService.database;
    var data = await db.rawQuery('SELECT * FROM Product WHERE cateId=?',[cateId]);
    List<ProductModel> product =
      List.generate(data.length, (index) => ProductModel.fromJson(data[index]));
    print(product.length);
    return product;
  }

  //insert
  Future<void> insertProduct(ProductModel? product) async {
    final db = await _databaseService.database;
    var data = await db.rawInsert(
        'INSERT INTO Product(id, name, desc, img, price, cateId) VALUES(?,?,?,?,?,?)',
        [product!.id, product.name, product.desc, product.img, '${product.price}', product.cateId]);
    log('inserted $data');
  }

  //edit
  Future<void> editProduct(ProductModel product) async {
    final db = await _databaseService.database;
    var data = await db.rawUpdate(
        'UPDATE Product SET name=?,desc=?,img=?,price=?,cateId=? WHERE ID=?',
        [product.name, product.desc, product.img, '${product.price}', product.cateId, product.id]);
    log('updated $data');
  }

  //delete
  Future<void> deleteProduct(String id) async {
    final db = await _databaseService.database;
    var data = await db.rawDelete('DELETE from Product WHERE id=?', [id]);
    log('deleted $data');
  }

}