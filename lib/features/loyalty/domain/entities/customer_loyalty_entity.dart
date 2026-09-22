enum LoyaltyTier { bronze, silver, gold, platinum }

class CustomerLoyaltyEntity {
  final String id;
  final String name;
  final String phone;
  final int points;
  final LoyaltyTier tier;
  final List<DateTime> visitHistory;

  const CustomerLoyaltyEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.points,
    required this.tier,
    required this.visitHistory,
  });

  CustomerLoyaltyEntity copyWith({
    int? points,
    LoyaltyTier? tier,
    List<DateTime>? visitHistory,
  }) {
    return CustomerLoyaltyEntity(
      id: id,
      name: name,
      phone: phone,
      points: points ?? this.points,
      tier: tier ?? this.tier,
      visitHistory: visitHistory ?? this.visitHistory,
    );
  }
}
