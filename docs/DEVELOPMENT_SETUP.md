# Guía de Configuración del Entorno de Desarrollo

## Requisitos previos

- **Flutter SDK** 3.47+ (recomendado vía FVM)
- **Dart SDK** 3.13+
- **Docker** y **Docker Compose** (para PostgreSQL)
- **Git**

---

## 1. Clonar y preparar

```bash
git clone https://github.com/GrullonDev/negocio_listo_pro.git
cd negocio_listo_pro
git checkout develop
```

## 2. Levantar PostgreSQL

```bash
docker compose up -d
```

Esto inicia un contenedor PostgreSQL 16 en el puerto 5432 con:
- Usuario: `negociolisto`
- Contraseña: `change_me_in_dev`
- Base de datos: `negociolisto_dev`

El volumen `pgdata` persiste los datos entre reinicios.

### Verificar conexión

```bash
docker exec -it negociolisto-db psql -U negociolisto -d negociolisto_dev -c "SELECT 1"
```

## 3. Ejecutar migraciones

```bash
docker exec -i negociolisto-db psql -U negociolisto -d negociolisto_dev < backend/migrations/001_initial_schema.sql
docker exec -i negociolisto-db psql -U negociolisto -d negociolisto_dev < backend/migrations/002_seed_demo.sql
docker exec -i negociolisto-db psql -U negociolisto -d negociolisto_dev < backend/migrations/003_sync_indexes.sql
```

## 4. Configurar el backend

```bash
cd backend
cp .env.example .env
# Editar .env si es necesario (los valores por defecto funcionan con Docker Compose)
```

### Instalar dependencias del backend

```bash
fvm dart pub get
```

### Iniciar Dart Frog

```bash
fvm dart pub global activate dart_frog_cli
dart_frog dev
```

El servidor estará en `http://localhost:8080`.

### Verificar health check

```bash
curl http://localhost:8080/health
```

## 5. Ejecutar Flutter

```bash
cd ..  # volver a la raíz del proyecto
fvm flutter pub get
fvm flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

### URLs de API según dispositivo

| Dispositivo | URL base |
|---|---|
| Android Emulator | `http://10.0.2.2:8080` |
| iOS Simulator | `http://localhost:8080` |
| Dispositivo físico (LAN) | `http://<IP_LAN>:8080` |

Para encontrar tu IP LAN:
- Windows: `ipconfig` → buscar dirección IPv4
- Mac/Linux: `ifconfig` o `ip addr`

### Notas sobre HTTP local en Android

Android bloquea HTTP sin TLS por defecto. El proyecto incluye la configuración de `android:usesCleartextTraffic="true"` para desarrollo. **No usar en producción.**

## 6. Ejecutar tests

```bash
# Tests de Flutter
fvm flutter test

# Tests del backend
cd backend
fvm dart test
```

## 7. Reiniciar la base de datos

### Mantener estructura, borrar datos

```bash
docker exec -i negociolisto-db psql -U negociolisto -d negociolisto_dev -c "
  TRUNCATE sync_operations, coupon_redemptions, loyalty_events,
           coupons, bookings, transactions, customers,
           refresh_tokens, users, tenants CASCADE;
"
# Re-ejecutar seed
docker exec -i negociolisto-db psql -U negociolisto -d negociolisto_dev < backend/migrations/002_seed_demo.sql
```

### Destruir todo y recrear (⚠️ destructivo)

```bash
docker compose down -v  # Elimina el volumen pgdata
docker compose up -d
# Re-ejecutar migraciones
docker exec -i negociolisto-db psql -U negociolisto -d negociolisto_dev < backend/migrations/001_initial_schema.sql
docker exec -i negociolisto-db psql -U negociolisto -d negociolisto_dev < backend/migrations/002_seed_demo.sql
docker exec -i negociolisto-db psql -U negociolisto -d negociolisto_dev < backend/migrations/003_sync_indexes.sql
```
