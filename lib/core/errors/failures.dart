abstract class Failure {
  final String message;
  const Failure(this.message);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error en el almacenamiento local']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Sin conexión a internet']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error en el servidor']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Credenciales inválidas']);
}

class CouponNotFoundFailure extends Failure {
  const CouponNotFoundFailure([super.message = 'Cupón no encontrado']);
}

class CouponInactiveFailure extends Failure {
  const CouponInactiveFailure([super.message = 'El cupón está inactivo']);
}

class CouponExpiredFailure extends Failure {
  const CouponExpiredFailure([super.message = 'El cupón ha expirado']);
}

class CouponExhaustedFailure extends Failure {
  const CouponExhaustedFailure([
    super.message = 'El cupón alcanzó su límite de usos',
  ]);
}
