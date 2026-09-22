import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/core/di/injection_container.dart';
import 'package:negocio_listo_pro/features/auth/domain/entities/user_entity.dart';
import 'package:negocio_listo_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:negocio_listo_pro/features/auth/presentation/bloc/auth_event.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/bloc/booking_event.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/pages/bookings_page.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_bloc.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_event.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/pages/coupons_page.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_bloc.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_event.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/pages/loyalty_page.dart';

class HomePage extends StatelessWidget {
  final UserEntity user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.tenant.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutRequested()),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.dashboard),
              label: const Text('Ver Dashboard Financiero'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => sl<DashboardBloc>()
                      ..add(const LoadDashboardMetrics()),
                    child: const DashboardPage(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.event_note),
              label: const Text('Ver Citas y Pedidos'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) =>
                        sl<BookingBloc>()..add(const LoadBookings()),
                    child: const BookingsPage(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.loyalty),
              label: const Text('Clientes Fidelizados'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) =>
                        sl<LoyaltyBloc>()..add(const LoadCustomers()),
                    child: const LoyaltyPage(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.local_offer),
              label: const Text('Cupones de Descuento'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => sl<CouponBloc>()..add(const LoadCoupons()),
                    child: const CouponsPage(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
