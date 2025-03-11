class Sale {
  final int? id;
  final int productId;
  final int quantity;
  final String saleDate;
  final String paymentMethod;

  Sale({
    this.id,
    required this.productId,
    required this.quantity,
    required this.saleDate,
    required this.paymentMethod,
  });

  // Convertir un Sale en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'sale_date': saleDate,
      'payment_method': paymentMethod,
    };
  }

  // Convertir un Map en Sale
  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      saleDate: map['sale_date'],
      paymentMethod: map['payment_method'],
    );
  }
}