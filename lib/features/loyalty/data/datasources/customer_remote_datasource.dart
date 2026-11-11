import 'package:negocio_listo_pro/core/network/api_client.dart';
import 'package:negocio_listo_pro/features/loyalty/data/models/customer_model.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';

abstract class CustomerRemoteDataSource {
  Future<List<CustomerModel>> getCustomers();
  Future<CustomerModel> addCustomer(CustomerModel customer);
  Future<CustomerModel> getCustomerById(String id);
  Future<CustomerModel> addPoints(String id, int points);
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final ApiClient apiClient;

  const CustomerRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<CustomerModel>> getCustomers() async {
    final response = await apiClient.get('/api/v1/customers');
    if (!response.isSuccess) throw Exception(response.errorMessage);

    final list = response.data!['data'] as List? ??
        (response.data is List ? response.data as List : []);
    return list.map(_fromJson).toList();
  }

  @override
  Future<CustomerModel> addCustomer(CustomerModel customer) async {
    final response = await apiClient.post(
      '/api/v1/customers',
      body: {
        'name': customer.name,
        'phone': customer.phone,
      },
    );
    if (!response.isSuccess) throw Exception(response.errorMessage);
    return customer;
  }

  @override
  Future<CustomerModel> getCustomerById(String id) async {
    final response = await apiClient.get('/api/v1/customers/$id');
    if (!response.isSuccess) throw Exception(response.errorMessage);
    return _fromJson(response.data!);
  }

  @override
  Future<CustomerModel> addPoints(String id, int points) async {
    final response = await apiClient.post(
      '/api/v1/customers/$id/points',
      body: {'points': points},
    );
    if (!response.isSuccess) throw Exception(response.errorMessage);
    return _fromJson(response.data!);
  }

  CustomerModel _fromJson(dynamic item) {
    final json = item as Map<String, dynamic>;
    return CustomerModel()
      ..customerId = json['id'] as String
      ..name = json['name'] as String
      ..phone = json['phone'] as String
      ..points = json['points'] as int? ?? 0
      ..tier = LoyaltyTier.values.firstWhere(
        (t) => t.name == json['tier'],
        orElse: () => LoyaltyTier.bronze,
      )
      ..visitHistory = [];
  }
}
