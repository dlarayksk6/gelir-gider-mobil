import 'package:mongo_dart/mongo_dart.dart';

Future<Db> connectToDatabase() async {
  final db = Db('mongodb://localhost:27017/gelirgidervt');
  await db.open();
  print('MongoDB başarılı');
  return db;
}
