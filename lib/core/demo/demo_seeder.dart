import 'package:isar_community/isar.dart';

import 'package:negocio_listo_pro/features/bookings/data/models/booking_model.dart';
import 'package:negocio_listo_pro/features/bookings/domain/entities/booking_entity.dart';
import 'package:negocio_listo_pro/features/coupons/data/models/coupon_model.dart';
import 'package:negocio_listo_pro/features/coupons/domain/entities/coupon_entity.dart';
import 'package:negocio_listo_pro/features/dashboard/data/models/transaction_model.dart';
import 'package:negocio_listo_pro/features/dashboard/domain/entities/transaction_entity.dart';
import 'package:negocio_listo_pro/features/loyalty/data/models/customer_model.dart';
import 'package:negocio_listo_pro/features/loyalty/domain/entities/customer_loyalty_entity.dart';

/// Pre-loads realistic data so a sales demo never opens on empty screens.
///
/// Every date is relative to [DateTime.now], so the agenda always shows
/// "today" and the dashboard always shows the last 30 days, no matter
/// when the demo runs.
///
/// Controlled with dart-defines:
/// * `DEMO_SEED=false` — never seed (production builds).
/// * `DEMO_RESET=true` — wipe business data and reseed on every launch,
///   so each rehearsal starts from the same state.
class DemoSeeder {
  static const _enabled = bool.fromEnvironment('DEMO_SEED', defaultValue: true);
  static const _reset = bool.fromEnvironment('DEMO_RESET');

  final Isar isar;
  final DateTime _now;

  DemoSeeder(this.isar, {DateTime? now}) : _now = now ?? DateTime.now();

  Future<void> run() async {
    if (!_enabled) return;
    if (_reset) await _clear();
    if (!await _isEmpty()) return;

    await isar.writeTxn(() async {
      await isar.transactionModels.putAll(_transactions());
      await isar.bookingModels.putAll(_bookings());
      await isar.customerModels.putAll(_customers());
      await isar.couponModels.putAll(_coupons());
    });
  }

  Future<bool> _isEmpty() async {
    return await isar.transactionModels.count() == 0 &&
        await isar.bookingModels.count() == 0 &&
        await isar.customerModels.count() == 0 &&
        await isar.couponModels.count() == 0;
  }

  Future<void> _clear() async {
    await isar.writeTxn(() async {
      await isar.transactionModels.clear();
      await isar.bookingModels.clear();
      await isar.customerModels.clear();
      await isar.couponModels.clear();
    });
  }

  DateTime _at(int dayOffset, int hour, [int minute = 0]) {
    final day = DateTime(_now.year, _now.month, _now.day);
    return day.add(Duration(days: dayOffset, hours: hour, minutes: minute));
  }

  // ---------------------------------------------------------------------
  // Finanzas: ~30 días de ventas y gastos con margen sano.
  // ---------------------------------------------------------------------

  static const _services = [
    ('Corte y peinado', 850.0),
    ('Tinte completo', 3500.0),
    ('Manicure y pedicure', 1200.0),
    ('Tratamiento de keratina', 4800.0),
    ('Corte de caballero', 600.0),
    ('Mechas / balayage', 5500.0),
    ('Venta de productos (shampoo + mascarilla)', 1450.0),
    ('Paquete novia (prueba)', 7500.0),
  ];

  static const _clients = [
    'María Fernández',
    'Carlos Rodríguez',
    'Ana Lucía Peña',
    'José Martínez',
    'Laura Jiménez',
    'Pedro Almonte',
    'Carmen Reyes',
    'Rosa Hernández',
    'Luis Batista',
    'Patricia Castillo',
    'Miguel Santana',
    'Gabriela Núñez',
  ];

  List<TransactionModel> _transactions() {
    final result = <TransactionModel>[];
    var seq = 0;

    TransactionModel tx(
      String description,
      double amount,
      TransactionType type,
      DateTime date,
    ) {
      return TransactionModel()
        ..transactionId = 'demo-tx-${seq++}'
        ..description = description
        ..amount = amount
        ..type = type
        ..date = date;
    }

    // Two to three sales per day over the last 30 days. Deterministic so
    // the totals are the same in every rehearsal.
    for (var day = 30; day >= 1; day--) {
      final salesToday = 2 + day % 2;
      for (var i = 0; i < salesToday; i++) {
        final (service, price) = _services[(day * 3 + i) % _services.length];
        final client = _clients[(day + i * 5) % _clients.length];
        result.add(
          tx(
            '$service — $client',
            price,
            TransactionType.income,
            _at(-day, 9 + i * 3, 15),
          ),
        );
      }
    }

    // Today's morning sales, so the feed opens with fresh activity.
    result.addAll([
      tx(
        'Tinte completo — María Fernández',
        3500,
        TransactionType.income,
        _at(0, 9, 40),
      ),
      tx(
        'Corte de caballero — Carlos Rodríguez',
        600,
        TransactionType.income,
        _at(0, 10, 20),
      ),
    ]);

    result.addAll([
      tx('Alquiler del local', 25000, TransactionType.expense, _at(-28, 8)),
      tx(
        'Compra de tintes y químicos',
        8200,
        TransactionType.expense,
        _at(-21, 11),
      ),
      tx('Factura de luz', 4300, TransactionType.expense, _at(-15, 10)),
      tx('Internet y teléfono', 2100, TransactionType.expense, _at(-14, 10)),
      tx('Productos de reventa', 6500, TransactionType.expense, _at(-7, 12)),
      tx('Toallas y desechables', 1800, TransactionType.expense, _at(-3, 16)),
    ]);

    return result;
  }

  // ---------------------------------------------------------------------
  // Agenda: hoy lleno con estados mezclados + resto de la semana.
  // ---------------------------------------------------------------------

  List<BookingModel> _bookings() {
    var seq = 0;
    BookingModel booking(
      String client,
      String service,
      DateTime date,
      BookingStatus status,
    ) {
      return BookingModel()
        ..bookingId = 'demo-bk-${seq++}'
        ..clientName = client
        ..service = service
        ..date = date
        ..status = status;
    }

    return [
      // Hoy: el presentador moverá "Por confirmar" → "Confirmada" en vivo.
      booking(
        'María Fernández',
        'Tinte completo',
        _at(0, 9),
        BookingStatus.completed,
      ),
      booking(
        'Carlos Rodríguez',
        'Corte de caballero',
        _at(0, 10),
        BookingStatus.completed,
      ),
      booking(
        'Ana Lucía Peña',
        'Manicure y pedicure',
        _at(0, 11, 30),
        BookingStatus.confirmed,
      ),
      booking(
        'Laura Jiménez',
        'Tratamiento de keratina',
        _at(0, 13),
        BookingStatus.confirmed,
      ),
      booking(
        'Carmen Reyes',
        'Mechas / balayage',
        _at(0, 15),
        BookingStatus.pending,
      ),
      booking(
        'Luis Batista',
        'Corte de caballero',
        _at(0, 16, 30),
        BookingStatus.pending,
      ),
      booking(
        'Gabriela Núñez',
        'Paquete novia (prueba)',
        _at(0, 18),
        BookingStatus.confirmed,
      ),
      // Resto de la semana.
      booking(
        'Rosa Hernández',
        'Corte y peinado',
        _at(1, 10),
        BookingStatus.confirmed,
      ),
      booking(
        'Pedro Almonte',
        'Corte de caballero',
        _at(1, 12),
        BookingStatus.pending,
      ),
      booking(
        'Patricia Castillo',
        'Tinte completo',
        _at(1, 15),
        BookingStatus.confirmed,
      ),
      booking(
        'Miguel Santana',
        'Corte de caballero',
        _at(2, 9, 30),
        BookingStatus.pending,
      ),
      booking(
        'José Martínez',
        'Corte y peinado',
        _at(2, 14),
        BookingStatus.confirmed,
      ),
      booking(
        'Ana Lucía Peña',
        'Tratamiento de keratina',
        _at(3, 11),
        BookingStatus.pending,
      ),
      booking(
        'María Fernández',
        'Manicure y pedicure',
        _at(4, 16),
        BookingStatus.confirmed,
      ),
      // Días anteriores (historial).
      booking(
        'Laura Jiménez',
        'Corte y peinado',
        _at(-1, 10),
        BookingStatus.completed,
      ),
      booking(
        'Pedro Almonte',
        'Tinte completo',
        _at(-1, 14),
        BookingStatus.cancelled,
      ),
      booking(
        'Rosa Hernández',
        'Manicure y pedicure',
        _at(-2, 11),
        BookingStatus.completed,
      ),
    ];
  }

  // ---------------------------------------------------------------------
  // Clientes: todos los niveles representados (bronce → platino).
  // ---------------------------------------------------------------------

  List<CustomerModel> _customers() {
    const data = [
      ('María Fernández', '809-555-0101', 1240, 18),
      ('Ana Lucía Peña', '829-555-0142', 860, 12),
      ('Laura Jiménez', '809-555-0177', 640, 9),
      ('Carlos Rodríguez', '849-555-0118', 520, 8),
      ('Gabriela Núñez', '809-555-0163', 410, 6),
      ('Rosa Hernández', '829-555-0125', 310, 5),
      ('Patricia Castillo', '809-555-0190', 240, 4),
      ('José Martínez', '849-555-0133', 180, 3),
      ('Carmen Reyes', '809-555-0156', 120, 2),
      ('Luis Batista', '829-555-0109', 90, 2),
      ('Pedro Almonte', '809-555-0184', 60, 1),
      ('Miguel Santana', '849-555-0171', 30, 1),
    ];

    var seq = 0;
    return [
      for (final (name, phone, points, visits) in data)
        CustomerModel()
          ..customerId = 'demo-cu-${seq++}'
          ..name = name
          ..phone = phone
          ..points = points
          ..tier = _tierForPoints(points)
          ..visitHistory = [
            for (var v = 0; v < visits; v++) _at(-(v * 6 + 2), 10),
          ],
    ];
  }

  /// Mirrors the thresholds in `LoyaltyLocalDataSourceImpl`.
  LoyaltyTier _tierForPoints(int points) {
    if (points >= 1000) return LoyaltyTier.platinum;
    if (points >= 500) return LoyaltyTier.gold;
    if (points >= 200) return LoyaltyTier.silver;
    return LoyaltyTier.bronze;
  }

  // ---------------------------------------------------------------------
  // Cupones: uno para canjear en vivo, uno casi agotado, uno vencido.
  // ---------------------------------------------------------------------

  List<CouponModel> _coupons() {
    var seq = 0;
    CouponModel coupon(
      String code,
      DiscountType type,
      double value,
      DateTime expiration,
      int maxUses,
      int currentUses,
    ) {
      return CouponModel()
        ..couponId = 'demo-cp-${seq++}'
        ..code = code
        ..discountType = type
        ..value = value
        ..expirationDate = expiration
        ..maxUses = maxUses
        ..currentUses = currentUses
        ..isActive = true;
    }

    return [
      coupon('BIENVENIDA15', DiscountType.percentage, 15, _at(60, 23), 100, 23),
      coupon('MADRES2026', DiscountType.percentage, 20, _at(20, 23), 50, 41),
      coupon('REFIERE500', DiscountType.fixedAmount, 500, _at(90, 23), 30, 7),
      coupon('VERANO10', DiscountType.percentage, 10, _at(-5, 23), 80, 62),
    ];
  }
}
