import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:negocio_listo_pro/core/network/network_info.dart';
import 'package:negocio_listo_pro/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:negocio_listo_pro/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:negocio_listo_pro/features/auth/data/models/user_model.dart';
import 'package:negocio_listo_pro/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:negocio_listo_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:negocio_listo_pro/features/auth/domain/usecases/get_current_session_usecase.dart';
import 'package:negocio_listo_pro/features/auth/domain/usecases/login_usecase.dart';
import 'package:negocio_listo_pro/features/auth/domain/usecases/logout_usecase.dart';
import 'package:negocio_listo_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:path_provider/path_provider.dart';

final GetIt sl = GetIt.instance;

/// Registers every dependency used by the app. Must run once, before
/// [runApp], so Isar's directory and the Dio base URL are ready.
Future<void> initDependencyInjection() async {
  final appDir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([UserModelSchema], directory: appDir.path);
  sl.registerSingleton<Isar>(isar);

  sl.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: 'https://api.negociolisto.pro')),
  );
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentSessionUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      getCurrentSessionUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );
}
