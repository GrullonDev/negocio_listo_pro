class TenantSummaryEntity {
  final String id;
  final String name;
  final String businessType;
  final String currencyCode;
  final String status;
  final String? brandName;
  final DateTime createdAt;

  const TenantSummaryEntity({
    required this.id,
    required this.name,
    required this.businessType,
    required this.currencyCode,
    required this.status,
    this.brandName,
    required this.createdAt,
  });
}
