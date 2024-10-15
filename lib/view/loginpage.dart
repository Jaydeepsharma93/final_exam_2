import 'package:final_exam_2/view/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/authcontroller.dart';
import 'homepage.dart';


class LoginPage extends StatelessWidget {
  final AuthController authController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              onPressed: () async {
                await authController.login(emailController.text, passwordController.text);
                if (authController.user.value != null) {
                  Get.offAll(() => HomePage());
                }
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => SignUpPage());
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}