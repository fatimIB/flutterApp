import 'package:app/screens/balance.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/screens/auth/login.dart';
import 'package:app/screens/home.dart';
//import 'package:app/screens/commission.dart';
import 'package:app/screens/Sales.dart';
import 'package:app/screens/points.dart';
import 'package:app/screens/auth/change-password.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Une erreur s\'est produite'),
            );
          } else if (snapshot.hasData) {
            final token = snapshot.data!.getString('token');
            if (token != null) {
              return Home();
            } else {
              return const Login();
            }
          } else {
            return const Login();
          }
        },
      ),
      routes: {
        '/sales': (context) => SalesScreen(),
        '/points': (context) => PointScreen(),
        '/balance': (context) => BalanceScreen(),
        '/change-password': (context) => const ChangePassword(),
        
      },
    );
  }
}
