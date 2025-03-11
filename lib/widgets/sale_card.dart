import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:madistock/api/database_helper.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:madistock/views/edit/edit_sale_page.dart';

class SaleCard extends StatelessWidget {
  final int saleId;
  final String productName;
  final String categoryName;
  final int quantity;
  final String saleDate;
  final String paymentMethod;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRefresh;
  final Function(int, int) onProductQuantityUpdated;

  const SaleCard({
    super.key,
    required this.saleId,
    required this.productName,
    required this.categoryName,
    required this.quantity,
    required this.saleDate,
    required this.paymentMethod,
    required this.onEdit,
    required this.onDelete,
    required this.onRefresh,
    required this.onProductQuantityUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: whiteColor,
          child: Icon(
            Icons.shopping_bag_rounded,
            color: ccaColor,
            size: 4.h,
          ),
        ),
        title: Text(
          productName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.dp,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Catégorie : $categoryName",
              style: TextStyle(fontSize: 14.dp),
            ),
            Text(
              "Quantité vendue : $quantity",
              style: TextStyle(fontSize: 14.dp),
            ),
            Text(
              "Date : $saleDate",
              style: TextStyle(fontSize: 14.dp),
            ),
            Text(
              "Paiement : $paymentMethod",
              style: TextStyle(fontSize: 14.dp),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    size: 4.w,
                    color: ccaColor,
                  ),
                  SizedBox(width: 2.w),
                  Text('Modifier', style: TextStyle(fontSize: 14.dp)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 4.w, color: redColor),
                  SizedBox(width: 2.w),
                  Text(
                    'Supprimer',
                    style: TextStyle(
                      fontSize: 14.dp,
                      color: redColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (value) async {
            if (value == 'edit') {
              _openEditSaleBottomSheet(context); // Appeler la méthode pour ouvrir le BottomSheet
            } else if (value == 'delete') {
              final bool confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Confirmer la suppression',
                    style: TextStyle(fontSize: 16.dp),
                  ),
                  content: Text(
                    'Êtes-vous sûr de vouloir supprimer cette vente ?',
                    style: TextStyle(fontSize: 14.dp),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Annuler', style: TextStyle(fontSize: 14.dp)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        'Supprimer',
                        style: TextStyle(fontSize: 14.dp, color: redColor),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                onDelete(); // Appeler la méthode de suppression
              }
            }
          },
        ),
      ),
    );
  }

  void _openEditSaleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: EditSaleBottomSheet(
            saleId: saleId,
            productName: productName,
            categoryName: categoryName,
            quantity: quantity,
            saleDate: saleDate,
            paymentMethod: paymentMethod,
            onSave: (updatedSale) {
              onRefresh();
              Navigator.pop(context);
            },
            onProductQuantityUpdated: (newQuantity) {
              // Récupérer le product_id avant d'appeler onProductQuantityUpdated
              DatabaseHelper().getProductById(int.parse(newQuantity.toString())).then((product) {
                if (product != null) {
                  onProductQuantityUpdated(product['id'], newQuantity);
                }
              });
            },
          ),
        );
      },
    );
  }
}