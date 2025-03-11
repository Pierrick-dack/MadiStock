import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:madistock/views/category_list.dart';
import 'package:madistock/views/product_and_quantity.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: whiteColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: ccaColor),
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: CircleAvatar(
                backgroundColor: whiteColor,
                radius: 5.h,
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 25.w,
                    height: 12.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.category_rounded, color: ccaColor),
            title: const Text('Catégories'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoryListBottomSheet(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category_rounded, color: ccaColor),
            title: const Text('Produits & Quantité'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductAndQuantityList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
