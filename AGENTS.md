# AGENTS.md

Instrucciones para agentes que trabajan en este repositorio. Consultar README y configuración para el detalle; este archivo no autoriza publicación ni cambios fuera de la tarea.

## Propósito del proyecto

Demo funcional de gestión de micronegocios con acceso local, caja, clientes/puntos, cupones y citas. Opera en dispositivo con Isar; no hay backend remoto declarado aunque el README use el término SaaS.

## Stack y plataformas

flutter_bloc, GetIt, dartz/Either, Isar Community ^3.3.2, build_runner e isar_community_generator.

Requisito Dart declarado: `^3.13.1` en `pubspec.yaml`; los rangos de dependencias no prueban la versión resuelta. SDK mediante FVM: `stable` según `.fvmrc` (canal móvil, no versión fija).

Proyectos de plataforma presentes: android, ios, web. Esto no garantiza que todos los plugins funcionen en cada plataforma.

## Estructura del repositorio

`lib/app/app.dart` configura app; `lib/core/` DI, fallos, usecases y tema. Cada módulo auth/dashboard/bookings/coupons/loyalty en `lib/features/` separa data/domain/presentation. Modelos Isar y generados en data/models; UI y BLoC en presentation.

## Preparación y comandos

Requisitos: FVM y SDK de `.fvmrc`; ejecutar `fvm install` sin modificar el pin. Android necesita su toolchain/JDK de Gradle; iOS requiere macOS/Xcode y la gestión de dependencias del proyecto. Integraciones Firebase requieren configuración de desarrollo existente.

| Acción | Comando desde la raíz |
| --- | --- |
| Dependencias | `fvm flutter pub get` |
| Ejecutar | `fvm flutter run -d <dispositivo>` |
| Formato | `fvm dart format lib test` |
| Análisis | `fvm flutter analyze` |
| Pruebas | `fvm flutter test` |
| Build Android de comprobación | `fvm flutter build apk --debug` |

`fvm dart run build_runner build --delete-conflicting-outputs` al modificar modelos Isar.

Los comandos fueron contrastados con dependencias, documentación/configuración y suites presentes; no ejecutados al redactar este archivo. Build de distribución requiere firma/configuración adicional; no sustituye despliegue.

## Arquitectura y convenciones

Mantener dependencias Presentation → Domain ← Data. Repositorios devuelven Either/Failure; datasources encapsulan Isar. Registrar nuevas dependencias en `lib/core/di/injection_container.dart`. Validación y actualización del canje deben permanecer en una misma writeTxn. Revisar selección/base de tenant antes de cada operación: no asumir aislamiento porque exista TenantModel.

Conservar nombres y convenciones del módulo: Dart snake_case para archivos, UpperCamelCase para tipos y lowerCamelCase para miembros. No renombrar APIs/campos persistidos incidentalmente; respetar lints de analysis_options.yaml.

## Experiencia de usuario

Mostrar vacío inicial, guardado/error y validación de importes, fechas, vigencia y usos de cupones. Evitar doble envío de transacciones, puntos o canjes. Preservar registros al cerrar app y cambiar negocio; reutilizar AppTheme y widgets del módulo.

En el flujo afectado, contemplar carga, vacío, éxito y error; dar feedback claro, conservar entradas/datos ante fallos y permitir recuperación. Reutilizar componentes visuales; revisar semántica, foco, contraste y escalado de texto.

## Seguridad y datos

No incluir secretos, credenciales ni datos personales en código, documentación o logs. Usar configuración de entorno existente, validar entradas y manejar fallos de servicios. Respetar autenticación, autorización y permisos. No ejecutar operaciones destructivas sobre datos sin autorización explícita.

El token `local-…` representa sesión local y no autenticación remota. Revisar el hash de credenciales existente antes de usar la demo con datos reales; no copiar credenciales de demostración a documentación. No borrar ni migrar bases locales destructivamente. Proteger separación de tenants y minimizar datos de clientes.

## Pruebas y validación

`test/widget_test.dart` es la suite presente; verificar su cobertura real. Validar login/logout/recuperación, separación entre negocios, totales ingresos-egresos, puntos, citas y cupones caducados/agotados; comprobar canje único y persistencia. Usar Isar temporal para pruebas de datos si el cambio lo requiere.

Ejecutar análisis y pruebas relevantes según el cambio; compilar solo plataformas afectadas. Un cambio exclusivamente documental requiere revisar rutas, comandos, alcance y diff, sin pruebas artificiales que repliquen el texto. No afirmar que una prueba pasó si no se ejecutó.

## Flujo de trabajo del agente

Leer instrucciones aplicables antes de modificar archivos, incluidas las de subdirectorios: su alcance local se respeta. Las instrucciones explícitas del usuario prevalecen.

1. Revisar estado del trabajo y comprender el flujo afectado antes de implementar.
2. Hacer cambios acotados al objetivo; respetar cambios existentes del usuario y evitar refactorizaciones ajenas.
3. Reutilizar componentes y dependencias disponibles; justificar dependencias nuevas.
4. Actualizar documentación si cambia comportamiento o configuración.
5. Ejecutar verificaciones pertinentes y comunicar resultados y pendientes con su motivo.
6. No hacer commits, push o despliegues salvo solicitud o autorización previa del usuario. Esta regla prevalece sobre recomendaciones de commit automático en guías antiguas.

No imponer una política nueva de ramas/commits; seguir documentación y CI existentes.

No activar workflows de publicación ni scripts de release como comprobación rutinaria.

## Criterios de finalización

La tarea cumple el comportamiento solicitado, contempla errores/estados relevantes, mantiene convenciones y pasa las verificaciones aplicables que puedan ejecutarse. Comunicar archivos modificados, resultados reales y cualquier validación pendiente con su motivo.

## Limitaciones y aspectos por confirmar

FVM usa `stable`; compatibilidad debe satisfacer Dart ^3.13.1. Android/iOS/web tienen scaffold, pero Isar Community y sus librerías nativas requieren verificar plataforma; no afirmar web funcional solo por `web/`.
