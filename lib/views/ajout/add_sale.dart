import 'package:flutter/material.dart';

class AddSellsPage extends StatefulWidget {
  @override
  _AddSellsPageState createState() => _AddSellsPageState();
}

class _AddSellsPageState extends State<AddSellsPage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs de texte
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Produit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Champ : Nom de l'article
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom de l\'article',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l\'article';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Champ : Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Champ : Quantité en stock
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantité en stock',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la quantité';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return 'Veuillez entrer une quantité valide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Champ : Prix unitaire
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Prix unitaire',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le prix unitaire';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Veuillez entrer un prix valide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Champ : Catégorie
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la catégorie';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Bouton : Soumettre
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Action à effectuer lors de la soumission
                    final newProduct = {
                      'name': _nameController.text,
                      'description': _descriptionController.text,
                      'quantity': int.parse(_quantityController.text),
                      'price': double.parse(_priceController.text),
                      'category': _categoryController.text,
                    };

                    // Affiche un message de succès
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Produit ajouté avec succès !'),
                      ),
                    );

                    // Réinitialiser le formulaire
                    _formKey.currentState!.reset();
                  }
                },
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Libère les ressources utilisées par les contrôleurs
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
}
