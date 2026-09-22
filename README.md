# 🚀 NegocioListo Pro | Enterprise Mobile & Web Demo

> Plataforma multi-inquilino offline-first diseñada para escalar micronegocios hacia la digitalización total. Desarrollada como demostración de arquitectura de software multiplataforma.

---

## 🏛️ Decisiones de Arquitectura

Este proyecto implementa **Clean Architecture** combinada con un enfoque **Feature-First**, garantizando:

1. **Desacoplamiento total:** la lógica de negocio (`Domain`) no depende de frameworks de UI ni de bases de datos externas.
2. **Offline-First Resilience:** capacidad de operar al 100% sin conexión a internet, utilizando almacenamiento local persistente con sincronización automática en segundo plano al recuperar conectividad.
3. **Multiplataforma Real:** una única base de código optimizada para compilar fluidamente en Android, iOS y Web.

---

## 🧩 Módulos del Sistema

- **Dashboard Financiero:** métricas en tiempo real, control de caja y gráficos de rendimiento.
- **Gestión de Órdenes y Citas:** sistema modular adaptable tanto a comercios de productos como de servicios.
- **Sincronización Inteligente:** resolución de conflictos de datos locales vs. nube.

---

## 🛠️ Stack Tecnológico

| Categoría | Tecnología |
|---|---|
| Framework | [Flutter](https://flutter.dev) (SDK ^3.13.1) |
| Persistencia local | [isar_plus](https://pub.dev/packages/isar_plus) |
| Inyección de dependencias | [get_it](https://pub.dev/packages/get_it) |
| Cliente HTTP / Sync remoto | [dio](https://pub.dev/packages/dio) |

> El proyecto se encuentra en fase inicial de desarrollo; el stack se ampliará conforme se implementen los módulos descritos arriba.

---

## 📂 Estructura del Proyecto

Se seguirá una organización **Feature-First** dentro de `lib/`, separando cada módulo en sus propias capas `data`, `domain` y `presentation`, con un núcleo (`core`) compartido para servicios transversales (inyección de dependencias, networking, base de datos local).

```
lib/
├── core/          # Servicios compartidos, DI, networking, sincronización
├── features/      # Módulos: dashboard, órdenes/citas, sincronización, etc.
└── main.dart
```

---

## ▶️ Getting Started

```bash
flutter pub get
flutter run
```

Recursos para primeros pasos con Flutter:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)
