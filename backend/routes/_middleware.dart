import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import 'package:backend/src/auth/auth_service.dart';
import 'package:backend/src/bookings/booking_service.dart';
import 'package:backend/src/coupons/coupon_service.dart';
import 'package:backend/src/customers/customer_service.dart';
import 'package:backend/src/transactions/transaction_service.dart';

Handler middleware(Handler handler) {
  return handler
      .use(_loggerMiddleware())
      .use(_corsMiddleware())
      .use(provider<AuthService>((_) => const AuthService()))
      .use(provider<TransactionService>((_) => const TransactionService()))
      .use(provider<BookingService>((_) => const BookingService()))
      .use(provider<CustomerService>((_) => const CustomerService()))
      .use(provider<CouponService>((_) => const CouponService()));
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
