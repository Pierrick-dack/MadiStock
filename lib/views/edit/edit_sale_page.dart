import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:madistock/api/database_helper.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:madistock/models/category_model.dart';
import 'package:madistock/widgets/dropdown_button.dart';
import 'package:madistock/widgets/text_input_field.dart';

class EditSaleBottomSheet extends StatefulWidget {
  final int saleId;
  final String productName;
  final String categoryName;
  final int quantity;
  final String saleDate;
  final String paymentMethod;
  final Function(Map<String, dynamic>) onSave;
  final Function(int) onProductQuantityUpdated;

  const EditSaleBottomSheet({
    super.key,
    required this.saleId,
    required this.productName,
    required this.categoryName,
    required this.quantity,
    required this.saleDate,
    required this.paymentMethod,
    required this.onSave,
    required this.onProductQuantityUpdated,
  });

  @override
  _EditSaleBottomSheetState createState() => _EditSaleBottomSheetState();
}

class _EditSaleBottomSheetState extends State<EditSaleBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  String? _selectedProduct;
  String? _selectedPaymentMethod;
  final _quantityController = TextEditingController();

  List<Category> _categories = [];
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _paymentMethods = [];

  @override
  void initState() {
    super.initState();
    _quantityController.text = widget.quantity.toString();
    _loadData();
  }

  Future<void> _loadData() async {
    final dbHelper = DatabaseHelper();
    final categoriesData = await dbHelper.getCategories();
    final products = await dbHelper.getProducts();
    final paymentMethods = await dbHelper.getPaymentMethods();

    setState(() {
      _categories = categoriesData.map((category) => Category.fromMap(category)).toList();
      _products = products;
      _paymentMethods = paymentMethods;
    });
  }

  Future<void> _updateProductStock(int productId, int newQuantity) async {
    final dbHelper = DatabaseHelper();
    final product = await dbHelper.getProductById(productId);

    if (product != null) {
      int initialQuantity = int.parse(product['initial_quantity'].toString());
      int updatedQuantity = initialQuantity - newQuantity;

      await dbHelper.updateProduct({
        'id': productId,
        'name': product['name'],
        'description': product['description'],
        'quantity': updatedQuantity,
        'factory_price': product['factory_price'],
        'selling_price': product['selling_price'],
        'profit': product['profit'],
        'category_id': product['category_id'],
        'initial_quantity': initialQuantity,
        'initial_profit': product['initial_profit'],
      });
      widget.onProductQuantityUpdated(updatedQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredProducts = _selectedCategory != null
        ? _products.where((product) => product['category_id'].toString() == _selectedCategory).toList()
        : [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Modifier la vente',
                style: TextStyle(fontSize: 20.dp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 2.h),

            // Sélection de la catégorie
            Text(
              "Catégorie",
              style: TextStyle(fontSize: 15.dp, fontWeight: FontWeight.bold),
            ),
            DropdownField<String>(
              hint: "Choisir une catégorie",
              focus: true,
              prefixIcon: Icons.category_rounded,
              items: _categories.map((category) => DropdownMenuItem(
                value: category.id.toString(),
                child: Text(category.name),
              )).toList(),
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  _selectedProduct = null;
                });
              },
            ),
            SizedBox(height: 2.h),

            // Sélection du produit
            Text(
              "Produit vendu",
              style: TextStyle(fontSize: 15.dp, fontWeight: FontWeight.bold),
            ),
            DropdownField<String>(
              hint: "Choisir un produit",
              prefixIcon: Icons.shopping_cart_rounded,
              focus: true,
              items: filteredProducts.map((product) => DropdownMenuItem(
                value: product['id'].toString(),
                child: Text(product['name']),
              )).toList(),
              value: _selectedProduct,
              onChanged: (value) {
                setState(() {
                  _selectedProduct = value;
                });
              },
            ),
            SizedBox(height: 2.h),

            // Saisie de la quantité
            Text(
              "Quantité vendue",
              style: TextStyle(fontSize: 15.dp, fontWeight: FontWeight.bold),
            ),
            InputField(
              keyboardType: TextInputType.number,
              onTap: () {},
              onChange: (String value) {  },
              focus: true,
              hint: "Entrer la quantité",
              prefixIcon: Icons.production_quantity_limits_rounded,
              controller: _quantityController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Veuillez saisir une quantité";
                }
                final int? quantity = int.tryParse(value);
                if (quantity == null || quantity <= 0) {
                  return "La quantité doit être un nombre positif";
                }

                // Récupérer le produit actuel et son stock
                final int productId = int.parse(_selectedProduct!);
                final product = _products.firstWhere((p) => p['id'] == productId);
                final int stock = product['quantity'];

                // Calculer le stock disponible en tenant compte de la vente initiale
                final int availableStock = stock + widget.quantity;

                if (quantity > availableStock) {
                  return "La quantité ne peut pas dépasser le stock disponible ($availableStock)";
                }

                return null;
              },
            ),
            SizedBox(height: 2.h),

            // Sélection de la méthode de paiement
            Text(
              "Méthode de paiement",
              style: TextStyle(fontSize: 15.dp, fontWeight: FontWeight.bold),
            ),
            DropdownField<String>(
              hint: "Choisir une méthode de paiement",
              focus: true,
              prefixIcon: Icons.payment_rounded,
              items: _paymentMethods.map((method) => DropdownMenuItem(
                value: method['name'] as String,
                child: Text(method['name'] as String),
              )).toList(),
              value: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            SizedBox(height: 3.h),

            // Bouton de sauvegarde
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Afficher un loader
                    EasyLoading.show(status: 'Enregistrement en cours...');

                    final dbHelper = DatabaseHelper();

                    final updatedSale = {
                      'id': widget.saleId,
                      'product_id': int.parse(_selectedProduct!),
                      'quantity': int.parse(_quantityController.text),
                      'sale_date': widget.saleDate,
                      'payment_method': _selectedPaymentMethod!,
                    };

                    // Simuler un délai pour l'enregistrement (optionnel)
                    await Future.delayed(const Duration(seconds: 2));

                    // Mettre à jour la vente dans la base de données
                    await dbHelper.updateSale(updatedSale);

                    // Update product stock
                    await _updateProductStock(
                      int.parse(_selectedProduct!),
                      int.parse(_quantityController.text),
                    );

                    // Cacher le loader
                    EasyLoading.dismiss();

                    // Appeler la fonction onSave pour notifier l'appelant
                    widget.onSave(updatedSale);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ccaColor,
                  padding: EdgeInsets.symmetric(
                    vertical: 1.2.h,
                    horizontal: 8.w,
                  ),
                ),
                child: Text(
                  'Enregistrer les modifications',
                  style: TextStyle(color: whiteColor, fontSize: 16.dp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}