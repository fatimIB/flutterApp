import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/screens/auth/login.dart';
import 'package:app/screens/auth/MyProfile.dart';
import 'package:app/screens/Sales.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences preferences;
  bool isLoading = false;

  final double horizontalPadding = 40;
  final double verticalPadding = 20;

  final List<Color> cardColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });
  }

  void logout() {
    preferences.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image en haut de la page
                      Container(
                        width: double.infinity,
                        height: size.height * 0.250,
                        child: Image.asset(
                          'assets/emp.png',
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Welcome message with background color
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
                        child: Text(
                          "   Welcome to your account",
                          style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 9, 9, 9), fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 0),

                      // Options
                      Expanded(
                        child: GridView.builder(
                          itemCount: 4,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 8 / 8.5,
                          ),
                          itemBuilder: (context, index) {
                            return _customCard(
                              title: ['My Points', 'My sales', 'My Balance and Withdrawals', 'My Profile'][index],
                              icon: [Icons.star, Icons.attach_money, Icons.money, Icons.person][index],
                              color: cardColors[index],
                              onTap: [
                                () => Navigator.of(context).pushNamed('/points'),
                                () => Navigator.of(context).pushNamed('/sales'),
                                () => Navigator.of(context).pushNamed('/balance'),
                                () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyProfile())),
                              ][index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      onPressed: logout,
                      backgroundColor: Colors.blue,
                      child: Icon(color: Colors.white, Icons.logout),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

 Widget _customCard({required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
  bool isTapped = false;

  return GestureDetector(
    onTapDown: (_) {
      setState(() {
        isTapped = true;
      });
    },
    onTapUp: (_) {
      setState(() {
        isTapped = false;
      });
    },
    onTapCancel: () {
      setState(() {
        isTapped = false;
      });
    },
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isTapped ? color.withOpacity(0.3) : color.withOpacity(0.5), // Use different opacity when tapped
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 45, color: Color.fromARGB(255, 5, 5, 5)),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 3, 3, 3),
            ),
          ),
        ],
      ),
    ),
  );
}
}