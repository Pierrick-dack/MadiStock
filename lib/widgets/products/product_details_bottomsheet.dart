import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:madistock/constants/app_colors.dart';

class ProductDetailBottomSheet extends StatelessWidget {
  final Map<String, dynamic> product;
  final int benefit;
  final int totalBenefitPrice;
  final int totalPrixVente;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ProductDetailBottomSheet({
    required this.product,
    required this.benefit,
    required this.totalBenefitPrice,
    required this.totalPrixVente,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre en haut avec le menu
            // Petit trait en haut
            Center(
              child: Container(
                width: 20.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: ccaColor,
                  borderRadius: BorderRadius.circular(29),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Détails du produit",
                  style: TextStyle(
                    fontSize: 17.dp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Menu avec trois boutons
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: ccaColor, size: 6.w),
                  onSelected: (String choice) async {
                    switch (choice) {
                      case 'Supprimer':
                      // Afficher une alerte de confirmation pour la suppression
                        final bool confirmDelete = await _showConfirmationDialog(
                          context,
                          title: 'Confirmer la suppression',
                          message: 'Êtes-vous sûr de vouloir supprimer ce produit ?',
                        );
                        if (confirmDelete) {
                          onDelete();
                        }
                        break;
                      case 'Modifier':
                      // Afficher une alerte de confirmation pour la modification
                        final bool confirmEdit = await _showConfirmationDialog(
                          context,
                          title: 'Confirmer la modification',
                          message: 'Êtes-vous sûr de vouloir modifier ce produit ?',
                        );
                        if (confirmEdit) {
                          onEdit(); // Appeler la fonction de modification
                        }
                        break;
                      case 'Option':
                      // Action pour l'option supplémentaire
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'Modifier',
                      child: Text('Modifier'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Supprimer',
                      child: Text('Supprimer'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 0.2.h),
            // Nom du produit
            Center(
              child: Text(
                product['name'],
                style: TextStyle(
                  fontSize: 20.dp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            // Image du produit
            Center(
              child: Hero(
                tag: product['name'],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: product['image_path'] != null
                      ? Image.file(
                    File(product['image_path']),
                    width: 90.w,
                    height: 40.h,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/Image_not_available.png',
                    width: 90.w,
                    height: 40.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            // Détails du produit
            _buildDetailRow('Description', product['description']),
            _buildDetailRow('Quantité', product['quantity'].toString()),
            _buildDetailRow('Prix d\'usine', '${product['factory_price']} Fcfa'),
            _buildDetailRow('Prix de vente', '${product['selling_price']} Fcfa'),
            _buildDetailRow('Bénéfice par produit', '$benefit Fcfa', color: cca2Color),
            SizedBox(height: 2.h),
            // Totaux
            Center(
              child: Column(
                children: [
                  Text(
                    ' Total Vente : $totalPrixVente Fcfa',
                    style: TextStyle(
                      fontSize: 18.dp,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                      backgroundColor: redColor,
                    ),
                  ),
                  Text(
                    'Total Bénéfice : $totalBenefitPrice Fcfa',
                    style: TextStyle(
                      fontSize: 18.dp,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                      backgroundColor: greenColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour construire une ligne de détail
  Widget _buildDetailRow(String label, String value, {Color? color}) => Padding(
    padding: EdgeInsets.symmetric(vertical: 0.5.h),
    child: Text(
      '$label : $value',
      style: TextStyle(
        fontSize: 16.dp,
        color: color ?? Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  // Méthode pour afficher une boîte de dialogue de confirmation
  Future<bool> _showConfirmationDialog(
      BuildContext context, {
        required String title,
        required String message,
      }) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler', style: TextStyle(color: redColor)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirmer', style: TextStyle(color: greenColor)),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }
}