import 'package:flutter/material.dart';
import 'package:madistock/constants/app_colors.dart';


class SellsPage extends StatelessWidget {
  const SellsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Liste des ventes',
              style: TextStyle(color: whiteColor),
            ),
          ],
        ),
        backgroundColor: ccaColor,
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Ventes par catégorie',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}