// ignore_for_file: prefer_const_constructors, avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool _togglePasswordVisibility = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // ****************************
  verifyUser(String user_id, String pwd) async {
    try {
      Uri url = Uri.parse(
          "https://retoolapi.dev/B13laa/getusers?user_id=$user_id&password=$pwd");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body.length != 0) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Warning!'),
              content: const Text('Wrong user name or password'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
  // ****************************

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // screensize-------------------------
    // Full screen width and height
    double height1 = MediaQuery.of(context).size.height;

    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;

    // Height (without status bar)
    double height2 = height1 - padding.top;
    // screensize-------------------------
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height2 / 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hi There,',
                              style: GoogleFonts.anton(
                                  fontSize: 72, fontWeight: FontWeight.w700)),
                          Text(
                            'Please login',
                            style: GoogleFonts.cairo(
                                fontSize: 28, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      // email address
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: TextFormField(
                          controller: _emailController,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w200,
                              color: Colors.black),
                          decoration: InputDecoration(
                            icon: Icon(Icons.person, color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.black,
                              ),
                            ),
                            hintText: 'Email address',
                            fillColor: Colors.black,
                            filled: false,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email address cannot be empty';
                            }
                            if (!RegExp(
                                    r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                .hasMatch(value)) {
                              return 'Please enter correct email address';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      // password
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _togglePasswordVisibility,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              icon: Icon(Icons.lock, color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                              ),
                              hintText: 'Password',
                              fillColor: Colors.black,
                              filled: false,
                              // icon
                              suffixIcon: togglePassword()
                              // icon**
                              ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password cannot be empty';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      // button
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: 180,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              verifyUser(_emailController.text.toString(),
                                  _passwordController.text.toString());
                            }
                          },
                          child: Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // widget function
  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _togglePasswordVisibility = !_togglePasswordVisibility;
        });
      },
      icon: _togglePasswordVisibility
          ? Icon(Icons.visibility_off)
          : Icon(Icons.visibility),
      color: Colors.black,
    );
  }
  // widget function
}
