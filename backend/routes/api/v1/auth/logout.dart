import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/common/json_response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return jsonError('Método no permitido',
        statusCode: HttpStatus.methodNotAllowed);
  }
  // Stateless JWT — client discards token. Server-side refresh token
  // revocation can be added later.
  return jsonOk({'message': 'Sesión cerrada'});
}
