import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/auth/auth_service.dart';
import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/common/request_helpers.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return jsonError('Método no permitido',
        statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await readJsonBody(context);
    final result = await context.read<AuthService>().login(
          email: requireString(body, 'email'),
          password: requireString(body, 'password'),
        );
    if (result.isEmpty) {
      return jsonUnauthorized('Credenciales inválidas');
    }
    return jsonOk(result);
  } on FormatException catch (e) {
    return jsonError(e.message);
  } catch (_) {
    return jsonError('Error interno', statusCode: HttpStatus.internalServerError);
  }
}
