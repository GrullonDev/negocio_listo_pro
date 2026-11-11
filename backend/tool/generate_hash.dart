import 'package:dbcrypt/dbcrypt.dart';

void main() {
  final hash = DBCrypt().hashpw('demo1234', DBCrypt().gensalt());
  print(hash);
}
