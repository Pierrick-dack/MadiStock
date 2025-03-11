class Product {
  final int? id;
  final String name;
  final String description;
  final int quantity;
  final double factoryPrice;
  final double sellingPrice;
  final double profit;
  final int categoryId;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.factoryPrice,
    required this.sellingPrice,
    required this.profit,
    required this.categoryId,
  });

  // Convertir un Product en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'factory_price': factoryPrice,
      'selling_price': sellingPrice,
      'profit': profit,
      'category_id': categoryId,
    };
  }

  // Convertir un Map en Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      quantity: map['quantity'],
      factoryPrice: map['factory_price'],
      sellingPrice: map['selling_price'],
      profit: map['profit'],
      categoryId: map['category_id'],
    );
  }
}