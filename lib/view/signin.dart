import 'package:flutter/material.dart';
import 'package:uasapp/controller/databaseHelper.dart';
import 'package:uasapp/model/member.dart';
import 'package:uasapp/view/login.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nikController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: nikController,
              decoration: InputDecoration(labelText: 'NIK KTP'),
            ),
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
                saveUser(context);
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  void saveUser(BuildContext context) async {
  Map<String, dynamic> user = {
    'nama': nameController.text,
    'nik': nikController.text,
    'email': emailController.text,
    'password': passwordController.text,
  };

  Member? loggedInMember = await dbHelper.saveUser(user);

  if (loggedInMember != null) {
    // User berhasil disimpan
    print('User berhasil disimpan');
    // Tambahkan navigasi atau tindakan lainnya setelah sign in
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), 
    );
  } else {
    // Gagal menyimpan user
    print('Gagal menyimpan user');
  }
}

}
