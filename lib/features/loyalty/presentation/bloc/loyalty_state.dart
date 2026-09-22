import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';

abstract class LoyaltyState {
  const LoyaltyState();
}

class LoyaltyInitial extends LoyaltyState {
  const LoyaltyInitial();
}

class LoyaltyLoading extends LoyaltyState {
  const LoyaltyLoading();
}

class LoyaltyLoaded extends LoyaltyState {
  final List<CustomerLoyaltyEntity> customers;

  const LoyaltyLoaded(this.customers);
}

class LoyaltyError extends LoyaltyState {
  final String message;

  const LoyaltyError(this.message);
}
