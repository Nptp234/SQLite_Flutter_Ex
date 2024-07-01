import 'package:bt_tuan6/models/category.dart';
import 'package:bt_tuan6/models/product.dart';
import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService{
  //singleton
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();
  //

  //the database must be initialized before creating any tables or performing read/write operations
  static Database? _database;
  Future<Database> get database async {
    if (_database != null){
      return _database!;
    }

    await initDatabase();
    return _database!;
  }

  //we check if the database is present, if not, we create it using initDatabase() function
  Future<void> initDatabase() async {
    try {
      final getDirectory = await getApplicationDocumentsDirectory();
      String path = join(getDirectory.path, 'db_product.db');
      
      
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onOpen: (db) {
          log('Database opened');
        },
      );
      log('Database initialized');
      // return _database!;
    } catch (e) {
      log('Error initializing database: $e');
      rethrow;
    }
  }

  //creates the database using  _onCreate() function
  void _onCreate(Database db, int version) async {
    try {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS Category (id TEXT PRIMARY KEY, name TEXT, desc TEXT);',
      );
      log('TABLE CREATED: CATEGORY');
      await db.execute(
        'CREATE TABLE IF NOT EXISTS Product (id TEXT PRIMARY KEY, name TEXT, desc TEXT, img TEXT, price TEXT, cateId TEXT);',
      );
      log('TABLE CREATED: PRODUCT');
    } catch (e) {
      log('Error creating tables: $e');
      rethrow;
    }
  }

  void _onUpgrade(Database db, int version, String path) async{
    await deleteDatabase(path);
    _onCreate(db, version);
  }
  //

}

class DatabaseServiceCategory{
  
  final DatabaseService _databaseService = DatabaseService();

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
  
  final DatabaseService _databaseService = DatabaseService();

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