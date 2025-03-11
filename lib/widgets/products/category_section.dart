import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:madistock/widgets/products/product_card.dart';

class CategorySection extends StatelessWidget {
  final String categoryName;
  final List<Map<String, dynamic>> products;
  final Function(BuildContext, Map<String, dynamic>) onTapProduct;

  const CategorySection({
    required this.categoryName,
    required this.products,
    required this.onTapProduct,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Text(
            categoryName,
            style: TextStyle(
              fontSize: 16.dp,
              fontWeight: FontWeight.bold,
              color: ccaColor,
            ),
          ),
        ),
        ...products.map(
          (product) => ProductCard(
            product: product,
            onTap: () => onTapProduct(context, product),
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
