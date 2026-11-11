import 'package:negocio_listo_pro/features/auth/domain/entities/user_entity.dart';

class SessionContext {
  UserEntity? _user;

  UserEntity? get user => _user;
  String? get tenantId => _user?.tenant.id;
  String? get userId => _user?.id;
  bool get isAuthenticated => _user != null;

  bool get isRemoteSession =>
      _user != null && !_user!.authToken.startsWith('local-');

  void setUser(UserEntity user) {
    _user = user;
  }

  void clear() {
    _user = null;
  }
}
