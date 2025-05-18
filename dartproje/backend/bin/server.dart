import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:dotenv/dotenv.dart';

import 'db.dart';
import 'user_routes.dart';
import 'data_routes.dart';

void main() async {
  final env = DotEnv()..load();
  env.load();

  print('JWT_TOKEN = ${env['JWT_TOKEN']}');

  await connectToDatabase();

  final router = Router();
  router.mount('/user/', getUserRoutes());
  router.mount('/data/', getDataRoutes());

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router);

  final server = await io.serve(handler, '0.0.0.0', 7000);
  print(' Backend başlatıldı: http://${server.address.host}:${server.port}');
}
