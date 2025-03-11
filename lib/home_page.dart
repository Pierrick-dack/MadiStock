import 'package:flutter/material.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:madistock/views/dashboard.dart';
import 'package:madistock/views/product.dart';
import 'package:madistock/views/sells.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Liste des pages associées aux onglets
  final List<Widget> _pages = [
    DashboardPage(),
    ProductListPage(),
    SellsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: ccaColor,
        selectedItemColor: whiteColor,
        unselectedItemColor: greyColor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home_rounded, isActive: _currentIndex == 0),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.shopping_cart_rounded, isActive: _currentIndex == 1),
            label: 'Produits',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.sell_rounded, isActive: _currentIndex == 2),
            label: 'Ventes',
          ),
        ],
      ),
    );
  }

  // Fonction pour créer l'icône avec un fond circulaire
  Widget _buildIcon(IconData icon, {required bool isActive}) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? whiteColor : Colors.transparent,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(6), // Marge intérieure
      child: Icon(
        icon,
        color: isActive ? ccaColor : greyColor,
      ),
    );
  }
}
