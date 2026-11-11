# Backend — NegocioListo Pro

Backend REST API construido con [Dart Frog](https://dartfrog.vgv.dev/) y PostgreSQL.

## Estructura

```
backend/
├── lib/src/
│   ├── config/        # Variables de entorno
│   ├── database/      # Pool de conexiones PostgreSQL
│   ├── common/        # Helpers JSON y validación
│   ├── auth/          # JWT, bcrypt, servicio de autenticación
│   ├── transactions/  # Servicio de transacciones financieras
│   ├── bookings/      # Servicio de citas
│   ├── customers/     # Servicio de clientes y puntos
│   └── coupons/       # Servicio de cupones y canjes
├── routes/
│   ├── _middleware.dart          # CORS, logging, providers
│   ├── health.dart               # GET /health
│   └── api/v1/
│       ├── _middleware.dart      # Auth JWT middleware
│       ├── auth/                 # register-business, login, me, logout
│       ├── transactions.dart     # GET/POST /api/v1/transactions
│       ├── dashboard/summary.dart
│       ├── bookings/             # GET/POST + PATCH /:id
│       ├── customers/            # GET/POST + GET /:id + POST /:id/points
│       └── coupons/              # GET/POST + POST /redeem
├── migrations/                   # SQL versionadas
├── .env.example
└── pubspec.yaml
```

## Endpoints

| Método | Ruta | Auth | Descripción |
|--------|------|------|-------------|
| GET | /health | No | Health check |
| POST | /api/v1/auth/register-business | No | Registrar negocio + owner |
| POST | /api/v1/auth/login | No | Login → JWT |
| GET | /api/v1/auth/me | Sí | Sesión actual |
| POST | /api/v1/auth/logout | Sí | Cerrar sesión |
| GET | /api/v1/dashboard/summary | Sí | Métricas financieras |
| GET/POST | /api/v1/transactions | Sí | Listar/crear transacciones |
| GET/POST | /api/v1/bookings | Sí | Listar/crear citas |
| PATCH | /api/v1/bookings/:id | Sí | Actualizar estado de cita |
| GET/POST | /api/v1/customers | Sí | Listar/crear clientes |
| GET | /api/v1/customers/:id | Sí | Detalle de cliente |
| POST | /api/v1/customers/:id/points | Sí | Agregar puntos |
| GET/POST | /api/v1/coupons | Sí | Listar/crear cupones |
| POST | /api/v1/coupons/redeem | Sí | Canjear cupón |
