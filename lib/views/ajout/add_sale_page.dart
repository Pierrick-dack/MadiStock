import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:madistock/api/database_helper.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:madistock/models/category_model.dart';
import 'package:madistock/widgets/dropdown_button.dart';
import 'package:madistock/widgets/text_input_field.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class AddSalesPage extends StatefulWidget {
  const AddSalesPage({super.key});

  @override
  _AddSalesPageState createState() => _AddSalesPageState();
}

class _AddSalesPageState extends State<AddSalesPage> {
  final _formKey = GlobalKey<FormState>();

  // Variables d'état
  String? _selectedCategory;
  String? _selectedProduct;
  String? _selectedPaymentMethod;

  // Données réelles
  List<Category> _categories = [];
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _paymentMethods = [];

  // Date du jour
  final String _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData(); // Charger les données au démarrage
  }

  // Charger les données depuis la base de données
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

  void _resetForm() {
    _quantityController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedProduct = null;
      _selectedPaymentMethod = null;
    });
  }

  // Mettre à jour le stock après une vente
  Future<void> _updateStock(int productId, int quantitySold) async {
    final dbHelper = DatabaseHelper();
    final product = await dbHelper.getProductById(productId);

    if (product != null) {
      int currentStock = product['quantity'];
      int newStock = currentStock - quantitySold;

      if (newStock < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Stock insuffisant !"),
            backgroundColor: redColor,
          ),
        );
        return;
      }

      await dbHelper.updateProduct({
        'id': productId,
        'name': product['name'],
        'description': product['description'],
        'quantity': newStock,
        'factory_price': product['factory_price'],
        'selling_price': product['selling_price'],
        'profit': product['profit'],
        'category_id': product['category_id'],
      });
      _loadData(); // Recharger les produits pour mise à jour du stock
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredProducts = _selectedCategory != null
        ? _products.where((product) => product['category_id'].toString() == _selectedCategory).toList()
        : [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: whiteColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'Enregistrer une vente',
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
              SizedBox(height: 2.h),
              Center(
                child: Text(
                  "Veuillez renseigner les informations sur la vente",
                  style: TextStyle(fontSize: 16.dp),
                ),
              ),
              SizedBox(height: 2.h),

              // Sélection de la catégorie
              Text(
                "Catégorie",
                style: TextStyle(
                  fontSize: 15.dp,
                  fontWeight: FontWeight.bold,
                ),
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
                style: TextStyle(
                  fontSize: 15.dp,
                  fontWeight: FontWeight.bold,
                ),
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
                style: TextStyle(
                  fontSize: 15.dp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                      final int stock = filteredProducts
                          .firstWhere((product) => product['id'].toString() == _selectedProduct)['quantity'];

                      if (quantity > stock) {
                        return "La quantité ne peut pas dépasser le stock disponible ($stock)";
                      }

                      return null;
                    },
                  ),
                ],
              ),

              // Affichage de la quantité restante
              _selectedProduct != null
                  ? Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Text(
                  "Stock restant: ${filteredProducts.isNotEmpty ? filteredProducts.firstWhere((product) => product['id'].toString() == _selectedProduct)['quantity'] : 0}",
                  style: TextStyle(fontSize: 14.dp, color: greyColor),
                ),
              )
                  : Container(),
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
                items: _paymentMethods.map((method) => DropdownMenuItem<String>(
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

              // Bouton de soumission
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    EasyLoading.show(status: 'Enregistrement en cours...');

                    final dbHelper = DatabaseHelper();
                    final int productId = int.parse(_selectedProduct!);
                    final int quantitySold = int.parse(_quantityController.text);

                    await dbHelper.insertSale({
                      'product_id': productId,
                      'quantity': quantitySold,
                      'sale_date': _currentDate,
                      'payment_method': _selectedPaymentMethod!,
                    });

                    await _updateStock(productId, quantitySold);
                    _resetForm();

                    EasyLoading.dismiss();

                    // Afficher un message de succès
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Vente enregistrée avec succès !"),
                        backgroundColor: greenColor,
                      ),
                    );

                    // Rediriger vers la page de liste des ventes après 2 secondes
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ccaColor,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Text(
                  'Enregistrer la vente',
                  style: TextStyle(color: whiteColor, fontSize: 16.dp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}