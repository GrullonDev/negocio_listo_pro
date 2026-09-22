/// Whether a [TransactionEntity] adds to income or subtracts as an expense.
enum TransactionType { income, expense }

/// A single local financial movement (sale, payment, order, expense, etc.)
/// registered by the tenant. Framework-free.
class TransactionEntity {
  final String id;
  final String description;
  final double amount;
  final TransactionType type;
  final DateTime date;

  const TransactionEntity({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
  });
}
