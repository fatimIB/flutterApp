import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app/methods/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Point {
  final int id;
  final int amount;
  final String status;
  final String createdAt;

  Point({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      id: json['id'],
      amount: json['amount'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}

class PointScreen extends StatefulWidget {
  @override
  _PointScreenState createState() => _PointScreenState();
}

class _PointScreenState extends State<PointScreen> {
  List<Point> points = [];
  bool isLoading = true;
  int totalPoints = 0;
  int activePoints = 0;

  Future<void> getUserPoints() async {
    API api = API();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print('Token non disponible');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await api.getRequest(
        route: '/user/points',
        token: token,
      );

      print(response.body); // Log the raw response body

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        final List<dynamic> userPointsData = responseData['points'];

        setState(() {
          points = userPointsData
              .map((pointData) => Point.fromJson(pointData))
              .toList();
          totalPoints = points.fold(0, (sum, item) => sum + item.amount);
          activePoints = points.where((point) => point.status.toLowerCase() == 'active').fold(0, (sum, item) => sum + item.amount);

          isLoading = false;
        });
      } else {
        print('Échec du chargement des points: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des points: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Points'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white, // Fond blanc pour l'application
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : points.isEmpty
                ? Center(child: Text('Aucun point trouvé'))
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(
                            height:
                                20), // Ajout d'un SizedBox pour déplacer le conteneur vers le bas
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.cyan, // Couleur de la bordure
                              width: 2.0, // Largeur de la bordure
                            ),
                            borderRadius: BorderRadius.circular(
                                10.0), // Rayon de la bordure arrondie
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'Total points: $activePoints',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(
                                  label: Row(
                                    children: [
                                      Icon(color: Colors.amber, Icons.star),
                                      SizedBox(width: 40),
                                      Text(
                                        'Points',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataColumn(
                                  label: Row(
                                    children: [
                                      Icon(color: Colors.amber, Icons.info),
                                      SizedBox(width: 40),
                                      Text(
                                        'Statut',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              rows: points.map((point) {
                                Color statusColor =
                                    point.status.toLowerCase() == 'active'
                                        ? Colors.green
                                        : Colors.red;
                                IconData statusIcon =
                                    point.status.toLowerCase() == 'active'
                                        ? Icons.check_circle
                                        : Icons.cancel;

                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Text(
                                          point.amount.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              statusIcon,
                                              size: 16,
                                              color: statusColor,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              point.status,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: statusColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
