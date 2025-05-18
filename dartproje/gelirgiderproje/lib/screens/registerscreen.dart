import 'package:flutter/material.dart';
import 'package:gelirgiderproje/screens/loginscreen.dart';
import 'package:gelirgiderproje/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final ApiService _apiService = ApiService();

  void _register() async {
    print("Register butonuna basıldı");

    if (_formKey.currentState!.validate()) {
      print("Form doğrulandı, kayıt isteği gönderiliyor");

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Şifreler eşleşmiyor')));
        return;
      }

      final result = await _apiService.registerUser(email, password);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result ?? 'Bir hata oluştu')));

      if (result == 'Kullanıcı başarıyla kaydedildi') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KAYIT OL'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 150.0, horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  hintText: 'E-posta adresinizi girin',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen e-posta adresinizi girin';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Geçerli bir e-posta adresi girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  hintText: 'Şifrenizi girin',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir şifre girin';
                  }
                  if (value.length < 8) {
                    return 'Şifre en az 8 karakter olmalı';
                  }
                  if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                    return 'Şifre en az bir harf içermeli';
                  }
                  if (!RegExp(r'\d').hasMatch(value)) {
                    return 'Şifre en az bir rakam içermeli';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Şifreyi Tekrar Girin',
                  hintText: 'Şifrenizi tekrar girin',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen şifrenizi tekrar girin';
                  }
                  if (value != _passwordController.text) {
                    return 'Şifreler eşleşmiyor';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _register,
                child: Text('Kayıt Ol'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text.rich(
                  TextSpan(
                    text: 'Zaten bir hesabınız var mı? ',
                    style: TextStyle(fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'Giriş yapın',
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
      ),
    );
  }
}
