import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const int _version = 1;

  // Récupérer l'instance de la base de données
  static Future<Database> get database async {
    if (_database != null) return _database!;

    // await _deleteDatabase();
    _database = await _initDatabase();
    return _database!;
  }

  // Supprime la base de données existante
  static Future<void> _deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'madistock.db');
    await deleteDatabase(path);
  }

  // Réinitialisation manuelle de la base de données
  static Future<void> resetDatabase() async {
    // await _deleteDatabase();
    _database = await _initDatabase();
  }

  // Initialisation de la base de données
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'madistock.db');

    return await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
    );
  }

  // Création des tables
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        initial_quantity TEXT NOT NULL,
        factory_price INTEGER NOT NULL,
        selling_price INTEGER NOT NULL,
        profit INTEGER NOT NULL,
        initial_profit INTEGER NOT NULL,
        category_id INTEGER,
        image_path TEXT,
        FOREIGN KEY (category_id) REFERENCES categories(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE payment_methods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        sale_date TEXT NOT NULL,
        payment_method TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products(id)
      );
    ''');

    await _insertPaymentMethods(db);
  }

  // Insertion des modes de paiement
  static Future<void> _insertPaymentMethods(Database db) async {
    final paymentMethods = [
      {"name": "Espèces"},
      {"name": "Orange Money"},
      {"name": "Mobile Money"},
      {"name": "Autres"},
    ];

    for (final method in paymentMethods) {
      await db.insert('payment_methods', method);
    }
  }

  // Méthodes CRUD pour les catégories
  Future<int> insertCategory(Map<String, dynamic> category) async {
    final db = await database;
    return await db.insert('categories', category);
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('categories');
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateCategory(Map<String, dynamic> category) async {
    final db = await database;
    return await db.update(
      'categories',
      category,
      where: 'id = ?',
      whereArgs: [category['id']],
    );
  }

  // Méthodes CRUD pour les produits
  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('products', product);
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('products');
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [product['id']],
    );
  }

  // Récupérer un produit par son ID
  Future<Map<String, dynamic>?> getProductById(int productId) async {
    final db = await database;
    final result = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Méthodes CRUD pour les ventes
  Future<int> insertSale(Map<String, dynamic> sale) async {
    final db = await database;
    return await db.insert('sales', sale);
  }

  Future<int> updateSale(Map<String, dynamic> sale) async {
    final db = await database;
    return await db.update(
      'sales',
      sale,
      where: 'id = ?',
      whereArgs: [sale['id']],
    );
  }

  Future<List<Map<String, dynamic>>> getSalesByCategory() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT 
        categories.name AS category_name,
        sales.id AS sale_id,
        sales.quantity AS sale_quantity,
        sales.sale_date AS sale_date,
        sales.payment_method AS payment_method,
        products.name AS product_name,
        products.selling_price AS product_price
      FROM sales
      INNER JOIN products ON sales.product_id = products.id
      INNER JOIN categories ON products.category_id = categories.id
      ORDER BY categories.name, sales.sale_date DESC;
    ''');
    return result;
  }

  Future<int> deleteSale(int id) async {
    final db = await database;
    return await db.delete('sales', where: 'id = ?', whereArgs: [id]);
  }

  // Méthodes pour les modes de paiement
  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    final db = await database;
    return await db.query('payment_methods');
  }

  Future<List<Map<String, dynamic>>> getMostSoldProducts() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT product, SUM(quantity) as totalQuantity 
      FROM sales 
      GROUP BY product 
      ORDER BY totalQuantity DESC 
      LIMIT 5
    ''');
    return result;
  }

  Future<List<Map<String, dynamic>>> getSellsByCategory() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT categories, SUM(quantity) as totalQuantity 
      FROM sales 
      GROUP BY categories
    ''');
    return result;
  }
}