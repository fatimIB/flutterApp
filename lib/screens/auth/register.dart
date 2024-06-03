import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/helper/constant.dart';
import 'package:app/screens/auth/login.dart';
import 'package:app/screens/home.dart';
import 'package:app/widget/input_field.dart';
import '../../methods/api.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  
  String errorMessage = '';

   void registerUser() async {
    final data = {
      'firstname': firstName.text.trim(),
      'lastname': lastName.text.trim(),
      'email': email.text.trim(),
      'address': address.text.trim(),
      'phone': phone.text.trim(),
      'password': password.text.trim(),
    };

    final result = await API().postRequest(route: '/user/register', data: data);
    final response = jsonDecode(result.body);

    if (result.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registered successfully. You can now login to your account.'),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    } else {
      setState(() {
        errorMessage = response['message'] ?? 'Registration failed';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
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
                    height: 150,
                    width: deviceWidth(context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset("assets/register.png"),
                    ),
                  ),
                ],
              ),
              spancer(h: 1),
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
                        "Register",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                    spancer(h: 5),
                    Container(
                      padding: spacing(h: 2, v: 5),
                      decoration: BoxDecoration(
                        color: Color(0xfff5f8fd),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextFormField(
                        controller: firstName,
                        decoration: InputDecoration(
                          hintText: "First Name",
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    spancer(h: 15),
                    Container(
                      padding: spacing(h: 2, v: 5),
                      decoration: BoxDecoration(
                        color: Color(0xfff5f8fd),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextFormField(
                        controller: lastName,
                        decoration: InputDecoration(
                          hintText: "Last Name",
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    spancer(h: 15),
                    Container(
                      padding: spacing(h: 2, v: 5),
                      decoration: BoxDecoration(
                        color: Color(0xfff5f8fd),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextFormField(
                        controller: email,
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
                    Container(
                      padding: spacing(h: 2, v: 5),
                      decoration: BoxDecoration(
                        color: Color(0xfff5f8fd),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.vpn_key, color: Colors.grey),
                        ),
                      ),
                    ),
                    spancer(h: 15),
                    Container(
                      padding: spacing(h: 2, v: 5),
                      decoration: BoxDecoration(
                        color: Color(0xfff5f8fd),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextFormField(
                        controller: address,
                        decoration: InputDecoration(
                          hintText: "Address",
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.home,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    spancer(h: 15),
                    Container(
                      padding: spacing(h: 2, v: 5),
                      decoration: BoxDecoration(
                        color: Color(0xfff5f8fd),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextFormField(
                        controller: phone,
                        decoration: InputDecoration(
                          hintText: "Phone",
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              spancer(h: 5),
              GestureDetector(
                onTap: () {
                  // Redirect to login
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
             child: Container(
                alignment: Alignment.centerRight,
                  child: Text(
                   "",
                   style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.w500),
                ),
                ),
              ),
              spancer(h: 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: registerUser,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
              spancer(h: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Have we met before?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.deepPurpleAccent),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
