import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/auth_service.dart';
import 'package:todo_app/main_page.dart';
import 'package:todo_app/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'youremail@.com',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'password',
                ),
              ),
              TextButton(
                  onPressed: () async {
                    bool email, password, exist = false;

                    await FirebaseFirestore.instance
                        .collection('user')
                        .where('email', isEqualTo: emailController.text)
                        .get()
                        .then((value) async {
                      if (value.docs.isNotEmpty) {
                        email = true;
                        await FirebaseFirestore.instance
                            .collection('user')
                            .where('password',
                                isEqualTo: passwordController.text)
                            .get()
                            .then((value) {
                          if (value.docs.isNotEmpty) {
                            password = true;
                            exist = true;
                          } else {
                            password = false;
                          }
                        });
                      } else {
                        email = false;
                      }
                    });

                    if (!email) {
                      return ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Email is invalid / not found!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }

                    if (!password) {
                      return ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Password is invalid!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }

                    if (exist) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Login successfull! Please wait...'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      await AuthService.signIn(
                          emailController.text, passwordController.text);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MainPage();
                          },
                        ),
                      );
                    }
                  },
                  child: Text('Login')),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RegisterPage();
                        },
                      ),
                    );
                  },
                  child: Text('Register')),
            ],
          ),
        ),
      ),
    );
  }
}
