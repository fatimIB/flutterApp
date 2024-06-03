import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app/helper/constant.dart';
import 'package:app/methods/api.dart';
import 'package:app/widget/input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();

  String errorMessage = '';
  String successMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? authToken = preferences.getString('token');

    if (authToken != null) {
      try {
        final result = await API().getRequest(route: '/user/profile', token: authToken);
        final response = jsonDecode(result.body);

        if (result.statusCode == 200) {
          setState(() {
            firstName.text = response['firstname'] ?? '';
            lastName.text = response['lastname'] ?? '';
            email.text = response['email'] ?? '';
            address.text = response['address'] ?? '';
            phone.text = response['phone'] ?? '';
          });
        } else {
          setState(() {
            errorMessage = response['message'] ?? 'Failed to load profile';
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = 'An error occurred. Please try again.';
        });
      }
    } else {
      setState(() {
        errorMessage = 'User is not authenticated.';
      });
    }
  }

  void updateProfile() async {
    final data = {
      'firstname': firstName.text.trim(),
      'lastname': lastName.text.trim(),
      'email': email.text.trim(),
      'address': address.text.trim(),
      'phone': phone.text.trim(),
    };

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? authToken = preferences.getString('token');

      if (authToken != null) {
        final result = await API().putRequest(
          route: '/user/profile',
          data: data,
          token: authToken,
        );
        final response = jsonDecode(result.body);

        if (result.statusCode == 200) {
          setState(() {
            successMessage = 'Profile updated successfully!';
            errorMessage = '';
          });
        } else {
          setState(() {
            errorMessage = response['message'] ?? 'Failed to update profile';
            successMessage = '';
          });
        }
      } else {
        setState(() {
          errorMessage = 'User is not authenticated.';
          successMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred. Please try again.';
        successMessage = '';
      });
    }
  }

  Future<void> _showPasswordVerificationModal() async {
    TextEditingController passwordController = TextEditingController();
    String authToken = (await SharedPreferences.getInstance()).getString('token') ?? '';
    String modalErrorMessage = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Enter Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  if (modalErrorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        modalErrorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    final response = await API().postRequest(
                      route: '/check-password',
                      data: {'password': passwordController.text.trim()},
                      token: authToken,
                    );

                    final responseData = jsonDecode(response.body);

                    if (response.statusCode == 200) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/change-password');
                    } else {
                      setState(() {
                        modalErrorMessage = responseData['message'] ?? 'Incorrect password';
                      });
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = deviceWidth(context);
    double height = deviceHeight(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0),
                  const Text(
                    'Edit your Profile',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  if (successMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        successMessage,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  InputField(
                    width: width,
                    controller: firstName,
                    hintText: 'First Name',
                    decoration: InputDecoration(
                      hintText: 'First Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    width: width,
                    controller: lastName,
                    hintText: 'Last Name',
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    width: width,
                    controller: email,
                    hintText: 'Email',
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    width: width,
                    controller: address,
                    hintText: 'Address',
                    decoration: InputDecoration(
                      hintText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    width: width,
                    controller: phone,
                    hintText: 'Phone',
                    decoration: InputDecoration(
                      hintText: 'Phone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: updateProfile,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _showPasswordVerificationModal,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
