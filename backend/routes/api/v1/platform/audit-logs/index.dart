import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/platform/platform_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return jsonError('Método no permitido',
        statusCode: HttpStatus.methodNotAllowed);
  }

  final params = context.request.uri.queryParameters;
  final limit = int.tryParse(params['limit'] ?? '') ?? 50;
  final offset = int.tryParse(params['offset'] ?? '') ?? 0;

  final service = context.read<PlatformService>();
  final logs = await service.listAuditLogs(limit: limit, offset: offset);
  return jsonOk(logs);
}
