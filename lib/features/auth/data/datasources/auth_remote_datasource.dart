import 'package:negocio_listo_pro/core/network/api_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });
  Future<Map<String, dynamic>> registerBusiness({
    required String businessName,
    required String ownerName,
    required String email,
    required String password,
  });
  Future<Map<String, dynamic>> getMe();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  const AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      '/api/v1/auth/login',
      body: {'email': email, 'password': password},
    );
    if (!response.isSuccess) throw Exception(response.errorMessage);

    final data = response.data!;
    await apiClient.saveTokens(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String?,
    );
    return data;
  }

  @override
  Future<Map<String, dynamic>> registerBusiness({
    required String businessName,
    required String ownerName,
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      '/api/v1/auth/register-business',
      body: {
        'business_name': businessName,
        'owner_name': ownerName,
        'email': email,
        'password': password,
      },
    );
    if (!response.isSuccess) throw Exception(response.errorMessage);

    final data = response.data!;
    await apiClient.saveTokens(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String?,
    );
    return data;
  }

  @override
  Future<Map<String, dynamic>> getMe() async {
    final response = await apiClient.get('/api/v1/auth/me');
    if (!response.isSuccess) throw Exception(response.errorMessage);
    return response.data!;
  }

  @override
  Future<void> logout() async {
    await apiClient.post('/api/v1/auth/logout');
    await apiClient.clearTokens();
  }
}
