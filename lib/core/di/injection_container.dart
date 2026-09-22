import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:negocio_listo_pro/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:negocio_listo_pro/features/auth/data/models/credential_model.dart';
import 'package:negocio_listo_pro/features/auth/data/models/tenant_model.dart';
import 'package:negocio_listo_pro/features/auth/data/models/user_model.dart';
import 'package:negocio_listo_pro/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:negocio_listo_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:negocio_listo_pro/features/auth/domain/usecases/get_current_session_usecase.dart';
import 'package:negocio_listo_pro/features/auth/domain/usecases/login_usecase.dart';
import 'package:negocio_listo_pro/features/auth/domain/usecases/logout_usecase.dart';
import 'package:negocio_listo_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:negocio_listo_pro/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:negocio_listo_pro/features/dashboard/data/models/transaction_model.dart';
import 'package:negocio_listo_pro/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/usecases/add_transaction_usecase.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/usecases/get_dashboard_metrics_usecase.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';

final GetIt sl = GetIt.instance;

/// Registers every dependency used by the app. Must run once, before
/// [runApp], so Isar's directory is ready and the demo credential exists.
Future<void> initDependencyInjection() async {
  final appDir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([
    UserModelSchema,
    CredentialModelSchema,
    TransactionModelSchema,
  ], directory: appDir.path);
  sl.registerSingleton<Isar>(isar);

  await _seedDemoCredentials(isar);

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
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

  sl.registerLazySingleton<DashboardLocalDataSource>(
    () => DashboardLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetDashboardMetricsUseCase(sl()));
  sl.registerLazySingleton(() => AddTransactionUseCase(sl()));

  sl.registerFactory(
    () => DashboardBloc(
      getDashboardMetricsUseCase: sl(),
      addTransactionUseCase: sl(),
    ),
  );
}

/// Ensures the offline demo accounts always exist so login works without
/// a manual seed step. Each entry is only inserted if its email is absent.
Future<void> _seedDemoCredentials(Isar isar) async {
  await _seedCredentialIfAbsent(
    isar,
    email: 'demo@negociolisto.pro',
    password: 'demo1234',
    userId: 'user-demo',
    displayName: 'Usuario Demo',
    tenantId: 'tenant-demo',
    tenantName: 'Negocio Demo',
  );
  await _seedCredentialIfAbsent(
    isar,
    email: 'test',
    password: 'test',
    userId: 'user-test',
    displayName: 'Usuario de Prueba',
    tenantId: 'tenant-test',
    tenantName: 'Negocio de Prueba',
  );
}

Future<void> _seedCredentialIfAbsent(
  Isar isar, {
  required String email,
  required String password,
  required String userId,
  required String displayName,
  required String tenantId,
  required String tenantName,
}) async {
  final existing = await isar.credentialModels
      .filter()
      .emailEqualTo(email, caseSensitive: false)
      .findFirst();
  if (existing != null) return;

  final tenant = TenantModel()
    ..tenantId = tenantId
    ..name = tenantName
    ..subscriptionPlan = 'free';

  final credential = CredentialModel()
    ..email = email
    ..passwordHash = hashPassword(password)
    ..userId = userId
    ..displayName = displayName
    ..tenant = tenant;

  await isar.writeTxn(() async {
    await isar.credentialModels.put(credential);
  });
}
