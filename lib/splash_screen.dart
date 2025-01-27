import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:madistock/constants/app_colors.dart';
import 'package:madistock/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // Navigation vers la page d'accueil après un délai de 4 secondes
  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 4));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bluePrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation de zoom sur l'icône
            ZoomIn(
              duration: Duration(seconds: 2),
              child: Icon(
                Icons.inventory_2,
                size: 100,
                color: whiteColor,
              ),
            ),
            SizedBox(height: 20),

            // Animation pour le texte
            FadeInDown(
              delay: Duration(milliseconds: 800),
              child: Text(
                'MadiStock',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: whiteColor,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Loader circulaire
            CircularProgressIndicator(
              color: whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
