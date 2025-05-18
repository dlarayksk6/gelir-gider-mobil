import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gelirgiderproje/api_service.dart';
import 'package:gelirgiderproje/screens/forgetpasswordscreen.dart';
import 'package:gelirgiderproje/screens/homescreen.dart';
import 'package:gelirgiderproje/screens/registerscreen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  void _login() async {
    print("Login butonuna basıldı");

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lütfen e-posta ve şifre girin')));
      return;
    }

    print("Form doğrulandı, giriş isteği gönderiliyor");

    final result = await _apiService.loginUser(email, password);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result ?? 'Bir hata oluştu')));

    if (result != null && result.contains('Giriş başarılı')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GİRİŞ YAP'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 150.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-posta',
                hintText: 'E-posta adresinizi girin',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Şifre',
                hintText: 'Şifrenizi girin',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _login,
              child: Text('GİRİŞ YAP'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text.rich(
                TextSpan(
                  text: 'Üye değil misiniz? ',
                  style: TextStyle(fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'Üye olun',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => ForgetPasswordScreen(),
                  ),
                );
              },
              child: Text.rich(
                TextSpan(
                  text: 'Şifrenizi mi unuttunuz? ',
                  style: TextStyle(fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'Şifrenizi sıfırlayın',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
