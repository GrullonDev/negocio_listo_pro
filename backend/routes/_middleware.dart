import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/auth/auth_service.dart';
import 'package:backend/src/bookings/booking_service.dart';
import 'package:backend/src/config/env.dart';
import 'package:backend/src/coupons/coupon_service.dart';
import 'package:backend/src/customers/customer_service.dart';
import 'package:backend/src/database/database.dart';
import 'package:backend/src/platform/bootstrap_service.dart';
import 'package:backend/src/platform/platform_auth_service.dart';
import 'package:backend/src/platform/platform_service.dart';
import 'package:backend/src/transactions/transaction_service.dart';

bool _initialized = false;

Future<void> _ensureInitialized() async {
  if (_initialized) return;
  _initialized = true;
  Env.load();
  await Database.init();
  await const BootstrapService().run();
}

Handler middleware(Handler handler) {
  return handler
      .use(_initMiddleware())
      .use(_loggerMiddleware())
      .use(_corsMiddleware())
      .use(provider<AuthService>((_) => const AuthService()))
      .use(provider<PlatformAuthService>((_) => const PlatformAuthService()))
      .use(provider<PlatformService>((_) => const PlatformService()))
      .use(provider<TransactionService>((_) => const TransactionService()))
      .use(provider<BookingService>((_) => const BookingService()))
      .use(provider<CustomerService>((_) => const CustomerService()))
      .use(provider<CouponService>((_) => const CouponService()));
}

Middleware _initMiddleware() {
  return (handler) {
    return (context) async {
      await _ensureInitialized();
      return handler(context);
    };
  };
}

Middleware _loggerMiddleware() {
  return (handler) {
    return (context) async {
      final request = context.request;
      final sw = Stopwatch()..start();
      final response = await handler(context);
      sw.stop();
      // ignore: avoid_print
      print(
        '${request.method.value.toUpperCase()} ${request.uri.path} '
        '→ ${response.statusCode} (${sw.elapsedMilliseconds}ms)',
      );
      return response;
    };
  };
}

Middleware _corsMiddleware() {
  return (handler) {
    return (context) async {
      if (context.request.method == HttpMethod.options) {
        return Response(
          statusCode: HttpStatus.noContent,
          headers: _corsHeaders,
        );
      }
      final response = await handler(context);
      return response.copyWith(
        headers: {...response.headers, ..._corsHeaders},
      );
    };
  };
}

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PATCH, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};
