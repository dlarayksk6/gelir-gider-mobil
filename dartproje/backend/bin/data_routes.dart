import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'db.dart';

Router getDataRoutes() {
  final router = Router();

  router.post('/save', (Request request) async {
    final authHeader = request.headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.forbidden('Token eksik veya hatalı');
    }

    final token = authHeader.substring(7);
    final secretKey = 'JWT_TOKEN';
    JWT? jwt;

    try {
      jwt = JWT.verify(token, SecretKey(secretKey));
      final userId = jwt.payload['id'];
      if (userId == null) {
        return Response.forbidden('Token içinde kullanıcı ID bulunamadı.');
      }
    } catch (e) {
      print('JWT doğrulama hatası: $e');
      print('Gelen Token: $token');
      return Response.forbidden('Geçersiz token1: $e');
    }

    final userId = jwt.payload['id'];

    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    final islem = data['islem'];
    final miktar = data['miktar'];
    final kategori = data['kategori'];
    final tarih = data['tarih'];
    final aciklama = data['aciklama'];
    final fatura = data['fatura'];

    if (miktar == null) {
      return Response.badRequest(body: 'Miktar giriniz.');
    }

    final db = await connectToDatabase();
    final collection = db.collection('data');

    await collection.insertOne({
      'userId': userId,
      'islem': islem,
      'miktar': miktar,
      'kategori': kategori,
      'tarih': tarih,
      'aciklama': aciklama,
      'fatura': fatura,
    });

    return Response.ok("Kayıt başarılı");
  });

  router.get('/datalist', (Request request) async {
    final authHeader = request.headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.forbidden('Token eksik veya hatalı');
    }

    final token = authHeader.substring(7);
    final secretKey = 'JWT_TOKEN';
    JWT? jwt;

    try {
      jwt = JWT.verify(token, SecretKey(secretKey));
    } catch (e) {
      print('JWT doğrulama hatası: $e');
      return Response.forbidden('Geçersiz token2: $e');
    }

    final userId = jwt.payload['id'];

    final db = await connectToDatabase();
    final collection = db.collection('data');

    final userData = await collection.find({'userId': userId}).toList();

    return Response.ok(jsonEncode(userData),
        headers: {'Content-Type': 'application/json'});
  });

  return router;
}
