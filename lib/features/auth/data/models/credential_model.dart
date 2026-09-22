import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/features/auth/data/models/tenant_model.dart';

part 'credential_model.g.dart';

/// Local credential record used to resolve [AuthLocalDataSource.login]
/// entirely on-device — this app never calls a remote auth server.
@collection
class CredentialModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, caseSensitive: false)
  late String email;

  late String passwordHash;
  late String userId;
  late String displayName;
  late TenantModel tenant;

  CredentialModel();
}

/// Non-cryptographic FNV-1a hash. Sufficient to avoid storing plaintext
/// passwords for this offline demo without pulling in a crypto package
/// (kept out of the established local-only stack).
String hashPassword(String password) {
  const int fnvPrime = 0x01000193;
  int hash = 0x811c9dc5;
  for (final byte in password.codeUnits) {
    hash ^= byte;
    hash = (hash * fnvPrime) & 0xFFFFFFFF;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}
