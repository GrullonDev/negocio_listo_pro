import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/platform/platform_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return jsonError('Método no permitido',
        statusCode: HttpStatus.methodNotAllowed);
  }

  final service = context.read<PlatformService>();
  final data = await service.getDashboard();
  return jsonOk(data);
}
