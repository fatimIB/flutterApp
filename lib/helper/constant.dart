import 'package:flutter/material.dart';

// Dimensions de l'appareil
double deviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

// Couleurs
const Color primaryColor = Color(0xFF2ecbf2);
//const Color secondaryColor = Color(0xFF2ecbf2);
//const Color secondaryTextColor = Color(0xFF2ecbf2);

// URL de l'API
const String apiUrl = 'http://10.0.2.2:8000/api';

// Fonction de spancer
SizedBox spancer({double w = 0, double h = 0}) {
  return SizedBox(
    height: h,
    width: w,
  );
}

// Fonction de spacing
EdgeInsets spacing({double h = 0, double v = 0}) {
  return EdgeInsets.symmetric(
    horizontal: h,
    vertical: v,
  );
}
