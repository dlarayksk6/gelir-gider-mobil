import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<String?> registerUser(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:7000/user/register');
    print("API çağrısı yapılıyor: $email");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        print("Kayıt başarılı.");
        return 'Kullanıcı başarıyla kaydedildi';
      } else {
        print("Sunucu hatası: ${response.statusCode} - ${response.body}");
        return 'Bir hata oluştu: ${response.body}';
      }
    } catch (e) {
      print("API hatası: $e");
      return 'Bir hata oluştu: $e';
    }
  }

  Future<String?> loginUser(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:7000/user/login');
    print("Giriş yapılıyor: $email");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        await saveToken(token);
        return 'Giriş başarılı: ${data['token']}';
      } else {
        return 'Giriş hatalı: ${response.body}';
      }
    } catch (e) {
      print('Hata: $e');
      return 'Bağlantı hatası';
    }
  }

  Future<String?> dataSave(
    String islem,
    double miktar,
    String kategori,
    String tarih,
    String aciklama,
    String fatura,
    String token,
  ) async {
    if (token.isEmpty) {
      return 'Token bulunamadı, lütfen tekrar giriş yapın.';
    }

    print("Kullanılan Token: $token");

    final url = Uri.parse('http://10.0.2.2:7000/data/save');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'islem': islem,
          'miktar': miktar,
          'kategori': kategori,
          'tarih': tarih,
          'aciklama': aciklama,
          'fatura': fatura,
        }),
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return 'Kayıt başarılı';
      } else {
        return 'Hata: ${response.body}';
      }
    } catch (e) {
      return 'Hata: $e';
    }
  }

  Future<List<dynamic>?> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) return null;

    final url = Uri.parse('http://10.0.2.2:7000/data/datalist');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Sunucu hatası: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }

  Future<List<dynamic>?> fetchUsers() async {
    final url = Uri.parse('http://10.0.2.2:7000/user/list');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Hata: ${response.body}');
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  deleteTransaction(tx) {}
}
