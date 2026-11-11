import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/common/json_response.dart';

Response onRequest(RequestContext context) {
  return jsonOk({'status': 'ok', 'timestamp': DateTime.now().toUtc().toIso8601String()});
}
