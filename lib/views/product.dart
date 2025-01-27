import 'package:flutter/material.dart';
import 'package:madistock/constants/app_colors.dart';

class ProductListPage extends StatelessWidget {
  ProductListPage({super.key});
  // Liste fictive des produits avec des chemins d'images locales
  final List<Map<String, dynamic>> products = [
    {
      'image': 'assets/produits/ordinateur_portable_hp.jpg',
      'name': 'Ordinateur portable',
      'description': 'Un ordinateur puissant pour le travail',
      'category': 'Électronique',
      'quantity': 5,
      'factoryPrice': 1000,
      'sellingPrice': 1200,
    },
    {
      'image': 'assets/produits/telephone.jpg',
      'name': 'Téléphone portable',
      'description': 'Téléphone dernière génération',
      'category': 'Électronique',
      'quantity': 8,
      'factoryPrice': 700,
      'sellingPrice': 800,
    },
    {
      'image': 'assets/produits/chaise_bureau.jpg',
      'name': 'Chaise ergonomique',
      'description': 'Chaise confortable pour le bureau',
      'category': 'Mobilier',
      'quantity': 10,
      'factoryPrice': 100,
      'sellingPrice': 150,
    },
    {
      'image': 'assets/produits/table_bureau.jpg',
      'name': 'Table de bureau',
      'description': 'Table robuste pour le travail',
      'category': 'Mobilier',
      'quantity': 4,
      'factoryPrice': 200,
      'sellingPrice': 300,
    },
    {
      'image': 'assets/produits/montre_connecte.jpg',
      'name': 'Montre connectée',
      'description': 'Montre intelligente avec suivi de santé',
      'category': 'Accessoires',
      'quantity': 12,
      'factoryPrice': 150,
      'sellingPrice': 200,
    },
    {
      'image': 'assets/produits/sac_a_dos_pour_ordinateur.jpg',
      'name': 'Sac à dos pour ordinateur',
      'description': 'Sac à dos spacieux pour transporter votre ordinateur',
      'category': 'Accessoires',
      'quantity': 15,
      'factoryPrice': 50,
      'sellingPrice': 80,
    },
    {
      'image': 'assets/produits/cafe_grains.jpg',
      'name': 'Café en grains',
      'description': 'Café de haute qualité pour les amateurs',
      'category': 'Alimentation',
      'quantity': 50,
      'factoryPrice': 20,
      'sellingPrice': 25,
    },
    {
      'image': 'assets/produits/thé_vert_bio.png',
      'name': 'Thé vert bio',
      'description': 'Thé vert bio pour une consommation saine',
      'category': 'Alimentation',
      'quantity': 30,
      'factoryPrice': 10,
      'sellingPrice': 20,
    },
    {
      'image': 'assets/produits/velo_montagne.jpg',
      'name': 'Vélo de montagne',
      'description': 'Vélo robuste pour les aventures en plein air',
      'category': 'Sports',
      'quantity': 6,
      'factoryPrice': 500,
      'sellingPrice': 800,
    },
    {
      'image': 'assets/produits/chaussure_course.jpg',
      'name': 'Chaussures de course',
      'description': 'Chaussures légères et respirantes pour la course',
      'category': 'Sports',
      'quantity': 25,
      'factoryPrice': 80,
      'sellingPrice': 120,
    },
  ];


  @override
  Widget build(BuildContext context) {
    // Regrouper les produits par catégorie
    final Map<String, List<Map<String, dynamic>>> groupedProducts = {};
    for (var product in products) {
      if (!groupedProducts.containsKey(product['category'])) {
        groupedProducts[product['category']] = [];
      }
      groupedProducts[product['category']]!.add(product);
    }

    return Scaffold(
      appBar: AppBar(
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
              'Liste des produits',
              style: TextStyle(color: whiteColor),
            ),
          ],
        ),
        backgroundColor: ccaColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Produits par catégorie',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: groupedProducts.length,
                itemBuilder: (context, categoryIndex) {
                  final category = groupedProducts.keys.elementAt(categoryIndex);
                  final categoryProducts = groupedProducts[category]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ccaColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoryProducts.length,
                        itemBuilder: (context, productIndex) {
                          final product = categoryProducts[productIndex];
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: InkWell(
                              onTap: () {
                                _showProductDetailsBottomSheet(context, product);
                              },
                              child: Row(
                                children: [
                                  Hero(
                                    tag: product['name'],
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        product['image'],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          product['name'],
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Text(
                                          'Quantité : ${product['quantity']}',
                                          style: const TextStyle(color: greyColor, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${product['sellingPrice']} Fcfa',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: ccaColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour calculer le prix de vente
  int _calculateBenefit(int factoryPrice, int sellingPrice) {
    return sellingPrice - factoryPrice;
  }

  // Fonction pour afficher le BottomSheet avec les détails du produit
  void _showProductDetailsBottomSheet(BuildContext context, Map<String, dynamic> product) {
    final int benefit = _calculateBenefit(
      product['factoryPrice'],
      product['sellingPrice'],
    );
    final int totalBenefitPrice = product['quantity'] * benefit;
    final int totalPrixVente = product['quantity'] * product['sellingPrice'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Petite barre en haut pour indiquer le BottomSheet
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(29),
                        color: ccaColor,
                      ),
                      height: 5,
                      width: 95,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    '${product['name']}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // Affichage de l'image en grand avec Hero animation
                Center(
                  child: Hero(
                    tag: product['name'],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.asset(
                        product['image'] ?? 'assets/Image_not_available.png',
                        width: MediaQuery.of(context).size.width * 12.0,
                        height: 395,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Détails du produit
                Text('Description : ${product['description']}'),
                const SizedBox(height: 10),
                Text('Quantité en stock : ${product['quantity']}'),
                const SizedBox(height: 10),
                Text('Prix d\'usine : ${product['factoryPrice']} Fcfa'),
                const SizedBox(height: 10, ),
                Text('Prix de vente : ${product['sellingPrice']} Fcfa'),
                const SizedBox(height: 10),
                Text('Bénéfice : ${benefit} Fcfa'),
                const SizedBox(height: 10, ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Bénéfice total après vente: ${totalBenefitPrice.toStringAsFixed(0)} Fcfa',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: greenColor,
                        ),
                      ),
                      Text(
                        'Prix total après vente: ${totalPrixVente.toStringAsFixed(0)} Fcfa',  //
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: ccaColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
