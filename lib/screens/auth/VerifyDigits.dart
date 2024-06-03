import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/widget/input_field.dart';
import 'dart:convert'; // Import this package for jsonDecode
import '../../methods/api.dart';
import 'package:app/screens/auth/ChangePassword.dart';

class VerifyDigits extends StatefulWidget {
  const VerifyDigits({Key? key}) : super(key: key);

  @override
  State<VerifyDigits> createState() => _VerifyDigitsState();
}

class _VerifyDigitsState extends State<VerifyDigits> {
  TextEditingController digit1Controller = TextEditingController();
  TextEditingController digit2Controller = TextEditingController();
  TextEditingController digit3Controller = TextEditingController();
  TextEditingController digit4Controller = TextEditingController();

  FocusNode digit1FocusNode = FocusNode();
  FocusNode digit2FocusNode = FocusNode();
  FocusNode digit3FocusNode = FocusNode();
  FocusNode digit4FocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    digit1Controller.dispose();
    digit2Controller.dispose();
    digit3Controller.dispose();
    digit4Controller.dispose();
    digit1FocusNode.dispose();
    digit2FocusNode.dispose();
    digit3FocusNode.dispose();
    digit4FocusNode.dispose();
    super.dispose();
  }

  void verifyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email not found in local storage'),
        ),
      );
      return;
    }

    String code = digit1Controller.text +
        digit2Controller.text +
        digit3Controller.text +
        digit4Controller.text;

    final result = await API().postRequest(
        route: '/password/reset/verify', data: {'email': email, 'code': code});
    final response = jsonDecode(result.body);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response['message'] ?? 'Verification failed'),
      ),
    );

    if (result.statusCode == 200) {
      await prefs.setString('email', email);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ChangePassword()), // Navigate to the VerifyDigits screen
      );
    }
  }

  void clearInputs() {
    digit1Controller.clear();
    digit2Controller.clear();
    digit3Controller.clear();
    digit4Controller.clear();
    digit1FocusNode.requestFocus();
  }

  void handleInputChange(String value, TextEditingController controller,
      FocusNode currentFocus, FocusNode nextFocus) {
    if (value.length == 1) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
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
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset("assets/login.png"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Text(
                        "Email Verification",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Text(
                        "Enter the Digits sent to your email",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: TextField(
                            controller: digit1Controller,
                            focusNode: digit1FocusNode,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: TextStyle(fontSize: 24),
                            decoration: InputDecoration(
                              counter: SizedBox.shrink(),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => handleInputChange(
                                value,
                                digit1Controller,
                                digit1FocusNode,
                                digit2FocusNode),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: TextField(
                            controller: digit2Controller,
                            focusNode: digit2FocusNode,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: TextStyle(fontSize: 24),
                            decoration: InputDecoration(
                              counter: SizedBox.shrink(),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => handleInputChange(
                                value,
                                digit2Controller,
                                digit2FocusNode,
                                digit3FocusNode),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: TextField(
                            controller: digit3Controller,
                            focusNode: digit3FocusNode,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: TextStyle(fontSize: 24),
                            decoration: InputDecoration(
                              counter: SizedBox.shrink(),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => handleInputChange(
                                value,
                                digit3Controller,
                                digit3FocusNode,
                                digit4FocusNode),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: TextField(
                            controller: digit4Controller,
                            focusNode: digit4FocusNode,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: TextStyle(fontSize: 24),
                            decoration: InputDecoration(
                              counter: SizedBox.shrink(),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => handleInputChange(
                                value,
                                digit4Controller,
                                digit4FocusNode,
                                digit4FocusNode),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: verifyCode,
                          child: Text("Verify"),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: clearInputs,
                          child: Text("Clear"),
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
