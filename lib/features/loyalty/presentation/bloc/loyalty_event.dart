import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';

abstract class LoyaltyEvent {
  const LoyaltyEvent();
}

class LoadCustomers extends LoyaltyEvent {
  const LoadCustomers();
}

class AddCustomerRequested extends LoyaltyEvent {
  final CustomerLoyaltyEntity customer;

  const AddCustomerRequested(this.customer);
}

class AddPointsRequested extends LoyaltyEvent {
  final String customerId;
  final int points;

  const AddPointsRequested({required this.customerId, required this.points});
}
