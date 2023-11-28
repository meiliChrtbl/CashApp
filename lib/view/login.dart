import 'package:flutter/material.dart';
import 'package:uasapp/controller/databaseHelper.dart';
import 'package:uasapp/model/member.dart';
import 'package:uasapp/view/homeScreen.dart';
import 'package:uasapp/view/signin.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                logIn(context);
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate to the sign-in page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              child: Text("Tidak Punya Akun?"),
            ),
          ],
        ),
      ),
    );
  }

  // void logIn(BuildContext context) async {
  //   Map<String, dynamic> credentials = {
  //     'email': emailController.text,
  //     'password': passwordController.text,
  //   };

  //   Member? loggedInMember = await dbHelper.logIn(credentials);

  //   if (loggedInMember != null) {
  //     print('Login successful');
  //   } else {
  //     print('Login failed');
  //   }
  // }
  void logIn(BuildContext context) async {
    Map<String, dynamic> user = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    Member? loggedInUser = await dbHelper.logIn(user);

    if (loggedInUser != null) {
      // Login successful
      print('Login successful for user: ${loggedInUser.nama}');
      // Add navigation or other actions after successful login
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
    } else {
      // Login failed
      print('Login failed. Check email and password.');
    }
  }
}
