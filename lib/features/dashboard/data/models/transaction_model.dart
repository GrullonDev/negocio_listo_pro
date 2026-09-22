import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/features/dashboard/domain/entities/transaction_entity.dart';

part 'transaction_model.g.dart';

@collection
class TransactionModel {
  Id id = Isar.autoIncrement;

  late String transactionId;
  late String description;
  late double amount;

  @enumerated
  late TransactionType type;

  late DateTime date;

  TransactionModel();

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: transactionId,
      description: description,
      amount: amount,
      type: type,
      date: date,
    );
  }

  static TransactionModel fromEntity(TransactionEntity entity) {
    return TransactionModel()
      ..transactionId = entity.id
      ..description = entity.description
      ..amount = entity.amount
      ..type = entity.type
      ..date = entity.date;
  }
}
