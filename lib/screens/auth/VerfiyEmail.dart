import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app/widget/input_field.dart'; // Import the InputField widget
import '../../methods/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/helper/constant.dart';
import 'package:app/screens/auth/VerifyDigits.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  TextEditingController emailController = TextEditingController();

  String errorMessage = '';

  void requestReset() async {
    final email = emailController.text.trim();
    
    final result = await API().postRequest(route: '/password/reset/request', data: {'email': email});
    final response = jsonDecode(result.body);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response['message'] ?? 'Verification code sent to your email'),
      ),
    );
    if (result.statusCode == 200) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VerifyDigits()), // Navigate to the VerifyDigits screen
    );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe8ebed),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    height: 250,
                    width: deviceWidth(context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset("assets/login.png"),
                    ),
                  ),
                ],
              ),
              spancer(h: 30),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffe1e2e3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Text(
                        "Enter you Email",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                    spancer(h: 5),
                    Container(
                      padding: spacing(h: 1, v: 1),
                      decoration: BoxDecoration(
                        color: Color(0xfff5f8fd),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextFormField(
                        controller: emailController, // Fix the controller parameter
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    spancer(h: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: requestReset, // Fix the function reference
                          child: Text(
                            "Send Verification Code",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
