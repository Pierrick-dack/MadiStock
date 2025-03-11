import 'package:flutter/material.dart';
import 'package:madistock/api/database_helper.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:madistock/views/edit/edit_product_page.dart';
import 'package:madistock/widgets/menu/app_drawer.dart';
import 'package:madistock/widgets/menu/appbar_widget.dart';
import 'package:madistock/widgets/products/category_section.dart';
import 'package:madistock/widgets/products/product_details_bottomsheet.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _products = [];
  Map<int, String> _categories = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final products = await _dbHelper.getProducts();
    final categories = await _dbHelper.getCategories();
    final categoryMap = {
      for (var category in categories) category['id'] as int: category['name'] as String
    };

    setState(() {
      _products = products;
      _categories = categoryMap;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupedProducts = _groupProductsByCategory();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: "Liste des produits",
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(3.w),
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: ccaColor))
            : _products.isEmpty
            ? _buildEmptyView()
            : ListView(
          children: groupedProducts.entries.map((entry) {
            return CategorySection(
              categoryName: entry.key,
              products: entry.value,
              onTapProduct: _showProductDetailsBottomSheet,
            );
          }).toList(),
        ),
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupProductsByCategory() {
    final Map<String, List<Map<String, dynamic>>> groupedProducts = {};
    for (var product in _products) {
      final categoryName = _categories[product['category_id']] ?? 'Catégorie inconnue';
      groupedProducts.putIfAbsent(categoryName, () => []).add(product);
    }
    return groupedProducts;
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_rounded,
            size: 20.h,
            color: greyColor,
          ),
          SizedBox(height: 2.h),
          Text(
            'Aucun produit disponible',
            style: TextStyle(
              fontSize: 18.dp,
              fontWeight: FontWeight.bold,
              color: greyColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDetailsBottomSheet(BuildContext context, Map<String, dynamic> product) {
    final int benefit = (product['selling_price'] - product['factory_price']);
    final int totalBenefitPrice = product['quantity'] * benefit;
    final int totalPrixVente = product['quantity'] * product['selling_price'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ProductDetailBottomSheet(
        product: product,
        benefit: benefit,
        totalBenefitPrice: totalBenefitPrice,
        totalPrixVente: totalPrixVente,
        onDelete: () async {
          await _handleDelete(product['id']);
        },
        onEdit: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProductPage(product: product),
            ),
          ).then((success) {
            if (success == true) {
              _loadData();
            }
          });
        },
      ),
    );
  }

  // Méthode pour gérer la suppression
  Future<void> _handleDelete(int productId) async {
    EasyLoading.show(status: 'Suppression en cours...');

    try {
      await _dbHelper.deleteProduct(productId);
      EasyLoading.dismiss();
      _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produit supprimé avec succès !'),
          backgroundColor: greenColor,
        ),
      );
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échec de la suppression du produit.'),
          backgroundColor: redColor,
        ),
      );
    }
  }
}