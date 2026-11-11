class BrandEntity {
  final String id;
  final String brandKey;
  final String displayName;
  final String tagline;
  final String primaryColor;
  final String secondaryColor;
  final String backgroundColor;
  final String currencyCode;
  final String currencySymbol;
  final bool isActive;

  const BrandEntity({
    required this.id,
    required this.brandKey,
    required this.displayName,
    required this.tagline,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.currencyCode,
    required this.currencySymbol,
    required this.isActive,
  });
}
