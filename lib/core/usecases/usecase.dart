import 'package:dartz/dartz.dart';
import 'package:negocio_listo_pro/core/errors/failures.dart';

/// Contract for every use case: [Success] is the success payload,
/// [Params] the input. Keeps Domain agnostic of Bloc/UI/HTTP details.
abstract class UseCase<Success, Params> {
  Future<Either<Failure, Success>> call(Params params);
}

/// Marker for use cases that take no arguments.
class NoParams {
  const NoParams();
}
