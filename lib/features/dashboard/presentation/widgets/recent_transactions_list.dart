import 'package:flutter/material.dart';

import 'package:negocio_listo_pro/core/branding/brand_config.dart';
import 'package:negocio_listo_pro/core/theme/app_theme.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/entities/transaction_entity.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const RecentTransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(
          child: Text(
            'Aún no hay movimientos registrados',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      itemCount: transactions.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final isIncome = transaction.type == TransactionType.income;
        final color = isIncome ? AppColors.success : theme.colorScheme.error;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withValues(alpha: 0.12),
                child: Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.sm + 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      _formatDate(transaction.date),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${isIncome ? '+' : '-'}${BrandConfig.current.formatMoney(transaction.amount)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
