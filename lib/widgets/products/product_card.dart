import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:madistock/constants/app_colors.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const ProductCard({required this.product, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Hero(
              tag: product['name'],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: product['image_path'] != null
                    ? Image.file(
                        File(product['image_path']),
                        width: 18.w,
                        height: 18.w,
                        fit: BoxFit.cover,
                    )
                    : Image.asset(
                      'assets/Image_not_available.png',
                      width: 18.w,
                      height: 18.w,
                      fit: BoxFit.cover,
                    ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.dp,
                    ),
                  ),
                  Text(
                    'Quantité : ${product['quantity']}',
                    style: TextStyle(
                      color: greyColor,
                      fontSize: 14.dp,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${product['selling_price']} Fcfa',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ccaColor,
                fontSize: 16.dp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
