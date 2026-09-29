import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/core/branding/brand_config.dart';
import 'package:negocio_listo_pro/core/di/injection_container.dart';
import 'package:negocio_listo_pro/core/theme/app_theme.dart';
import 'package:negocio_listo_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:negocio_listo_pro/features/auth/presentation/bloc/auth_event.dart';
import 'package:negocio_listo_pro/features/auth/presentation/bloc/auth_state.dart';
import 'package:negocio_listo_pro/features/auth/presentation/pages/home_page.dart';
import 'package:negocio_listo_pro/core/theme/responsive.dart';
import 'package:negocio_listo_pro/features/auth/presentation/pages/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(const AuthSessionRequested()),
      child: MaterialApp(
        title: BrandConfig.current.businessName,
        theme: AppTheme.forBrand(BrandConfig.current),
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          return MediaQuery(
            data: mq.copyWith(
              textScaler: mq.textScaler.clamp(
                minScaleFactor: TextScaleLimits.min,
                maxScaleFactor: TextScaleLimits.max,
              ),
            ),
            child: child!,
          );
        },
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return HomePage(user: state.user);
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
