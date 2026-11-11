import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:negocio_listo_pro/core/network/api_client.dart';

class PlatformRemoteDataSource {
  final http.Client _client;
  String? _accessToken;

  PlatformRemoteDataSource({http.Client? client})
      : _client = client ?? http.Client();

  String get _baseUrl => ApiClient.baseUrl;

  void clearToken() => _accessToken = null;

  Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  Future<Map<String, dynamic>> _parseResponse(http.Response response) async {
    final body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body['data'] as Map<String, dynamic>? ?? body;
    }
    throw HttpException(
        body['error'] as String? ?? 'Error ${response.statusCode}');
  }

  Future<List<Map<String, dynamic>>> _parseListResponse(
      http.Response response) async {
    final body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = body['data'];
      if (data is List) return data.cast<Map<String, dynamic>>();
      return [];
    }
    throw HttpException(
        body['error'] as String? ?? 'Error ${response.statusCode}');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _client.post(
      _uri('/api/v1/platform/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = await _parseResponse(response);
    _accessToken = data['access_token'] as String?;
    return data;
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await _client.get(
      _uri('/api/v1/platform/me'),
      headers: _headers(),
    );
    return _parseResponse(response);
  }

  Future<void> changePassword(String current, String newPass) async {
    final response = await _client.patch(
      _uri('/api/v1/platform/me/password'),
      headers: _headers(),
      body: jsonEncode(
          {'current_password': current, 'new_password': newPass}),
    );
    await _parseResponse(response);
  }

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _client.get(
      _uri('/api/v1/platform/dashboard'),
      headers: _headers(),
    );
    return _parseResponse(response);
  }

  Future<List<Map<String, dynamic>>> listTenants() async {
    final response = await _client.get(
      _uri('/api/v1/platform/tenants'),
      headers: _headers(),
    );
    return _parseListResponse(response);
  }

  Future<Map<String, dynamic>> createTenant(Map<String, dynamic> data) async {
    final response = await _client.post(
      _uri('/api/v1/platform/tenants'),
      headers: _headers(),
      body: jsonEncode(data),
    );
    return _parseResponse(response);
  }

  Future<void> updateTenant(String id, Map<String, dynamic> fields) async {
    final response = await _client.patch(
      _uri('/api/v1/platform/tenants/$id'),
      headers: _headers(),
      body: jsonEncode(fields),
    );
    await _parseResponse(response);
  }

  Future<List<Map<String, dynamic>>> listBrands() async {
    final response = await _client.get(
      _uri('/api/v1/platform/brands'),
      headers: _headers(),
    );
    return _parseListResponse(response);
  }

  Future<Map<String, dynamic>> createBrand(Map<String, dynamic> data) async {
    final response = await _client.post(
      _uri('/api/v1/platform/brands'),
      headers: _headers(),
      body: jsonEncode(data),
    );
    return _parseResponse(response);
  }

  Future<void> updateBrand(String id, Map<String, dynamic> fields) async {
    final response = await _client.patch(
      _uri('/api/v1/platform/brands/$id'),
      headers: _headers(),
      body: jsonEncode(fields),
    );
    await _parseResponse(response);
  }
}
