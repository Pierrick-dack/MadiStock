import 'package:flutter/material.dart';
import 'package:madistock/api/database_helper.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:madistock/widgets/menu/app_drawer.dart';
import 'package:madistock/widgets/menu/appbar_widget.dart';
import 'package:madistock/widgets/sale_card.dart';

class SellsPage extends StatefulWidget {
  const SellsPage({super.key});

  @override
  _SellsPageState createState() => _SellsPageState();
}

class _SellsPageState extends State<SellsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _sales = [];
  final List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final sales = await _dbHelper.getSalesByCategory();
    setState(() {
      _sales = sales;
    });
  }

  void _handleProductQuantityUpdated(int productId, int newQuantity) {
    setState(() {
      final productIndex = _products.indexWhere((product) => product['id'] == productId);
      if (productIndex != -1) {
        _products[productIndex]['quantity'] = newQuantity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: "Liste des ventes",
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(2.w),
        child: _sales.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.remove_shopping_cart_rounded,
                size: 20.h,
                color: greyColor,
              ),
              SizedBox(height: 2.h),
              Text(
                "Aucune vente enregistrée",
                style: TextStyle(
                  fontSize: 18.dp,
                  fontWeight: FontWeight.bold,
                  color: greyColor,
                ),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: _sales.length,
          itemBuilder: (context, index) {
            final sale = _sales[index];

            return SaleCard(
              saleId: sale['sale_id'],
              productName: sale['product_name'],
              categoryName: sale['category_name'],
              quantity: sale['sale_quantity'],
              saleDate: sale['sale_date'],
              paymentMethod: sale['payment_method'],
              onEdit: () {  },
              onDelete: () async {
                final dbHelper = DatabaseHelper();
                await dbHelper.deleteSale(sale['sale_id']);
                _loadData();
              },
              onRefresh:(){
                _loadData();
              },
              onProductQuantityUpdated: _handleProductQuantityUpdated,
            );
          },
        ),
      ),
    );
  }
}