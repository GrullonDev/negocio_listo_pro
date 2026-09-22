/// Represents the business ("negocio") the authenticated user is
/// currently operating as. Multi-tenant scoping flows through this entity.
class TenantEntity {
  final String id;
  final String name;
  final String subscriptionPlan;

  const TenantEntity({
    required this.id,
    required this.name,
    required this.subscriptionPlan,
  });
}
