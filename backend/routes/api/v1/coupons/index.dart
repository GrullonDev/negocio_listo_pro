import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/auth/jwt_service.dart';
import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/common/request_helpers.dart';
import 'package:backend/src/coupons/coupon_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final jwt = context.read<JwtPayload>();
  final service = context.read<CouponService>();

  switch (context.request.method) {
    case HttpMethod.get:
      final data = await service.list(tenantId: jwt.tenantId);
      return jsonOk(data);

    case HttpMethod.post:
      try {
        final body = await readJsonBody(context);
        final result = await service.create(
          tenantId: jwt.tenantId,
          code: requireString(body, 'code'),
          discountType: requireString(body, 'discount_type'),
          value: requireDouble(body, 'value'),
          maxUses: requireInt(body, 'max_uses'),
          expirationDate: requireDateTime(body, 'expiration_date'),
        );
        return jsonCreated(result);
      } on FormatException catch (e) {
        return jsonError(e.message);
      }

    default:
      return jsonError('Método no permitido',
          statusCode: HttpStatus.methodNotAllowed);
  }
}
