import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:madistock/api/database_helper.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:madistock/views/ajout/add_product_page.dart';
import 'package:madistock/views/ajout/add_sale_page.dart';
import 'package:madistock/widgets/charts/sales_histogram.dart';
import 'package:madistock/widgets/charts/sales_pie_chart.dart';
import 'package:madistock/widgets/menu/app_drawer.dart';
import 'package:madistock/widgets/menu/appbar_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int totalProducts = 0;
  int criticalStock = 0;
  List<Map<String, dynamic>> mostSoldProducts = [];
  List<Map<String, dynamic>> sellsByCategory = [];
  //Map<String, int> topSellingProducts = {};
  //Map<String, int> sellsByCategory = {};

  @override
  void initState(){
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    final dbHelper = DatabaseHelper();
    final products = await dbHelper.getProducts();
    final sales = await dbHelper.getSalesByCategory();
    final categories = await dbHelper.getCategories();

    setState(() {
      totalProducts = products.length;
      criticalStock = products.where((p) => (p['quantity'] ?? 0) < 5).length;

      mostSoldProducts = sales.map((sale) {
        return {
          'product': sale['product_name'] ?? 'Inconnu',
          'quantity': (sale['sale_quantity'] ?? 0).toInt(),
        };
      }).toList();

      sellsByCategory = categories.map((cat) {
        return {
          'category': cat['name'] ?? 'Inconnu',
          'sales': (cat['id'] ?? 0).toInt(),
        };
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: "MadiStock - Tableau de Bord",
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre principal
            Text(
              'Welcome !',
              style: TextStyle(
                fontSize: 24.dp, // Taille de police responsive
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),

            // Aperçu rapide (statistiques)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDashboardCard('Produits stockés', '$totalProducts', Icons.inventory, Colors.green),
                _buildDashboardCard('Stock critique', '$criticalStock', Icons.warning_amber, Colors.red),
                _buildDashboardCard('Ventes totales', '450 €', Icons.shopping_cart, Colors.blue),
              ],
            ),
            SizedBox(height: 4.h),

            // Section Graphique - Histogramme des articles les plus vendus
            Text(
              'Articles les plus vendus',
              style: TextStyle(
                fontSize: 20.dp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 0.2.h),
            SizedBox(
              height: 20.h, // 20% de la hauteur de l'écran
              child: SalesHistogram(salesData: mostSoldProducts),
            ),

            /*
            SizedBox(height: 4.h),

            // Section Graphique - Camembert

            Text(
              'Répartition des ventes par catégories',
              style: TextStyle(
                fontSize: 20.dp, // Taille de police responsive
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h), // 2% de la hauteur de l'écran
            SizedBox(
              height: 20.h, // 20% de la hauteur de l'écran
              child: SalesPieChart(salesData: sellsByCategory),
            ),
            */
            SizedBox(height: 4.h), // 4% de la hauteur de l'écran

            // Section Rapports
            Text(
              'Rapports simples',
              style: TextStyle(
                fontSize: 20.dp, // Taille de police responsive
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h), // 2% de la hauteur de l'écran
            _buildReportCard(
              title: 'Ventes totales',
              value: '450 €',
              icon: Icons.monetization_on,
              color: Colors.blue,
            ),
            _buildReportCard(
              title: 'Article le plus vendu',
              value: 'Produit A (100 unités)',
              icon: Icons.local_offer,
              color: Colors.green,
            ),
            /*
            SizedBox(height: 4.h), // 4% de la hauteur de l'écran

            // Boutons d'action rapide
            Text(
              'Actions rapides',
              style: TextStyle(
                fontSize: 20.dp, // Taille de police responsive
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h), // 2% de la hauteur de l'écran
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddProductPage()),
                    );
                  },
                  icon: Icon(Icons.add, size: 4.w), // 4% de la largeur de l'écran
                  label: Text(
                    'Ajouter produit',
                    style: TextStyle(
                      fontSize: 14.dp, // Taille de police responsive
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Action pour voir la liste des produits
                  },
                  icon: Icon(Icons.list, size: 4.w), // 4% de la largeur de l'écran
                  label: Text(
                    'Liste des produits',
                    style: TextStyle(
                      fontSize: 14.dp, // Taille de police responsive
                    ),
                  ),
                ),
              ],
            ),

             */
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add_rounded,
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: yellowColor,
        overlayColor: blackColor,
        overlayOpacity: 0.2,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add_rounded, color: ccaColor, size: 6.w),
            label: 'Ajouter un produit',
            backgroundColor: blackColor,
            onTap: () => {
              EasyLoading.show(status: 'Loading...'),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductPage(),
                ),
              ),
              EasyLoading.dismiss(),
            },
          ),
          SpeedDialChild(
            child: Icon(
              Icons.point_of_sale_rounded,
              color: greenColor,
              size: 6.w,
            ),
            label: 'Ajouter une vente',
            backgroundColor: blackColor,
            onTap: () => {
              EasyLoading.show(status: 'Loading...'),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddSalesPage(),
                ),
              ),
              EasyLoading.dismiss(),
            },
          ),
        ],
      ),
    );
  }

  // Widget pour afficher une carte de statistique
  Widget _buildDashboardCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        width: 28.w,
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            Icon(icon, size: 6.h, color: color),
            SizedBox(height: 1.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.dp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.dp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour afficher une carte de rapport simple
  Widget _buildReportCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 8.w, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.dp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 14.dp,
          ),
        ),
        trailing: Icon(Icons.arrow_forward, size: 6.w),
        onTap: () {
          // Action lors du clic sur un rapport
        },
      ),
    );
  }
}