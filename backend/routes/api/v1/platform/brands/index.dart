import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/common/json_response.dart';
import 'package:backend/src/platform/platform_jwt.dart';
import 'package:backend/src/platform/platform_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final jwt = context.read<PlatformJwtPayload>();
  final service = context.read<PlatformService>();

  if (context.request.method == HttpMethod.get) {
    final brands = await service.listBrands();
    return jsonOk(brands);
  }

  if (context.request.method == HttpMethod.post) {
    final body = await context.request.json() as Map<String, dynamic>;
    final brandKey = body['brand_key'] as String?;
    final displayName = body['display_name'] as String?;

    if (brandKey == null || displayName == null) {
      return jsonError('brand_key y display_name son requeridos');
    }

    final result = await service.createBrand(
      brandKey: brandKey,
      displayName: displayName,
      tagline: body['tagline'] as String? ?? '',
      primaryColor: body['primary_color'] as String? ?? '#00236F',
      secondaryColor: body['secondary_color'] as String? ?? '#006C49',
      backgroundColor: body['background_color'] as String? ?? '#FFFFFF',
      currencyCode: body['currency_code'] as String? ?? 'GTQ',
      currencySymbol: body['currency_symbol'] as String? ?? 'Q',
      actorId: jwt.userId,
    );
    return jsonCreated(result);
  }

  return jsonError('Método no permitido',
      statusCode: HttpStatus.methodNotAllowed);
}
