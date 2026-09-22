import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}
