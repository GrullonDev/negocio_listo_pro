import 'package:flutter/material.dart';

import 'package:negocio_listo_pro/app/app.dart';
import 'package:negocio_listo_pro/core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencyInjection();

  runApp(const MyApp());
}
