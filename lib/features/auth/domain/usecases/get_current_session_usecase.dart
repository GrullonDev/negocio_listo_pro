import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/auth/domain/entities/user_entity.dart';
import 'package:negocio_listo_pro/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentSessionUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  const GetCurrentSessionUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return repository.getCurrentSession();
  }
}
