import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/helper/auth_service.dart';
import 'package:todo_app/helper/database_service.dart';
import 'package:todo_app/view/main_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool isLoading = false;
  bool validUsername = true;
  bool validEmail = true;
  bool validPassword = true;
  CollectionReference<Map<String, dynamic>> user =
      FirebaseFirestore.instance.collection('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          padding: EdgeInsets.only(left: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Color(0xff252525),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xffF5F5F5),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New\nAccount',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Register a new account',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: validUsername ? Colors.black : Colors.red,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                !validUsername
                    ? Text(
                        'Username already used!',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: validEmail ? Colors.black : Colors.red,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                !validEmail
                    ? Text(
                        'Email already used or invalid!',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: validPassword ? Colors.black : Colors.red,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                !validUsername
                    ? Text(
                        'Password must be more than 6 characters',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 32,
                ),
                GestureDetector(
                  onTap: () async {
                    String email = emailController.text;
                    String username = usernameController.text;
                    String password = passwordController.text;
                    validEmail = await DatabaseService.checkEmail(email);
                    validUsername =
                        await DatabaseService.checkUsername(username);
                    validPassword =
                        await DatabaseService.checkPassword(password);
                    setState(() {});

                    if (validUsername && validEmail && validPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Login succesfull. Please wait!',
                              textAlign: TextAlign.center),
                          backgroundColor: Colors.green,
                        ),
                      );
                      var userId = await AuthService.signUp(email, password);

                      await DatabaseService.registerUser(
                          userId.uid, username, email, password, context);

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
                  child: Container(
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xff252525),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
