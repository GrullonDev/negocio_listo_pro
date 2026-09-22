import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/core/di/injection_container.dart';
import 'package:negocio_listo_pro/core/theme/app_theme.dart';
import 'package:negocio_listo_pro/features/auth/domain/entities/user_entity.dart';
import 'package:negocio_listo_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:negocio_listo_pro/features/auth/presentation/bloc/auth_event.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/bloc/booking_event.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/pages/bookings_page.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/widgets/add_booking_bottom_sheet.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_bloc.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/bloc/coupon_event.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/pages/coupons_page.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/widgets/create_coupon_bottom_sheet.dart';
import 'package:negocio_listo_pro/features/coupons/presentation/widgets/redeem_coupon_dialog.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:negocio_listo_pro/features/dashboard/presentation/widgets/add_transaction_bottom_sheet.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_bloc.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/bloc/loyalty_event.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/pages/loyalty_page.dart';
import 'package:negocio_listo_pro/features/loyalty/presentation/widgets/add_customer_bottom_sheet.dart';

class _NavTab {
  final String label;
  final IconData icon;
  final String title;

  const _NavTab({required this.label, required this.icon, required this.title});
}

const _tabs = [
  _NavTab(label: 'Dashboard', icon: Icons.dashboard, title: 'Dashboard Financiero'),
  _NavTab(label: 'Citas', icon: Icons.event_note, title: 'Citas y Pedidos'),
  _NavTab(label: 'Clientes', icon: Icons.people, title: 'Clientes Fidelizados'),
  _NavTab(label: 'Cupones', icon: Icons.local_offer, title: 'Cupones de Descuento'),
];

class HomePage extends StatefulWidget {
  final UserEntity user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late final DashboardBloc _dashboardBloc;
  late final BookingBloc _bookingBloc;
  late final LoyaltyBloc _loyaltyBloc;
  late final CouponBloc _couponBloc;

  @override
  void initState() {
    super.initState();
    _dashboardBloc = sl<DashboardBloc>()..add(const LoadDashboardMetrics());
    _bookingBloc = sl<BookingBloc>()..add(const LoadBookings());
    _loyaltyBloc = sl<LoyaltyBloc>()..add(const LoadCustomers());
    _couponBloc = sl<CouponBloc>()..add(const LoadCoupons());
  }

  @override
  void dispose() {
    _dashboardBloc.close();
    _bookingBloc.close();
    _loyaltyBloc.close();
    _couponBloc.close();
    super.dispose();
  }

  void _onAddPressed(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        AddTransactionBottomSheet.show(context);
      case 1:
        AddBookingBottomSheet.show(context);
      case 2:
        AddCustomerBottomSheet.show(context);
      case 3:
        CreateCouponBottomSheet.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _dashboardBloc),
        BlocProvider.value(value: _bookingBloc),
        BlocProvider.value(value: _loyaltyBloc),
        BlocProvider.value(value: _couponBloc),
      ],
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(_tabs[_currentIndex].title),
            actions: [
              if (_currentIndex == 3)
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  tooltip: 'Canjear cupón',
                  onPressed: () => RedeemCouponDialog.show(context),
                ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () =>
                    context.read<AuthBloc>().add(const AuthLogoutRequested()),
              ),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: const [
              DashboardPage(),
              BookingsPage(),
              LoyaltyPage(),
              CouponsPage(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _onAddPressed(context),
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(index: 0),
                _navItem(index: 1),
                const SizedBox(width: 48),
                _navItem(index: 2),
                _navItem(index: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem({required int index}) {
    final tab = _tabs[index];
    final selected = _currentIndex == index;
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.primary : AppColors.mutedText;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tab.icon, color: color),
              const SizedBox(height: 2),
              Text(
                tab.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
