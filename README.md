# NegocioListo Pro

![Status](https://img.shields.io/badge/status-active-brightgreen)
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Architecture](https://img.shields.io/badge/architecture-Clean%20Architecture-blueviolet)
![Offline First](https://img.shields.io/badge/connectivity-100%25%20Offline--First-orange)
![License](https://img.shields.io/badge/license-Proprietary-lightgrey)

**NegocioListo Pro** es una plataforma SaaS multi-inquilino (*multi-tenant*) para la digitalización de micronegocios, diseñada bajo un principio no negociable: **cero dependencia de red**. Cada tenant opera con su propia caja registradora, cartera de clientes y motor de fidelización funcionando 100% en el dispositivo, sin backend, sin latencia y sin puntos únicos de falla.

Este repositorio es a la vez una demo comercial funcional y una vitrina técnica de arquitectura de software de nivel empresarial en Flutter.

---

## ¿Por qué este proyecto? (El Enfoque Comercial)

La mayoría de los micronegocios en mercados emergentes no fallan por falta de ventas — fallan por falta de control. NegocioListo Pro ataca ese problema desde dos frentes:

### Para el empresario novato
- **Arranque inmediato, cero infraestructura.** Sin servidores, sin planes de hosting, sin configuración de backend. Se instala y se usa el mismo día.
- **Control de caja desde el primer minuto.** El módulo de Dashboard Financiero registra ingresos y egresos locales sin necesidad de contabilidad previa.
- **Relación con el cliente desde el día uno.** El módulo de Fidelización construye una base de clientes con historial de visitas y puntos, sin depender de un CRM externo.

### Para el negocio establecido
- **Sistema satélite ultrarrápido.** Cada sucursal o punto de venta opera de forma autónoma; no hay round-trips de red que ralenticen el checkout.
- **Resiliencia total ante fallos de conectividad.** Internet caído, zona rural, evento con mala señal — la operación de caja, citas y cupones **nunca se detiene**, porque nunca dependió de la red.
- **Motor de promociones sin fricción.** Cupones inteligentes con validación de vigencia, estado y usos disponibles, resueltos íntegramente en el dispositivo.

---

## Arquitectura y Decisiones Técnicas (El Enfoque Senior)

### Clean Architecture estricta

El proyecto está dividido en tres capas con dependencias unidireccionales (`Presentation → Domain ← Data`), replicadas de forma idéntica en cada módulo de negocio:

| Capa | Responsabilidad | Ejemplos |
|---|---|---|
| **Domain** | Reglas de negocio puras, sin dependencias de Flutter ni de persistencia. | `CouponEntity`, `LoyaltyRepository` (abstracto), `RedeemCouponUseCase` |
| **Data** | Implementación concreta de persistencia y mapeo Entity ↔ Model. | `CouponModel` (Isar), `CouponLocalDataSourceImpl`, `CouponRepositoryImpl` |
| **Presentation** | Estado de UI y widgets, orquestados vía BLoC. | `CouponBloc`, `CouponsPage`, `CreateCouponBottomSheet` |

Esta separación permite que la lógica de negocio (por ejemplo, "un cupón solo es redimible si está activo, no ha expirado y tiene usos disponibles") sea testeable de forma aislada, sin necesidad de levantar UI ni base de datos real.

### Offline-First real, no "offline-tolerant"

A diferencia de arquitecturas que cachean datos remotos como respaldo, NegocioListo Pro **no tiene cliente HTTP en ningún punto del código**. Isar —una base de datos embebida, reactiva y de altísimo rendimiento para Flutter— es la única fuente de verdad:

- Cada colección (`CouponModel`, `CustomerModel`, `BookingModel`, `TransactionModel`) es un modelo `@collection` de Isar con índices únicos donde aplica (p. ej. código de cupón, email de credencial).
- Operaciones críticas con múltiples pasos (validar vigencia → validar usos → incrementar contador) se ejecutan dentro de una única `isar.writeTxn`, garantizando atomicidad y evitando condiciones de carrera en canjes concurrentes.
- Toda la inyección de dependencias (`GetIt`) resuelve datasources, repositorios y casos de uso apuntando siempre a Isar — jamás a un servicio remoto.

### Manejo funcional de errores con Dartz

En lugar de excepciones no tipadas o valores nulos ambiguos, cada método de repositorio retorna `Either<Failure, Success>`:

```dart
Future<Either<Failure, CouponEntity>> redeemCoupon(String code);
```

Esto obliga a manejar explícitamente cada camino de fallo (`CouponNotFoundFailure`, `CouponExpiredFailure`, `CouponExhaustedFailure`, `CouponInactiveFailure`) en la capa de Presentation, sin `try/catch` dispersos ni estados inconsistentes en la UI.

### Gestión de estado con BLoC

Cada módulo expone un `Bloc` con eventos y estados explícitos (sin `Equatable`, usando clases planas de Dart), y sigue un patrón consistente de recarga tras mutación: toda operación de escritura (`AddCustomerRequested`, `RedeemCouponRequested`) dispara automáticamente una relectura del estado para mantener la UI sincronizada con Isar.

---

## Estructura del Proyecto

```
lib/
├── core/
│   ├── di/                    # Inyección de dependencias (GetIt) y apertura de Isar
│   ├── errors/                # Jerarquía de Failure (Cache, Network, Coupon*, etc.)
│   └── usecases/              # UseCase<Success, Params> base + NoParams
│
└── features/
    ├── auth/                  # Sesión, tenant y credenciales locales
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    │
    ├── dashboard/              # Registro de transacciones y métricas financieras
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    │
    ├── bookings/               # Citas y pedidos
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    │
    ├── loyalty/                # Clientes fidelizados, puntos y niveles (tiers)
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    │
    └── coupons/                # Cupones inteligentes con validación de vigencia/usos
        ├── domain/
        ├── data/
        └── presentation/
```

Cada feature replica la misma tríada `domain/ data/ presentation/`, lo que permite a cualquier ingeniero nuevo en el equipo ubicarse en cuestión de minutos: si conoces un módulo, conoces la forma de todos.

---

## Stack Tecnológico

| Tecnología | Rol en el proyecto |
|---|---|
| **Flutter** | Framework de UI multiplataforma (Android/iOS) |
| **Dart** | Lenguaje, con tipado estricto (sin `dynamic`) en toda la base de código |
| **flutter_bloc** | Gestión de estado predecible por feature (Bloc/Event/State) |
| **get_it** | Contenedor de inyección de dependencias (Service Locator) |
| **isar_community** | Base de datos embebida NoSQL, reactiva, offline-first |
| **dartz** | Programación funcional — `Either<Failure, Success>` para manejo de errores |

---

## Cómo Ejecutar el Proyecto Localmente

### Requisitos previos
- Flutter SDK (gestionado vía [FVM](https://fvm.app/) en este proyecto)
- Dart SDK (incluido con Flutter)
- Android Studio / Xcode para emuladores, o un dispositivo físico

### Pasos

1. **Clonar el repositorio**

   ```bash
   git clone https://github.com/GrullonDev/negocio_listo_pro.git
   cd negocio_listo_pro
   ```

2. **Instalar dependencias**

   ```bash
   fvm flutter pub get
   ```

3. **Generar los esquemas de Isar**

   Los modelos `@collection` (`CouponModel`, `CustomerModel`, `BookingModel`, `TransactionModel`, etc.) requieren código generado antes de compilar:

   ```bash
   fvm dart run build_runner build --delete-conflicting-outputs
   ```

4. **Ejecutar la aplicación**

   ```bash
   fvm flutter run
   ```

5. **Iniciar sesión con las credenciales demo**

   La app siembra automáticamente dos cuentas locales de prueba en el primer arranque (sin backend, sin red):

   | Email | Contraseña |
   |---|---|
   | `demo@negociolisto.pro` | `demo1234` |
   | `test` | `test` |

---

## Autoría

Desarrollado y mantenido por **Jorge Grullón** — Ingeniero de Software Senior especializado en Flutter, Clean Architecture y sistemas offline-first.

- GitHub: [GrullonDev](https://github.com/GrullonDev)
- Portafolio: [jorgegrullondev.com](https://jorgegrullondev.com/)
