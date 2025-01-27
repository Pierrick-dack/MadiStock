import 'package:flutter/material.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:madistock/widgets/dropdown_button.dart';
import 'package:madistock/widgets/text_input_field.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs de texte
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _factoryPriceController = TextEditingController();

  // Variable d'état pour la catégorie
  String? _selectedCategory;

  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    _sellingPriceController.clear();
    _factoryPriceController.clear();
    setState(() {
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: whiteColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ajouter un produit',
              style: TextStyle(color: whiteColor),
            ),
            CircleAvatar(
              backgroundColor: whiteColor,
              radius: 20,
              child: ClipOval(
                child: Image.asset(
                  'assets/logo.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: ccaColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Center(
                  child: Text(
                      "Veuillez renseigner les informations sur le produit que vous souhaitez ajouter",
                    style: TextStyle(fontSize: 17),
                  ),
              ),
              const SizedBox(height: 16,),

              // Champ : Nom du produit
              InputField(
                onTap: () {},
                onChange: () {},
                focus: true,
                prefixIcon: Icons.sell_rounded,
                hint: "Nom de l'article",
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l\'article';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ : Description
              InputField(
                onTap: () {},
                onChange: () {},
                focus: true,
                prefixIcon: Icons.description_rounded,
                hint: "Description",
                controller: _descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ : Quantité en stock
              InputField(
                onTap: () {},
                onChange: () {},
                focus: true,
                prefixIcon: Icons.numbers_rounded,
                hint: "Quantité à stocker",
                controller: _quantityController,
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
              const SizedBox(height: 16),

              // Champ : Prix d'usine
              InputField(
                onTap: () {},
                onChange: () {},
                focus: true,
                prefixIcon: Icons.money_rounded,
                hint: "Prix d\'usine",
                controller: _factoryPriceController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le prix d\'usine';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Veuillez entrer un prix valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ : Prix de vente
              InputField(
                onTap: () {},
                onChange: () {},
                focus: true,
                prefixIcon: Icons.money_rounded,
                hint: "Prix de vente",
                controller: _sellingPriceController,
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
              const SizedBox(height: 16),

              // Champ : Catégorie (Dropdown)
              DropdownField<String>(
                focus: true,
                hint: "Choisir une catégorie",
                prefixIcon: Icons.category_rounded,
                items: const [
                  DropdownMenuItem(
                    value: "",
                    child: Text("Choisir une catégorie"),
                  ),
                  DropdownMenuItem(
                    value: "Option 1",
                    child: Text("Option 1"),
                  ),
                  DropdownMenuItem(
                    value: "Option 2",
                    child: Text("Option 2"),
                  ),
                  DropdownMenuItem(
                    value: "Option 3",
                    child: Text("Option 3"),
                  ),
                ],
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez sélectionner une catégorie";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 60),

              // Bouton : Soumettre
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Afficher les données dans la console
                    final newProduct = {
                      'name': _nameController.text,
                      'description': _descriptionController.text,
                      'quantity': int.parse(_quantityController.text),
                      'factoryPrice': int.parse(_factoryPriceController.text),
                      'sellingPrice': int.parse(_sellingPriceController.text),
                      'category': _selectedCategory,
                    };

                     print("Produit ajouté : $newProduct");

                    // Affiche un message de succès
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Produit ajouté avec succès !'),
                      ),
                    );
                    _resetForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: whiteColor,
                  backgroundColor: ccaColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200),
                  ),
                ),
                child: const Text('Ajouter'),
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
    _sellingPriceController.dispose();
    _factoryPriceController.dispose();
    super.dispose();
  }
}
