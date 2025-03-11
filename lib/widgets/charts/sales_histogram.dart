import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:madistock/constants/app_colors.dart';

class SalesHistogram extends StatelessWidget {
  final List<Map<String, dynamic>> salesData;

  const SalesHistogram({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: salesData.map((data) {
          return BarChartGroupData(
            x: salesData.indexOf(data),
            barRods: [
              BarChartRodData(
                toY: (data['quantity'] as num).toDouble(),
                color: ccaColor,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            axisNameWidget: const Text("Produits"),
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  salesData[value.toInt()]['product'],
                  style: const TextStyle(color: Colors.black, fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: const Text("Quantité vendue"),
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 10),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
