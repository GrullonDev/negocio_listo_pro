import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

Future<Map<String, dynamic>> readJsonBody(RequestContext context) async {
  final body = await context.request.body();
  if (body.isEmpty) {
    throw const FormatException('Request body is empty');
  }
  final decoded = jsonDecode(body);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Request body must be a JSON object');
  }
  return decoded;
}

String requireString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null || value is! String || value.trim().isEmpty) {
    throw FormatException('Campo requerido: $key');
  }
  return value.trim();
}

double requireDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) throw FormatException('Campo requerido: $key');
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value);
    if (parsed != null) return parsed;
  }
  throw FormatException('Campo $key debe ser numérico');
}

int requireInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) throw FormatException('Campo requerido: $key');
  if (value is int) return value;
  if (value is String) {
    final parsed = int.tryParse(value);
    if (parsed != null) return parsed;
  }
  throw FormatException('Campo $key debe ser entero');
}

DateTime requireDateTime(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null || value is! String) {
    throw FormatException('Campo requerido: $key (formato ISO 8601)');
  }
  final parsed = DateTime.tryParse(value);
  if (parsed == null) {
    throw FormatException('Campo $key debe ser una fecha ISO 8601 válida');
  }
  return parsed.toUtc();
}
