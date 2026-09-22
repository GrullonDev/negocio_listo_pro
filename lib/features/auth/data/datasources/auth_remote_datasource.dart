import 'package:dio/dio.dart';
import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  const AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return UserModel.fromJson(response.data!);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const AuthFailure();
      }
      throw const ServerFailure();
    }
  }
}
