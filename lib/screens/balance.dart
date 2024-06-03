import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app/methods/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Withdrawal {
  final int id;
  final String method;
  final double amount;
  final String status;

  Withdrawal({
    required this.id,
    required this.method,
    required this.amount,
    required this.status,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) {
    return Withdrawal(
      id: json['id'],
      method: json['method'],
      amount: double.parse(json['amount'].toString()),
      status: json['status'],
    );
  }
}

class BalanceScreen extends StatefulWidget {
  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  List<Withdrawal> withdrawals = [];
  double totalBalance = 0;
  bool isLoading = true;

  Future<void> getUserWithdrawals() async {
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
        route: '/withdraws/userWithdrawals',
        token: token,
      );

      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        setState(() {
          withdrawals = responseData
              .map((withdrawalData) => Withdrawal.fromJson(withdrawalData))
              .toList();
          isLoading = false;
        });
      } else {
        print('Failed to load withdrawals: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching withdrawals: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getUserBalance() async {
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
        route: '/balance',
        token: token,
      );

      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        setState(() {
          totalBalance = double.parse(responseData['amount'].toString());
          isLoading = false;
        });
      } else {
        print('Failed to load balance: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching balance: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addWithdrawal(String method, double amount) async {
    API api = API();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print('Token not available');
      return;
    }

    try {
      final response = await api.postRequest(
        route: '/withdraws/new',
        token: token,
        data: {
          'amount': amount.toString(), // Convert amount to string
          'method': method,
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          getUserWithdrawals();
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Withdrawal request submitted successfully')),
        );
      } else {
        print('Failed to add withdrawal: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit withdrawal request')),
        );
      }
    } catch (e) {
      print('Error adding withdrawal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting withdrawal request')),
      );
    }
  }

  void _showAddWithdrawalDialog() {
    final _amountController = TextEditingController();
    String? _selectedMethod;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Withdrawal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedMethod = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    child: Text('PayPal'),
                    value: 'paypal',
                  ),
                  DropdownMenuItem(
                    child: Text('Bank Transfer'),
                    value: 'bank_transfer',
                  ),
                ],
                decoration: InputDecoration(labelText: 'Method'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                if (_amountController.text.isNotEmpty &&
                    _selectedMethod != null) {
                  final amount = double.parse(_amountController.text);
                  final method = _selectedMethod!;
                  addWithdrawal(method, amount);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill out all fields')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getUserBalance();
    getUserWithdrawals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Balance and Withdrawals'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 233, 202, 135),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Total Balance: $totalBalance DH',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(height: 20),
                    withdrawals.isEmpty
                        ? Center(
                            child: Text('No withdrawals found'),
                          )
                        : Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                horizontalMargin: 20,
                                columns: [
                                  DataColumn(label: Text('Method',style: TextStyle(fontSize: 17),)),
                                  DataColumn(label: Text('Amount',style: TextStyle(fontSize: 17),)),
                                  DataColumn(label: Text('Status',style: TextStyle(fontSize: 17),)),
                                ],
                                rows: withdrawals.map((withdrawal) {
                                  Color statusColor =
                                      Colors.black; // Default color for status

                                  // Set color based on status
                                  switch (withdrawal.status.toLowerCase()) {
                                    case 'pending':
                                      statusColor = Color.fromARGB(255, 242, 210, 1);
                                      break;
                                    case 'rejected':
                                      statusColor = Colors.red;
                                      break;
                                    case 'paid':
                                      statusColor = Colors.green;
                                      break;
                                    default:
                                      statusColor = Colors.black;
                                  }

                                  return DataRow(
                                    cells: [
                                      DataCell(Text(withdrawal.method)),
                                      DataCell(
                                          Text(withdrawal.amount.toString())),
                                      DataCell(
                                        Text(
                                          withdrawal.status,
                                          style: TextStyle(
                                            color:
                                                statusColor, // Apply color based on status
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWithdrawalDialog,
        child: Icon(color: Colors.white, Icons.add),
        backgroundColor: Color.fromARGB(255, 7, 127, 59),
      ),
    );
  }
}
