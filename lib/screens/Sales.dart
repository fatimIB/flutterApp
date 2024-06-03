import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app/methods/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sale {
  final int id;
  final int userId;
  final String products;
  final double totalPrice;
  final String createdAt; // Change this to DateTime type
  final String updatedAt;
  final String userName;
  final double commission;

  Sale({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
    required this.commission,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      userId: json['user_id'],
      products: json['products'] ?? '',
      totalPrice: json['total_price'] != null ? double.parse(json['total_price']) : 0.0,
      createdAt: json['created_at'] != null ? _extractDate(json['created_at']) : '',
      updatedAt: json['updated_at'] ?? '',
      userName: json['user_name'] ?? '',
      commission: json['commission'] != null ? double.parse(json['commission']) : 0.0,
    );
  }

  static String _extractDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
}

class SalesScreen extends StatefulWidget {
  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<Sale> sales = [];
  bool isLoading = true;

  Future<void> getUserSales() async {
    API api = API();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print('Token not available');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await api.getRequest(
        route: '/sales/me',
        token: token,
      );

      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> salesData = json.decode(response.body);

        setState(() {
          sales = salesData.map((saleData) => Sale.fromJson(saleData)).toList();
          isLoading = false;
        });
      } else {
        print('Failed to load sales: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching sales: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserSales();
  }

  void _showSaleDetails(Sale sale) {
    // Implement code to show sale details in a popup or modal
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sale Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Products: ${sale.products}'),
                Text('Total Price: ${sale.totalPrice}'),
                Text('Commission: ${sale.commission}'),
                Text('Date: ${sale.createdAt}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Sales'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : sales.isEmpty
                ? Center(child: Text('No sales found'))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: sales.length,
                      itemBuilder: (context, index) {
                        final sale = sales[index];
                        return Card(
                          child: ListTile(
                            title: Text('Date: ${sale.createdAt}'), // Show sale date
                            subtitle: Text('Commission: ${sale.commission}'), // Show commission
                            onTap: () {
                              _showSaleDetails(sale);
                            },
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
