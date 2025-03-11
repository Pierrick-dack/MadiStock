class PaymentMethod {
  final int? id;
  final String name;

  PaymentMethod({
    this.id,
    required this.name,
  });

  // Convertir un Paiement en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Convertir un Map en Paiement
  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'],
      name: map['name'],
    );
  }
}