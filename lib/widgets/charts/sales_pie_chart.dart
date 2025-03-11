import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesPieChart extends StatelessWidget {
  final List<Map<String, dynamic>> salesData;

  const SalesPieChart({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: salesData.map((data) {
          return PieChartSectionData(
            color: data['color'],
            value: data['value'],
            title: data['category'],
            radius: 50,
          );
        }).toList(),
      ),
    );
  }
}