import 'package:dartz/dartz.dart';

import 'package:negocio_listo_pro/core/errors/failures.dart';
import 'package:negocio_listo_pro/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:negocio_listo_pro/features/dashboard/data/models/transaction_model.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/entities/financial_metrics_entity.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/entities/transaction_entity.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource localDataSource;

  const DashboardRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, FinancialMetricsEntity>> getMetrics() async {
    try {
      final models = await localDataSource.getTransactions();
      final transactions = models.map((model) => model.toEntity()).toList();

      var totalIncome = 0.0;
      var totalExpenses = 0.0;
      for (final transaction in transactions) {
        if (transaction.type == TransactionType.income) {
          totalIncome += transaction.amount;
        } else {
          totalExpenses += transaction.amount;
        }
      }

      return Right(
        FinancialMetricsEntity(
          totalIncome: totalIncome,
          totalExpenses: totalExpenses,
          orderCount: transactions.length,
          recentTransactions: transactions.take(10).toList(),
        ),
      );
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      await localDataSource.addTransaction(
        TransactionModel.fromEntity(transaction),
      );
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
