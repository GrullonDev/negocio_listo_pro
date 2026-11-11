import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/auth/jwt_service.dart';
import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/common/request_helpers.dart';
import 'package:backend/src/coupons/coupon_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return jsonError('Método no permitido',
        statusCode: HttpStatus.methodNotAllowed);
  }

  final jwt = context.read<JwtPayload>();
  try {
    final body = await readJsonBody(context);
    final result = await context.read<CouponService>().redeem(
          tenantId: jwt.tenantId,
          code: requireString(body, 'code'),
          idempotencyKey: requireString(body, 'idempotency_key'),
          customerId: body['customer_id'] as String?,
        );

    final status = result['status'] as String;
    return switch (status) {
      'redeemed' || 'already_redeemed' => jsonOk(result),
      'not_found' => jsonNotFound('Cupón no encontrado'),
      'inactive' => jsonError('El cupón está inactivo'),
      'expired' => jsonError('El cupón ha expirado'),
      'exhausted' => jsonError('El cupón alcanzó su límite de usos'),
      _ => jsonError('Error desconocido'),
    };
  } on FormatException catch (e) {
    return jsonError(e.message);
  }
}
