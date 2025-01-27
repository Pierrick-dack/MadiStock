import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:madistock/views/ajout/add_product_page.dart';
import 'package:madistock/views/ajout/add_sale.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ccaColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            Text(
              'MadiStock - Tableau de Bord',
              style: TextStyle(
                  color: whiteColor,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            color: whiteColor,
            onPressed: () {
              // Action pour synchroniser les données
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre principal
            Text(
              'Bienvenue dans le Stock du bb',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Aperçu rapide (statistiques)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDashboardCard('Produits stockés', '125', Icons.inventory, Colors.green),
                _buildDashboardCard('Stock critique', '5', Icons.warning_amber, Colors.red),
                _buildDashboardCard('Ventes totales', '450 €', Icons.shopping_cart, Colors.blue),
              ],
            ),
            SizedBox(height: 20),

            // Section Graphique - Histogramme des articles les plus vendus
            Text(
              'Articles les plus vendus',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              color: Colors.grey[200], // Placeholder pour l'histogramme
              child: Center(
                child: Text(
                  'Histogramme (à implémenter)',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Section Graphique - Camembert
            Text(
              'Répartition des ventes par catégories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              color: Colors.grey[200], // Placeholder pour le camembert
              child: Center(
                child: Text(
                  'Camembert (à implémenter)',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Section Rapports
            Text(
              'Rapports simples',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 20),

            // Boutons d'action rapide
            Text(
              'Actions rapides',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProductPage()),
                  );
                },
                  icon: Icon(Icons.add),
                  label: Text('Ajouter produit'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Action pour voir la liste des produits
                  },
                  icon: Icon(Icons.list),
                  label: Text('Liste des produits'),
                ),
              ],
            ),
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
              child: const Icon(Icons.add_rounded, color: ccaColor,),
              label: 'Ajouter un produit',
              backgroundColor: blackColor,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProductPage(),
                  ),
                ),
              }
          ),
          SpeedDialChild(
              child: const Icon(Icons.point_of_sale_rounded, color: greenColor,),
              label: 'Ajouter une vente',
              backgroundColor: blackColor,
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddSellsPage(),
                  ),
                ),
              }
          )
        ],
      ),
    );
  }

  // Widget pour afficher une carte de statistique
  Widget _buildDashboardCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        width: 110,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour afficher une carte de rapport simple
  Widget _buildReportCard({required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 40, color: color),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Action lors du clic sur un rapport
        },
      ),
    );
  }
}
