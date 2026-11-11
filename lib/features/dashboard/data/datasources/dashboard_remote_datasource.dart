import 'package:negocio_listo_pro/core/network/api_client.dart';
import 'package:negocio_listo_pro/features/dashboard/data/models/transaction_model.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/entities/transaction_entity.dart';

abstract class DashboardRemoteDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<TransactionModel> addTransaction(TransactionModel transaction);
  Future<Map<String, dynamic>> getSummary();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;

  const DashboardRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final response = await apiClient.get('/api/v1/transactions');
    if (!response.isSuccess) throw Exception(response.errorMessage);

    final list = response.data!['data'] as List? ??
        (response.data is List ? response.data as List : []);
    return list.map((item) {
      final json = item as Map<String, dynamic>;
      return TransactionModel()
        ..transactionId = json['id'] as String
        ..description = json['description'] as String
        ..amount = double.parse(json['amount'].toString())
        ..type = json['type'] == 'income'
            ? TransactionType.income
            : TransactionType.expense
        ..date = DateTime.parse(json['occurred_at'] as String);
    }).toList();
  }

  @override
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    final response = await apiClient.post(
      '/api/v1/transactions',
      body: {
        'description': transaction.description,
        'amount': transaction.amount,
        'type': transaction.type == TransactionType.income
            ? 'income'
            : 'expense',
        'occurred_at': transaction.date.toUtc().toIso8601String(),
      },
    );
    if (!response.isSuccess) throw Exception(response.errorMessage);
    return transaction;
  }

  @override
  Future<Map<String, dynamic>> getSummary() async {
    final response = await apiClient.get('/api/v1/dashboard/summary');
    if (!response.isSuccess) throw Exception(response.errorMessage);
    return response.data!;
  }
}
