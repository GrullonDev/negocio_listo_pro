import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static const _baseUrlKey = 'API_BASE_URL';
  static const _defaultBaseUrl = 'http://10.0.2.2:8080';

  static const String baseUrl = String.fromEnvironment(
    _baseUrlKey,
    defaultValue: _defaultBaseUrl,
  );

  final http.Client _client;
  final FlutterSecureStorage _storage;

  ApiClient({http.Client? client, FlutterSecureStorage? storage})
    : _client = client ?? http.Client(),
      _storage = storage ?? const FlutterSecureStorage();

  Future<String?> get accessToken => _storage.read(key: 'access_token');

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: 'access_token', value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: 'refresh_token', value: refreshToken);
    }
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<Map<String, String>> _headers() async {
    final token = await accessToken;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<ApiResponse> get(String path) async {
    try {
      final response = await _client.get(_uri(path), headers: await _headers());
      return ApiResponse.fromHttp(response);
    } on SocketException {
      return ApiResponse.offline();
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse> post(String path, {Map<String, dynamic>? body}) async {
    try {
      final response = await _client.post(
        _uri(path),
        headers: await _headers(),
        body: body != null ? jsonEncode(body) : null,
      );
      return ApiResponse.fromHttp(response);
    } on SocketException {
      return ApiResponse.offline();
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse> patch(String path, {Map<String, dynamic>? body}) async {
    try {
      final response = await _client.patch(
        _uri(path),
        headers: await _headers(),
        body: body != null ? jsonEncode(body) : null,
      );
      return ApiResponse.fromHttp(response);
    } on SocketException {
      return ApiResponse.offline();
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}

class ApiResponse {
  final bool isSuccess;
  final bool isOffline;
  final int? statusCode;
  final Map<String, dynamic>? data;
  final String? errorMessage;

  const ApiResponse._({
    required this.isSuccess,
    this.isOffline = false,
    this.statusCode,
    this.data,
    this.errorMessage,
  });

  factory ApiResponse.fromHttp(http.Response response) {
    final body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};
    final ok = response.statusCode >= 200 && response.statusCode < 300;
    return ApiResponse._(
      isSuccess: ok,
      statusCode: response.statusCode,
      data: ok ? body['data'] as Map<String, dynamic>? ?? body : null,
      errorMessage: ok ? null : body['error'] as String? ?? 'Error desconocido',
    );
  }

  factory ApiResponse.offline() {
    return const ApiResponse._(
      isSuccess: false,
      isOffline: true,
      errorMessage: 'Sin conexión al servidor',
    );
  }

  factory ApiResponse.error(String message) {
    return ApiResponse._(isSuccess: false, errorMessage: message);
  }
}
