class PlatformDashboardEntity {
  final int totalTenants;
  final int activeTenants;
  final int totalUsers;
  final int totalBrands;
  final List<AuditEntry> recentActivity;

  const PlatformDashboardEntity({
    required this.totalTenants,
    required this.activeTenants,
    required this.totalUsers,
    required this.totalBrands,
    required this.recentActivity,
  });
}

class AuditEntry {
  final String id;
  final String action;
  final String targetType;
  final String? targetId;
  final String actorName;
  final DateTime createdAt;

  const AuditEntry({
    required this.id,
    required this.action,
    required this.targetType,
    this.targetId,
    required this.actorName,
    required this.createdAt,
  });
}
