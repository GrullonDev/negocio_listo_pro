# Plan de Migración: Backend Local con Dart Frog y PostgreSQL

> Generado: 2026-11-11 — Rama: `feature/local-backend-postgres`

---

## 1. Estado Actual del Proyecto

### Módulos existentes

| Módulo | Entidades | Isar Collections | Operaciones |
|--------|-----------|-------------------|-------------|
| **auth** | `UserEntity`, `TenantEntity` | `UserModel`, `CredentialModel`, `TenantModel` (embedded) | login, logout, get session |
| **dashboard** | `TransactionEntity`, `FinancialMetricsEntity` | `TransactionModel` | listar, agregar transacción, calcular métricas |
| **bookings** | `BookingEntity` | `BookingModel` | listar, agregar, actualizar estado |
| **loyalty** | `CustomerLoyaltyEntity` | `CustomerModel` | listar, agregar cliente, agregar puntos |
| **coupons** | `CouponEntity` | `CouponModel` | listar, crear, canjear |

### Hallazgos críticos

1. **Sin aislamiento multi-tenant en datos**: `TransactionModel`, `BookingModel`, `CustomerModel` y `CouponModel` no tienen campo `tenantId`. Todos los datos son globales por dispositivo.
2. **Hashing inseguro**: Las contraseñas se almacenan con FNV-1a (no criptográfico). Suficiente para demo offline, pero inaceptable para un backend.
3. **Credenciales demo hardcodeadas**: Se insertan automáticamente en `injection_container.dart` al iniciar la app.
4. **Montos como `double`**: `TransactionModel.amount` y `CouponModel.value` usan `double`, propenso a errores de precisión en cálculos financieros.
5. **Sin cliente HTTP**: No existe ninguna dependencia de red en el proyecto.
6. **Tests limitados**: Solo existen tests de branding y widget_test del scaffold de Flutter.

---

## 2. Arquitectura Objetivo

```
┌─────────────┐     HTTP/JSON      ┌──────────────┐     SQL      ┌────────────┐
│  Flutter App │ ◄──────────────► │  Dart Frog   │ ◄──────────► │ PostgreSQL │
│  (Isar local)│                   │  Backend     │              │ (Docker)   │
└─────────────┘                    └──────────────┘              └────────────┘
```

### Principios

- **Offline-first**: Isar sigue siendo la fuente de verdad local. El backend es fuente de verdad central.
- **Clean Architecture preservada**: Se agregan `RemoteDataSource` junto a los `LocalDataSource` existentes.
- **Repositorios híbridos**: Cada repositorio decide si usar Isar, API o ambos según conectividad.
- **Sin dependencias externas de nube**: Todo corre en la máquina del desarrollador.

---

## 3. Decisiones Técnicas

### Backend

| Decisión | Elección | Justificación |
|----------|----------|---------------|
| Framework HTTP | Dart Frog | Ecosistema Dart nativo, middleware composable, hot reload |
| Base de datos | PostgreSQL 16 (Docker) | Transacciones ACID, NUMERIC para dinero, JSON para extensibilidad |
| Driver Dart-PG | `postgres` (pkg) | Driver oficial, pool de conexiones, consultas parametrizadas |
| Hashing passwords | Argon2id (`dbcrypt` o `pointycastle`) | Estándar actual OWASP para almacenamiento de contraseñas |
| Sesiones | JWT (access + refresh tokens) | Stateless, verificable offline con clave pública |
| Montos monetarios | `NUMERIC(15,2)` en PG, `int` centavos en Dart | Sin pérdida de precisión por floating point |
| IDs de negocio | UUID v4 | Sin colisión entre dispositivos offline |
| Fechas | UTC en PG y backend, local en Flutter UI | Consistencia temporal |

### Flutter

| Decisión | Elección | Justificación |
|----------|----------|---------------|
| Cliente HTTP | `http` o `dio` | Lightweight, interceptores para auth |
| URL base API | `--dart-define=API_BASE_URL` | Sin IPs hardcodeadas |
| Almacenamiento de tokens | `flutter_secure_storage` | Keychain/Keystore nativo |
| Estrategia sync | Cola local con idempotency keys | Evita duplicados, soporta reintentos |

### Datos que permanecen en Isar

- Sesión del usuario (caché local)
- Cola de operaciones pendientes (sync)
- Datos descargados del backend (caché offline)
- Configuración local del dispositivo

### Datos que migran a PostgreSQL (fuente de verdad central)

- Credenciales y sesiones
- Tenants y usuarios
- Transacciones financieras
- Citas/bookings
- Clientes y puntos de fidelización
- Cupones y canjes

---

## 4. Modelo de Datos PostgreSQL

### Tablas principales

```sql
-- tenants
CREATE TABLE tenants (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name         TEXT NOT NULL,
  business_type TEXT NOT NULL DEFAULT 'general',
  currency_code TEXT NOT NULL DEFAULT 'DOP',
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- users
CREATE TABLE users (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id     UUID NOT NULL REFERENCES tenants(id),
  name          TEXT NOT NULL,
  email         TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  role          TEXT NOT NULL DEFAULT 'owner' CHECK (role IN ('owner', 'staff')),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (tenant_id, email)
);

-- refresh_tokens
CREATE TABLE refresh_tokens (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  tenant_id  UUID NOT NULL REFERENCES tenants(id),
  token_hash TEXT NOT NULL UNIQUE,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- transactions
CREATE TABLE transactions (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID NOT NULL REFERENCES tenants(id),
  description TEXT NOT NULL,
  amount      NUMERIC(15,2) NOT NULL,
  type        TEXT NOT NULL CHECK (type IN ('income', 'expense')),
  category    TEXT,
  occurred_at TIMESTAMPTZ NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- bookings
CREATE TABLE bookings (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id   UUID NOT NULL REFERENCES tenants(id),
  customer_id UUID REFERENCES customers(id),
  client_name TEXT NOT NULL,
  service     TEXT NOT NULL,
  start_at    TIMESTAMPTZ NOT NULL,
  end_at      TIMESTAMPTZ,
  status      TEXT NOT NULL DEFAULT 'pending'
                CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- customers
CREATE TABLE customers (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id  UUID NOT NULL REFERENCES tenants(id),
  name       TEXT NOT NULL,
  phone      TEXT,
  points     INTEGER NOT NULL DEFAULT 0,
  tier       TEXT NOT NULL DEFAULT 'bronze'
               CHECK (tier IN ('bronze', 'silver', 'gold', 'platinum')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- loyalty_events
CREATE TABLE loyalty_events (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id    UUID NOT NULL REFERENCES tenants(id),
  customer_id  UUID NOT NULL REFERENCES customers(id),
  points_delta INTEGER NOT NULL,
  reason       TEXT NOT NULL,
  occurred_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- coupons
CREATE TABLE coupons (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID NOT NULL REFERENCES tenants(id),
  code            TEXT NOT NULL,
  discount_type   TEXT NOT NULL CHECK (discount_type IN ('percentage', 'fixed_amount')),
  value           NUMERIC(15,2) NOT NULL,
  max_uses        INTEGER NOT NULL,
  current_uses    INTEGER NOT NULL DEFAULT 0,
  expiration_date TIMESTAMPTZ NOT NULL,
  is_active       BOOLEAN NOT NULL DEFAULT true,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (tenant_id, code)
);

-- coupon_redemptions
CREATE TABLE coupon_redemptions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id       UUID NOT NULL REFERENCES tenants(id),
  coupon_id       UUID NOT NULL REFERENCES coupons(id),
  customer_id     UUID REFERENCES customers(id),
  redeemed_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  idempotency_key TEXT NOT NULL UNIQUE
);

-- sync_queue (para operaciones offline pendientes)
CREATE TABLE sync_operations (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id      UUID NOT NULL REFERENCES tenants(id),
  entity_type    TEXT NOT NULL,
  entity_id      UUID NOT NULL,
  operation      TEXT NOT NULL CHECK (operation IN ('create', 'update', 'delete')),
  payload        JSONB NOT NULL,
  idempotency_key TEXT NOT NULL UNIQUE,
  status         TEXT NOT NULL DEFAULT 'pending'
                   CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  processed_at   TIMESTAMPTZ
);
```

### Índices

```sql
CREATE INDEX idx_transactions_tenant ON transactions(tenant_id);
CREATE INDEX idx_transactions_occurred ON transactions(tenant_id, occurred_at DESC);
CREATE INDEX idx_bookings_tenant ON bookings(tenant_id);
CREATE INDEX idx_bookings_start ON bookings(tenant_id, start_at);
CREATE INDEX idx_customers_tenant ON customers(tenant_id);
CREATE INDEX idx_coupons_tenant ON coupons(tenant_id);
CREATE INDEX idx_loyalty_events_customer ON loyalty_events(tenant_id, customer_id);
CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id);
CREATE INDEX idx_sync_operations_status ON sync_operations(tenant_id, status);
```

---

## 5. Plan de Ejecución por Fases

### Fase 2 — Backend Dart Frog
- Crear proyecto `backend/` con Dart Frog CLI
- Estructura: config, database, middleware, módulos por feature
- Health check endpoint
- Middleware de errores y logging
- Inyección de dependencias del backend

### Fase 3 — PostgreSQL
- `compose.yaml` con PostgreSQL 16
- Migraciones SQL versionadas en `backend/migrations/`
- Script de seed con datos demo
- `.env.example` con variables de conexión

### Fase 4 — Autenticación
- Registro de negocio + usuario owner
- Login con JWT (access 15min + refresh 7d)
- Argon2id para hashing
- Middleware de autenticación en rutas protegidas
- Aislamiento por tenant en todas las queries

### Fase 5 — API REST por módulo
- Empezar con transactions (módulo más simple)
- Luego bookings, customers, coupons
- Validación de payload en cada endpoint
- Tests positivos y negativos

### Fase 6 — Integración Flutter
- Agregar `http` y `flutter_secure_storage` a pubspec
- Crear `RemoteDataSource` por módulo
- Modificar repositorios para estrategia híbrida
- Configurar URL base por `--dart-define`

### Fase 7 — Sincronización
- Cola local en Isar (`SyncOperationModel`)
- Worker que procesa la cola cuando hay conectividad
- Idempotency keys para evitar duplicados
- Política de conflictos documentada por módulo
- Primer flujo e2e: transactions

### Fase 8 — Entorno reproducible
- Documentación completa en `docs/DEVELOPMENT_SETUP.md`
- Scripts de inicialización y reset

### Fase 9 — Testing
- Tests unitarios backend
- Tests de integración API
- Tests de aislamiento multi-tenant
- Tests de sincronización offline

### Fase 10 — Documentación y PR
- Actualizar README, agents.md
- Crear documentación de arquitectura
- PR hacia `develop`

---

## 6. Riesgos y Mitigaciones

| Riesgo | Mitigación |
|--------|------------|
| Dart Frog no soporta Argon2id nativo | Usar `dbcrypt` (bcrypt) como alternativa si Argon2id no tiene paquete Dart mantenido |
| `pubspec.lock` ignorado en `.gitignore` | Evaluar si el backend necesita su propio lock file committed |
| Modelos Isar sin `tenantId` | No modificar los modelos Isar existentes inicialmente; el tenant scoping se aplica en el backend |
| `double` para montos en Flutter | Mantener `double` en Isar/Flutter UI; usar `NUMERIC` en PG y `int` centavos en DTOs de API |
| Compatibilidad Dart Frog con Dart 3.13 | Verificar versiones compatibles antes de iniciar |
