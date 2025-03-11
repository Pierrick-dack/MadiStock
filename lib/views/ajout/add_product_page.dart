import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:madistock/api/database_helper.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:madistock/widgets/dropdown_button.dart';
import 'package:madistock/widgets/image_picker.dart';
import 'package:madistock/widgets/text_input_field.dart';
import 'package:madistock/models/category_model.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _factoryPriceController = TextEditingController();

  String? _selectedCategory;
  List<Category> _categories = [];
  String? _imagePath;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categoriesData = await DatabaseHelper().getCategories();
    setState(() {
      _categories = categoriesData.map((category) => Category.fromMap(category)).toList();
    });
  }

  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    _sellingPriceController.clear();
    _factoryPriceController.clear();
    setState(() {
      _selectedCategory = null;
      _imagePath = null;
    });
  }

  Future<void> _handleSubmit() async {
    if (_isLoading) return;
    _isLoading = true;
    EasyLoading.show(status: 'Chargement...');

    try {
      if (!_formKey.currentState!.validate()) {
        EasyLoading.showError('Veuillez remplir tous les champs correctement !');
        return;
      }

      final factoryPrice = int.parse(_factoryPriceController.text.replaceAll(' ', ''));
      final sellingPrice = int.parse(_sellingPriceController.text.replaceAll(' ', ''));
      final profit = sellingPrice - factoryPrice;
      final quantity = int.parse(_quantityController.text.replaceAll(' ', ''));
      final initialProfit = profit * quantity;

      if (_imagePath == null || _selectedCategory == null) {
        EasyLoading.showError('Veuillez sélectionner une image et une catégorie.');
        return;
      }

      await DatabaseHelper().insertProduct({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'quantity': quantity,
        'initial_quantity': quantity,
        'factory_price': factoryPrice,
        'selling_price': sellingPrice,
        'profit': profit,
        'category_id': int.parse(_selectedCategory!),
        'image_path': _imagePath,
        'initial_profit': initialProfit,
      });

      EasyLoading.showSuccess('Produit ajouté avec succès !');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produit ajouté avec succès !'),
          backgroundColor: greenColor,
        ),
      );

      _resetForm();
    } catch (e) {
      print('Erreur : $e');
      EasyLoading.showError('Erreur lors de l\'ajout. Réessayez.');
    } finally {
      _isLoading = false;
    }
  }


  String _formatCurrency(String value) {
    var cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanedValue.length > 6) {
      cleanedValue = cleanedValue.substring(0, 6);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Limite atteinte !"),
          backgroundColor: redColor,
        ),
      );
    }

    final formattedValue = _formatWithSpaces(cleanedValue);
    return formattedValue;
  }

  String _formatWithSpaces(String value) {
    if (value.length <= 3) {
      return value;
    }

    final buffer = StringBuffer();
    int count = 0;
    for (int i = value.length - 1; i >= 0; i--) {
      buffer.write(value[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write(' ');
      }
    }

    return buffer.toString().split('').reversed.join('');
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Ajouter un produit',
          textAlign:TextAlign.center,
          style: TextStyle(color: whiteColor, fontSize: 20.dp),
        ),
        backgroundColor: ccaColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(child: _buildSectionTitle("Ajouter une image du produit")),
              Center(
                child: ImagePickerWidget(
                  onImageSelected: (imagePath) => setState(() => _imagePath = imagePath),
                ),
              ),
              SizedBox(height: 2.h),
              _buildSectionTitle("Choisissez la catégorie"),
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
              _buildInputField(
                _nameController,
                "Nom de l'article",
                Icons.sell_rounded,
              ),
              _buildSectionTitle("Description de l'article"),
              _buildInputField(
                _descriptionController,
                "Description", Icons.description_rounded,
              ),
              _buildSectionTitle("Quantité à stocker"),
              _buildInputField(
                _quantityController,
                "Quantité à stocker",
                Icons.numbers_rounded,
                isNumber: true,
              ),
              _buildSectionTitle("Prix de l'usine"),
              _buildInputField(
                _factoryPriceController,
                "Prix d'usine",
                Icons.money_rounded,
                isNumber: true,
              ),
              _buildSectionTitle("Prix de vente"),
              _buildInputField(
                _sellingPriceController,
                "Prix de vente",
                Icons.money_rounded,
                isNumber: true,
              ),
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  foregroundColor: whiteColor,
                  backgroundColor: ccaColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                ),
                child: _isLoading
                    ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(
                    color: whiteColor,
                    strokeWidth: 2,
                  ),
                )
                    : Text('Ajouter', style: TextStyle(fontSize: 16.dp)),
              ),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(
        title,
        style: TextStyle(fontSize: 15.dp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint, IconData icon, {bool isNumber = false}) {
    return InputField(
      onTap: () {},
      onChange: (value) {
        if (isNumber) {
          controller.value = controller.value.copyWith(
            text: _formatCurrency(value),
            selection: TextSelection.collapsed(offset: _formatCurrency(value).length),
          );
        }
      },
      focus: true,
      prefixIcon: icon,
      hint: hint,
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Veuillez entrer $hint';
        if (isNumber) {
          try {
            int.parse(value.replaceAll(' ', ''));
          } catch (e) {
            return 'Veuillez entrer un nombre valide';
          }
        }
        return null;
      },
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _sellingPriceController.dispose();
    _factoryPriceController.dispose();
    super.dispose();
  }
}