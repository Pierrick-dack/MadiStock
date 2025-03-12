import 'package:flutter/material.dart';
import 'package:madistock/api/database_helper.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:madistock/constants/app_colors.dart';

class ProductAndQuantityList extends StatefulWidget {
  const ProductAndQuantityList({super.key});

  @override
  _ProductAndQuantityListState createState() => _ProductAndQuantityListState();
}

class _ProductAndQuantityListState extends State<ProductAndQuantityList> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _products = [];
  Map<String, List<Map<String, dynamic>>> _productsByCategory = {};

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _dbHelper.getProducts();
    setState(() {
      _products = products;
      _groupProductsByCategory();
    });
  }

  void _groupProductsByCategory() async {
    final categories = await _dbHelper.getCategories();
    Map<String, List<Map<String, dynamic>>> groupedProducts = {};

    for (var category in categories) {
      groupedProducts[category['name']] = [];
    }

    for (var product in _products) {
      final categoryId = product['category_id'];
      final category = categories.firstWhere((c) => c['id'] == categoryId, orElse: () => {'name': 'Inconnu'});
      groupedProducts[category['name']]!.add(product);
    }

    setState(() {
      _productsByCategory = groupedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ccaColor,
        title: Text(
          'Produits et Quantités',
          style: TextStyle(
            fontSize: 18.dp,
            fontWeight: FontWeight.bold,
            color: whiteColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: whiteColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _productsByCategory.isEmpty
          ? const Center(child: Text('Aucun produit trouvé.'))
          : ListView.builder(
        itemCount: _productsByCategory.length,
        itemBuilder: (context, index) {
          final categoryName = _productsByCategory.keys.toList()[index];
          final productsInCategory = _productsByCategory[categoryName]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0.dp),
                child: Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: 20.dp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productsInCategory.length,
                itemBuilder: (context, productIndex) {
                  final product = productsInCategory[productIndex];
                  return ListTile(
                    title: Text(
                      product['name'],
                      style: TextStyle(fontSize: 16.dp),
                    ),
                    subtitle: Text(
                      'Quantité : ${product['initial_quantity']}',
                      style: TextStyle(fontSize: 14.dp),
                    ),
                    trailing: Text(
                      'Total : ${product['initial_profit']} Fcfa',
                      style: TextStyle(
                        fontSize: 14.dp,
                        color: greenColor,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}