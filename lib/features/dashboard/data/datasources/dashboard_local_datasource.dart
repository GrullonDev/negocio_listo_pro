import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/features/dashboard/data/models/transaction_model.dart';

abstract class DashboardLocalDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<void> addTransaction(TransactionModel transaction);
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final Isar isar;

  const DashboardLocalDataSourceImpl(this.isar);

  @override
  Future<List<TransactionModel>> getTransactions() {
    return isar.transactionModels.where().sortByDateDesc().findAll();
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await isar.writeTxn(() async {
      await isar.transactionModels.put(transaction);
    });
  }
}
