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
    final result = await context.read<AuthService>().registerBusiness(
          businessName: requireString(body, 'business_name'),
          businessType: body['business_type'] as String? ?? 'general',
          currencyCode: body['currency_code'] as String? ?? 'DOP',
          ownerName: requireString(body, 'owner_name'),
          email: requireString(body, 'email'),
          password: requireString(body, 'password'),
        );
    return jsonCreated(result);
  } on FormatException catch (e) {
    return jsonError(e.message);
  } catch (e) {
    if (e.toString().contains('unique') || e.toString().contains('duplicate')) {
      return jsonConflict('El email ya está registrado');
    }
    return jsonError('Error interno', statusCode: HttpStatus.internalServerError);
  }
}
