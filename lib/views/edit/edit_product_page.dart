import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:madistock/api/database_helper.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:madistock/models/category_model.dart';
import 'package:madistock/widgets/dropdown_button.dart';
import 'package:madistock/widgets/image_picker.dart';
import 'package:madistock/widgets/text_input_field.dart';
import 'package:madistock/widgets/confirmation_dialog.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductPage({super.key, required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _factoryPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();

  String? _selectedCategory;
  List<Category> _categories = [];
  String? _imagePath;
  bool _isFormDirty = false; // Variable pour suivre les modifications

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _initializeForm();

    // Écouter les changements dans les contrôleurs
    _nameController.addListener(_markFormAsDirty);
    _descriptionController.addListener(_markFormAsDirty);
    _quantityController.addListener(_markFormAsDirty);
    _factoryPriceController.addListener(_markFormAsDirty);
    _sellingPriceController.addListener(_markFormAsDirty);
  }

  @override
  void dispose() {
    // Nettoyer les écouteurs
    _nameController.removeListener(_markFormAsDirty);
    _descriptionController.removeListener(_markFormAsDirty);
    _quantityController.removeListener(_markFormAsDirty);
    _factoryPriceController.removeListener(_markFormAsDirty);
    _sellingPriceController.removeListener(_markFormAsDirty);
    super.dispose();
  }

  void _markFormAsDirty() {
    if (!_isFormDirty) {
      setState(() {
        _isFormDirty = true; // Marquer le formulaire comme modifié
      });
    }
  }

  void _initializeForm() {
    _nameController.text = widget.product['name'];
    _descriptionController.text = widget.product['description'];
    _quantityController.text = widget.product['quantity'].toString();
    _factoryPriceController.text = widget.product['factory_price'].toString();
    _sellingPriceController.text = widget.product['selling_price'].toString();
    _imagePath = widget.product['image_path'];
  }

  Future<void> _loadCategories() async {
    final categoriesData = await DatabaseHelper().getCategories();
    setState(() {
      _categories = categoriesData.map((category) => Category.fromMap(category)).toList();
      _selectedCategory = widget.product['category_id'].toString();
    });
  }

  Future<bool> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    try {
      final updatedProduct = {
        'id': widget.product['id'],
        'name': _nameController.text,
        'description': _descriptionController.text,
        'quantity': int.parse(_quantityController.text),
        'factory_price': int.parse(_factoryPriceController.text),
        'selling_price': int.parse(_sellingPriceController.text),
        'profit': int.parse(_sellingPriceController.text) - int.parse(_factoryPriceController.text),
        'category_id': int.parse(_selectedCategory!),
        'image_path': _imagePath,
      };

      await DatabaseHelper().updateProduct(updatedProduct);
      return true; // Succès
    } catch (e) {
      return false; // Échec
    }
  }

  Future<void> _confirmAndSubmit() async {
    final bool confirm = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Confirmer la modification',
        message: 'Êtes-vous sûr de vouloir enregistrer les modifications ?',
        confirmText: 'Oui',
        cancelText: 'Non',
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    );

    if (confirm == true) {
      final bool success = await _handleSubmit();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produit modifié avec succès !'),
            backgroundColor: greenColor,
          ),
        );
        setState(() {
          _isFormDirty = false; // Réinitialiser l'état des modifications
        });
        Navigator.pop(context, true); // Retourner à la page précédente
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Échec de la modification du produit.'),
            backgroundColor: redColor,
          ),
        );
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (_isFormDirty) {
      final bool confirm = await showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          title: 'Modifications non enregistrées',
          message: 'Voulez-vous vraiment quitter sans enregistrer les modifications ?',
          confirmText: 'Quitter',
          cancelText: 'Annuler',
          onConfirm: () => Navigator.of(context).pop(true),
        ),
      );
      return confirm ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;

        final bool canPop = await _onWillPop();
        if (canPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Modifier le produit', style: TextStyle(color: whiteColor)),
          backgroundColor: ccaColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: whiteColor),
            onPressed: () async {
              final bool canPop = await _onWillPop();
              if (canPop) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(4.w),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildSectionTitle("Modifier l'image du produit"),
                Center(
                  child: ImagePickerWidget(
                    initialImagePath: _imagePath,
                    onImageSelected: (imagePath) => setState(() => _imagePath = imagePath),
                  ),
                ),
                SizedBox(height: 2.h),
                _buildSectionTitle("Catégorie"),
                DropdownField<String>(
                  focus: true,
                  hint: "Choisir une catégorie",
                  prefixIcon: Icons.category_rounded,
                  items: _categories.map((category) => DropdownMenuItem(
                    value: category.id.toString(),
                    child: Text(category.name),
                  )).toList(),
                  value: _selectedCategory,
                  onChanged: (value) => setState(() => _selectedCategory = value),
                  validator: (value) => value == null || value.isEmpty ? "Veuillez sélectionner une catégorie" : null,
                ),
                SizedBox(height: 2.h),
                _buildSectionTitle("Nom de l'article"),
                _buildInputField(_nameController, "Nom de l'article", Icons.sell_rounded),
                _buildSectionTitle("Description de l'article"),
                _buildInputField(_descriptionController, "Description", Icons.description_rounded),
                _buildSectionTitle("Quantité en stock"),
                _buildInputField(_quantityController, "Quantité en stock", Icons.numbers_rounded, isNumber: true),
                _buildSectionTitle("Prix d'usine"),
                _buildInputField(_factoryPriceController, "Prix d'usine", Icons.money_rounded, isNumber: true),
                _buildSectionTitle("Prix de vente"),
                _buildInputField(_sellingPriceController, "Prix de vente", Icons.money_rounded, isNumber: true),
                SizedBox(height: 3.h),
                ElevatedButton(
                  onPressed: _confirmAndSubmit,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: whiteColor,
                    backgroundColor: ccaColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
                    padding: EdgeInsets.symmetric(vertical: 1.8.h),
                  ),
                  child: Text('Enregistrer les modifications', style: TextStyle(fontSize: 16.dp)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(title, style: TextStyle(fontSize: 15.dp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint, IconData icon, {bool isNumber = false}) {
    return InputField(
      onTap: () {},
      onChange: (value) {},
      focus: true,
      prefixIcon: icon,
      hint: hint,
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer $hint';
        }
        if (isNumber && (double.tryParse(value) == null || double.parse(value) < 0)) {
          return 'Veuillez entrer un nombre valide';
        }
        return null;
      },
    );
  }
}