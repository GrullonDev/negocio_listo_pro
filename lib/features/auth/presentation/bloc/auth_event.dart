abstract class AuthEvent {
  const AuthEvent();
}

/// Dispatched on app start to restore an offline-first session if present.
class AuthSessionRequested extends AuthEvent {
  const AuthSessionRequested();
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
