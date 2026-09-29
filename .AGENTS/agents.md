# AGENTS.md — NegocioListo Pro

## 1. Project Overview & Tech Stack

**NegocioListo Pro** is a multi-tenant, offline-first SaaS platform for micro-business digitalization built with Flutter. It is 100% local — no HTTP client, no backend, no network dependency. Isar (embedded NoSQL) is the sole source of truth.

| Technology     | Version      | Purpose                                             |
| -------------- | ------------ | --------------------------------------------------- |
| Flutter SDK    | 3.47.1 (FVM) | UI framework                                        |
| Dart SDK       | ^3.13.1      | Language                                            |
| flutter_bloc   | ^8.1.3       | State management (BLoC pattern)                     |
| get_it         | ^7.6.4       | Service Locator / DI container                      |
| dartz          | ^0.10.1      | Functional programming (`Either<Failure, Success>`) |
| isar_community | ^3.3.2       | Embedded NoSQL database (offline-first)             |
| path_provider  | ^2.1.1       | App documents directory path                        |

**Dev dependencies**: `flutter_test`, `flutter_lints`, `isar_community_generator`, `build_runner`, `flutter_launcher_icons`

**Language**: All code comments, UI strings, and documentation are in **Spanish**.

---

## 2. Architecture & Folder Structure

The project follows **Strict Clean Architecture** with three layers per feature. Dependency direction is unidirectional: `Presentation → Domain ← Data`. The Domain layer has zero dependencies on Flutter or Isar.

```
lib/
  main.dart                              # Entry point
  app/
    app.dart                             # MyApp widget, BlocProvider, MaterialApp
  core/
    branding/brand_config.dart           # White-label brand presets (--dart-define)
    di/injection_container.dart          # GetIt service locator setup
    errors/failures.dart                 # Failure hierarchy
    theme/app_theme.dart                 # Design tokens, ThemeData
    usecases/usecase.dart                # UseCase<Success, Params> base + NoParams
  features/
    auth/                                # Session, tenant, credentials
    dashboard/                           # Financial transactions & metrics
    bookings/                            # Appointments & orders
    loyalty/                             # Customer loyalty, points, tiers
    coupons/                             # Smart coupons with validation
```

### Feature Triad (identical for every feature)

```
features/<feature>/
  domain/
    entities/                            # Pure Dart classes (no Flutter/Isar imports)
    repositories/                        # Abstract contracts
    usecases/                            # UseCase implementations
  data/
    datasources/                         # LocalDataSource abstract + Impl (Isar)
    models/                              # Isar @collection models + .g.dart
    repositories/                        # RepositoryImpl (maps Model <-> Entity)
  presentation/
    bloc/                                # <Feature>Bloc, <Feature>Event, <Feature>State
    pages/                               # Full-page widgets
    widgets/                             # Bottom sheets, dialogs, cards
```

### File Naming Conventions

| Layer                 | Pattern                                                              | Example                           |
| --------------------- | -------------------------------------------------------------------- | --------------------------------- |
| Entity                | `<name>_entity.dart`                                                 | `coupon_entity.dart`              |
| Model                 | `<name>_model.dart` + `.g.dart`                                      | `coupon_model.dart`               |
| Repository (abstract) | `<name>_repository.dart`                                             | `coupon_repository.dart`          |
| Repository (impl)     | `<name>_repository_impl.dart`                                        | `coupon_repository_impl.dart`     |
| DataSource            | `<name>_local_datasource.dart`                                       | `coupon_local_datasource.dart`    |
| UseCase               | `<action>_usecase.dart`                                              | `create_coupon_usecase.dart`      |
| Bloc                  | `<feature>_bloc.dart`                                                | `coupon_bloc.dart`                |
| Event                 | `<feature>_event.dart`                                               | `coupon_event.dart`               |
| State                 | `<feature>_state.dart`                                               | `coupon_state.dart`               |
| Page                  | `<name>_page.dart`                                                   | `coupons_page.dart`               |
| Widget                | `<name>_bottom_sheet.dart`, `<name>_dialog.dart`, `<name>_card.dart` | `create_coupon_bottom_sheet.dart` |

All files use `snake_case` naming.

---

## 3. Coding Standards & Best Practices

### Imports

- **Always use package imports** — enforced by `always_use_package_imports: true`
- Format: `import 'package:negocio_listo_pro/...';`
- **No relative imports** in lib/ code
- Import ordering: Dart/Flutter SDK first, then packages, then project imports

### Lint Rules

- Base: `package:flutter_lints/flutter.yaml`
- Enabled: `prefer_single_quotes: true`, `always_use_package_imports: true`
- `print` is allowed (`avoid_print: false`)

### State Management (BLoC)

- Each feature has `<feature>_bloc.dart`, `<feature>_event.dart`, `<feature>_state.dart`
- State pattern: `Initial → Loading → Loaded/Error` (consistent across all features)
- Event naming: `<Action>Requested` for mutations (e.g., `CreateCouponRequested`), `Load<Entities>` for reads
- **Reload-after-mutation**: Every write operation automatically re-dispatches the load event to keep UI in sync with Isar
- Blocs are registered as `registerFactory` (not singleton) so each screen gets a fresh instance
- Use `BlocProvider` at app root for `AuthBloc`, `MultiBlocProvider` in `HomePage` for feature blocs
- Use `BlocProvider.value` for bottom sheets/dialogs
- Use `BlocConsumer`/`BlocBuilder` for reactive UI; `BlocListener` for snackbar side-effects
- State/event classes are plain Dart classes (no Equatable)

### Dependency Injection (GetIt)

- Global instance: `final GetIt sl = GetIt.instance;`
- Initialization: `initDependencyInjection()` called in `main()` before `runApp()`
- Registration pattern:
  - `Isar` → `registerSingleton`
  - DataSources → `registerLazySingleton` (take `Isar` from `sl()`)
  - Repositories → `registerLazySingleton` (take `LocalDataSource` from `sl()`)
  - UseCases → `registerLazySingleton` (take `Repository` from `sl()`)
  - Blocs → `registerFactory` (take UseCases from `sl()`)

### Error Handling (Functional — Dartz Either)

- Pattern: `Either<Failure, Success>` — no exceptions thrown across layer boundaries
- Failure hierarchy in `lib/core/errors/failures.dart`:
  - `Failure` (abstract base with `message`)
  - `CacheFailure`, `NetworkFailure`, `ServerFailure`, `AuthFailure`
  - `CouponNotFoundFailure`, `CouponInactiveFailure`, `CouponExpiredFailure`, `CouponExhaustedFailure`
- Repository pattern: `try { ... return Right(...) } on Failure catch (f) { return Left(f) } catch (_) { return Left(CacheFailure()) }`
- DataSource layer throws `Failure` subclasses
- Bloc layer: `result.fold((failure) => emit(Error(failure.message)), (data) => emit(Loaded(data)))`

### UseCase Pattern

- Every use case implements `UseCase<Success, Params>` with a single `call()` method
- Params are dedicated classes (e.g., `RedeemCouponParams`, `LoginParams`) or `NoParams` for no-arg cases

### Entity vs Model Separation

- **Entities**: Pure Dart classes — no Isar annotations, no Flutter imports
- **Models**: Isar `@collection` classes with `toEntity()` and `fromEntity()` mapping methods
- Generated `.g.dart` files via `isar_community_generator`

### Design Tokens

- Use `AppSpacing.md`, `AppRadius.lg`, `AppColors.success`, etc. instead of raw values
- `AppTheme.forBrand(BrandConfig)` generates `ThemeData` from brand config
- `BrandConfig.current.formatMoney(amount)` for currency display
- Material 3 enabled (`useMaterial3: true`)

### Routing

- No router package — simple conditional navigation via `BlocBuilder<AuthBloc, AuthState>`
- `HomePage` uses `IndexedStack` with `BottomAppBar` for tab navigation
- Sub-navigation via bottom sheets (`showModalBottomSheet`) and dialogs (`showDialog`) with static `.show(context)` methods

### Code Generation

- Isar schemas: `@collection` annotations on model classes
- Run: `fvm dart run build_runner build --delete-conflicting-outputs`
- No freezed, no json_serializable — entities are plain Dart classes with manual `copyWith` methods

---

## 4. Workflow & Constraints

### When Adding a New Feature

1. Create the triad: `domain/`, `data/`, `presentation/` under `features/<feature>/`
2. Define entities in `domain/entities/` (pure Dart)
3. Define abstract repository contract in `domain/repositories/`
4. Implement use cases in `domain/usecases/`
5. Create Isar models in `data/models/` with `@collection` annotation
6. Create abstract + impl data sources in `data/datasources/`
7. Implement repository in `data/repositories/` with Model ↔ Entity mapping
8. Create Bloc, Event, State in `presentation/bloc/`
9. Create pages and widgets in `presentation/pages/` and `presentation/widgets/`
10. Register all dependencies in `lib/core/di/injection_container.dart`
11. Run `fvm dart run build_runner build --delete-conflicting-outputs`

### When Modifying Existing Code

- **Never** add Flutter or Isar imports to domain layer files
- **Never** mix UI logic with infrastructure — keep layers separated
- **Never** use `Navigator.push` — use bottom sheets or dialogs with `.show(context)` pattern
- **Never** use raw spacing/color values — use design tokens from `app_theme.dart`
- **Never** throw exceptions across layer boundaries — use `Either<Failure, Success>`
- **Always** re-dispatch load events after mutations to keep UI in sync
- **Always** wrap multi-step Isar operations in `isar.writeTxn()` for atomicity

### Patterns to Avoid

- Violating Single Responsibility Principle (one class = one purpose)
- Mixing UI logic with data access or business logic
- Using relative imports in lib/
- Adding dependencies to the Domain layer
- Creating singleton Blocs (always use `registerFactory`)
- Using Equatable (project uses plain Dart classes)
- Hardcoding strings that should be in Spanish
- Using raw color/spacing values instead of design tokens

### Persistence & Synchronization

- Isar is the sole persistence layer — no remote sync
- Multi-tenant: all data scoped by `tenantId` in models
- Auth: local credential resolution with FNV-1a password hashing (demo-grade)
- Session: cached in `UserModel` with fixed session ID for single-session-per-device
- Demo credentials seeded on first launch via `_seedDemoCredentials()`

---

## 5. Specific Agent Instructions

### Always

- Check existing tests before modifying code (run `fvm flutter test`)
- Maintain the offline-first design — no network calls
- Follow the established file naming conventions exactly
- Use package imports only
- Use design tokens for all spacing, colors, and radius values
- Write comments and UI strings in Spanish
- Run `fvm dart run build_runner build --delete-conflicting-outputs` after modifying Isar models
- Verify the app compiles with `fvm flutter analyze` before considering work complete

### Never

- Add Firebase, HTTP clients, or any network dependency
- Create relative imports in lib/
- Add Flutter/Isar imports to domain layer
- Use `Navigator.push` for navigation
- Skip the reload-after-mutation pattern in Blocs
- Commit generated `.g.dart` files without reviewing them
- Use `print()` for logging in production code paths (use BlocListener for side-effects)

### Testing Approach

- Domain layer is pure Dart — unit test use cases and entities directly
- Widget tests for pages and bottom sheets using `flutter_test`
- Bloc tests using `bloc_test` pattern (test event → state transitions)
- No integration tests currently exist — architecture supports them if needed

### Commands

```bash
# Install dependencies
fvm flutter pub get

# Generate Isar schemas (required after model changes)
fvm dart run build_runner build --delete-conflicting-outputs

# Run the app
fvm flutter run

# Run with a specific brand
fvm flutter run --dart-define=BRAND=salon

# Run tests
fvm flutter test

# Analyze code
fvm flutter analyze
```

### Demo Credentials

| Email                   | Password   | Tenant            |
| ----------------------- | ---------- | ----------------- |
| `demo@negociolisto.pro` | `demo1234` | Negocio Demo      |
| `test`                  | `test`     | Negocio de Prueba |
