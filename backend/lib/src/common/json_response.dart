import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Response jsonOk(Object? data, {int statusCode = HttpStatus.ok}) {
  return Response(
    statusCode: statusCode,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'ok': true, 'data': data}),
  );
}

Response jsonCreated(Object? data) {
  return jsonOk(data, statusCode: HttpStatus.created);
}

Response jsonError(
  String message, {
  int statusCode = HttpStatus.badRequest,
  Map<String, dynamic>? details,
}) {
  return Response(
    statusCode: statusCode,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'ok': false,
      'error': message,
      if (details != null) 'details': details,
    }),
  );
}

Response jsonNotFound([String message = 'Recurso no encontrado']) {
  return jsonError(message, statusCode: HttpStatus.notFound);
}

Response jsonUnauthorized([String message = 'No autorizado']) {
  return jsonError(message, statusCode: HttpStatus.unauthorized);
}

Response jsonForbidden([String message = 'Acceso denegado']) {
  return jsonError(message, statusCode: HttpStatus.forbidden);
}

Response jsonConflict([String message = 'Conflicto']) {
  return jsonError(message, statusCode: HttpStatus.conflict);
}
