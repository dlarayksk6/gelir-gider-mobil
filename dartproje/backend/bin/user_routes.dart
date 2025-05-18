import 'dart:convert';
import 'package:dotenv/dotenv.dart';
import 'package:shelf/shelf.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf_router/shelf_router.dart';
import 'db.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

Router getUserRoutes() {
  final router = Router();

  router.post('/register', (Request request) async {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    final email = data['email'];
    final password = data['password'];

    if (email == null || password == null) {
      return Response.badRequest(body: 'Email veya şifre eksik');
    }

    final db = await connectToDatabase();
    final collection = db.collection('users');

    await collection.insertOne({
      'email': email,
      'password': password,
    });

    return Response.ok('Kullanıcı başarıyla kaydedildi');
  });

  router.post('/login', (Request request) async {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    final email = data['email'];
    final password = data['password'];

    if (email == null || password == null) {
      return Response.badRequest(body: 'Email veya şifre eksik');
    }

    final db = await connectToDatabase();
    final collection = db.collection('users');

    final user = await collection.findOne({
      'email': email,
      'password': password,
    });

    if (user == null) {
      return Response.notFound('Kullanıcı bulunamadı');
    }

    final token = generateJwt(user);

    return Response.ok(
      jsonEncode({'token': token}),
      headers: {'Content-Type': 'application/json'},
    );
  });

  router.get('/list', (Request request) async {
    final db = await connectToDatabase();
    final collection = db.collection('users');

    final users = await collection.find().toList();
    return Response.ok(jsonEncode(users),
        headers: {'Content-Type': 'application/json'});
  });

  return router;
}

String generateJwt(Map<String, dynamic> user) {
  final secret = 'JWT_TOKEN';
  if (secret == null) {
    throw Exception('JWT_TOKEN is not defined in the .env file');
  }

  final jwt = JWT({
    'email': user['email'],
    'id': user['_id'].toString(),
  });

  return jwt.sign(SecretKey(secret));
}
