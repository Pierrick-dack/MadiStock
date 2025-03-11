/*
class Category {
  final int? id;
  final String name;

  Category({this.id, required this.name});

  // Convertir un Category en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  // Convertir un Map en Category
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(id: map['id'], name: map['name']);
  }
}

 */

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  // Convertit une Map (SQLite) en objet Category
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
    );
  }

  // Convertit un objet Category en Map (pour SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
