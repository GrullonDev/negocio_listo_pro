import 'package:dbcrypt/dbcrypt.dart';

class PasswordService {
  PasswordService._();

  static String hash(String password) {
    return DBCrypt().hashpw(password, DBCrypt().gensalt());
  }

  static bool verify(String password, String hashed) {
    return DBCrypt().checkpw(password, hashed);
  }
}
