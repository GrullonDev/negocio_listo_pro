import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/platform/platform_jwt.dart';
import 'package:backend/src/platform/platform_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final jwt = context.read<PlatformJwtPayload>();
  final service = context.read<PlatformService>();

  if (context.request.method == HttpMethod.get) {
    final params = context.request.uri.queryParameters;
    final limit = int.tryParse(params['limit'] ?? '') ?? 25;
    final offset = int.tryParse(params['offset'] ?? '') ?? 0;
    final tenants = await service.listTenants(limit: limit, offset: offset);
    return jsonOk(tenants);
  }

  if (context.request.method == HttpMethod.post) {
    final body = await context.request.json() as Map<String, dynamic>;
    final name = body['name'] as String?;
    final ownerName = body['owner_name'] as String?;
    final ownerEmail = body['owner_email'] as String?;

    if (name == null || ownerName == null || ownerEmail == null) {
      return jsonError('name, owner_name y owner_email son requeridos');
    }

    final result = await service.createTenant(
      name: name,
      businessType: body['business_type'] as String? ?? 'general',
      currencyCode: body['currency_code'] as String? ?? 'GTQ',
      brandId: body['brand_id'] as String?,
      ownerName: ownerName,
      ownerEmail: ownerEmail,
      actorId: jwt.userId,
    );
    return jsonCreated(result);
  }

  return jsonError('Método no permitido',
      statusCode: HttpStatus.methodNotAllowed);
}
