# Demo comercial: NegocioListo Pro

Guion de 6 minutos para presentar la app a dueños de negocios de servicios (salón, barbería, clínica, spa). Todo lo que aparece aquí existe hoy en la app. No prometas en la demo nada que no esté en esta lista (ver [Qué NO mostrar](#6-qué-no-mostrar-todavía)).

---

## 0. Preparación (10 min antes)

```bash
# Ensayo: borra los datos y vuelve a sembrarlos en cada arranque
fvm flutter run --dart-define=BRAND=salon --dart-define=DEMO_RESET=true

# Demo real: siembra solo si la base está vacía (lo que agregues en vivo se conserva)
fvm flutter run --dart-define=BRAND=salon
```

| Flag         | Valores                                   | Efecto                              |
| ------------ | ----------------------------------------- | ----------------------------------- |
| `BRAND`      | `default`, `salon`, `barberia`, `clinica` | Nombre, lema, colores y moneda      |
| `DEMO_RESET` | `true` / `false` (defecto)                | Borra y vuelve a sembrar al iniciar |
| `DEMO_SEED`  | `true` (defecto) / `false`                | Pon `false` en builds de producción |

Checklist:

- [ ] Elige la marca que más se parezca al cliente (o crea la suya, ver §4).
- [ ] Cierra la sesión antes de empezar, para arrancar en el login con su marca.
- [ ] Credenciales: `demo@negociolisto.pro` / `demo1234`.
- [ ] Modo avión activado. Refuerza el argumento "funciona sin internet".
- [ ] Brillo al máximo y notificaciones silenciadas.

Todas las fechas del seed son relativas al día de hoy: la agenda siempre muestra citas **hoy** y el dashboard siempre muestra los **últimos 30 días**.

---

## 1. Guion del recorrido (6 min)

La historia es **"Un día en tu negocio"**: de la mañana al cierre de caja, en una sola pantalla.

| #   | Tiempo    | Pantalla          | Acción exacta                                                                                                                                                 | Qué decir (idea clave)                                                      |
| --- | --------- | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| 1   | 0:00–0:30 | **Login**         | Muestra el logo, el nombre y el lema del cliente. Entra.                                                                                                      | "Esta ya es _tu_ app, con tu nombre y tus colores."                         |
| 2   | 0:30–1:30 | **Dashboard**     | Señala Ingresos (RD$273,700), Gastos (RD$47,900) y Balance neto (RD$225,800). Baja a los movimientos recientes.                                               | "Así cerraste el mes, sin abrir un cuaderno ni Excel."                      |
| 3   | 1:30–2:45 | **Citas**         | La agenda de hoy muestra 7 citas y el % de ocupación. **Toca la cita de Carmen Reyes (Por confirmar) → Confirmada.** Mira cómo sube la ocupación.             | "Tu cliente confirmó por WhatsApp: un toque y todo el equipo lo ve."        |
| 4   | 2:45–3:30 | **Citas → +**     | Crea una cita nueva para hoy a nombre del cliente que tienes enfrente. Sale como "Por confirmar".                                                             | "Agendar toma 10 segundos. Nada de libretas."                               |
| 5   | 3:30–4:30 | **Clientes**      | Muestra los niveles Bronce→Platino. Abre a María Fernández (Platino, 1,240 pts). **Súmale puntos** por la visita de hoy.                                      | "Sabes quiénes son tus mejores clientes y los premias para que vuelvan."    |
| 6   | 4:30–5:30 | **Cupones**       | Muestra los 4 cupones: activo, casi agotado (41/50) y vencido. **Canjea `BIENVENIDA15`** con el botón de escáner. Intenta `VERANO10` para mostrar el rechazo. | "El sistema controla las promociones: nadie usa un cupón vencido."          |
| 7   | 5:30–6:00 | **Dashboard → +** | Registra la venta de la cita confirmada. Muestra cómo cambian los totales.                                                                                    | "Venta registrada = número actualizado. Esto es tu negocio en tiempo real." |

**Cierre (fuera de la app):** "¿Cuántas horas a la semana pasas hoy cuadrando citas, clientes y caja? Con esto son minutos. ¿Lo configuramos con tu logo esta semana?"

> **Nota sobre el "pipeline":** la app no tiene un módulo de leads o embudo de ventas. El equivalente honesto es el ciclo de vida de la cita: **Por confirmar → Confirmada → Completada / Cancelada**. Preséntalo como "seguimiento de cada cliente, de la reserva al cobro".

---

## 2. Estrategia de datos de prueba (seed)

Implementado en [lib/core/demo/demo_seeder.dart](../lib/core/demo/demo_seeder.dart). Los datos son deterministas: los totales son iguales en cada ensayo.

| Módulo       | Qué carga                                                                                                              | Por qué                                                                       |
| ------------ | ---------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| **Finanzas** | 75 ventas en 30 días (2–3 al día, RD$600–7,500) + 2 ventas hoy + 6 gastos fijos (alquiler, luz, insumos)               | Margen sano (~82%) y un feed con actividad de hoy                             |
| **Citas**    | 7 hoy (2 completadas, 3 confirmadas, 2 por confirmar), 7 en los próximos 4 días y 3 de historial (incluye 1 cancelada) | La agenda de hoy se ve llena y hay citas "Por confirmar" para cambiar en vivo |
| **Clientes** | 12 clientes con teléfonos 809/829/849 y todos los niveles (1 Platino, 3 Oro, 3 Plata, 5 Bronce)                        | Los niveles y las visitas se ven creíbles                                     |
| **Cupones**  | `BIENVENIDA15` (activo), `MADRES2026` (41/50, casi agotado), `REFIERE500` (monto fijo), `VERANO10` (vencido)           | Muestra tanto el canje exitoso como el rechazo                                |

Reglas para adaptar el seed a otro cliente:

1. **Usa su vocabulario.** Para una clínica, cambia `_services` por "Limpieza dental", "Blanqueamiento", etc. Solo hay que editar dos listas.
2. **Usa sus precios reales**, o un rango parecido. Un precio absurdo destruye la credibilidad.
3. **Nombres locales y comunes.** Nunca uses datos de clientes reales del prospecto.
4. **Deja siempre 1–2 citas "Por confirmar" hoy**: son el momento "wow" de la demo.

---

## 3. Argumentos de venta (pitch)

| Módulo    | Dolor del cliente                              | Frase gancho                                                                      | Ahorro que puedes cuantificar  |
| --------- | ---------------------------------------------- | --------------------------------------------------------------------------------- | ------------------------------ |
| Dashboard | "No sé si este mes gané o perdí."              | "Tu balance del mes en 3 segundos, no en 3 horas de Excel."                       | ~3 h/semana de cuadre          |
| Citas     | Dobles reservas y clientes que no llegan       | "Cada cita tiene un estado. Sabes quién confirmó y quién no."                     | Menos huecos en la agenda      |
| Clientes  | Los clientes se van a la competencia           | "Un cliente que regresa cuesta 5 veces menos que uno nuevo. Aquí sabes quién es." | Más visitas repetidas          |
| Cupones   | Promociones sin control y descuentos regalados | "Tú defines cuántos usos y hasta cuándo. El sistema dice que no por ti."          | Cero fuga por cupones vencidos |
| Offline   | El internet se cae                             | "Funciona sin internet. Tus datos viven en tu teléfono."                          | Cero tiempo muerto             |
| Todo      | Muchas apps sueltas (WhatsApp, libreta, Excel) | "Una sola app para tu día completo."                                              | Menos herramientas que pagar   |

Respuestas a objeciones comunes:

- **"Es caro."** Si recupera un solo cliente al mes, ¿cuánto vale eso?
- **"No tengo tiempo de aprender."** Lo que acabas de ver dura 6 minutos. Eso es todo el entrenamiento.
- **"¿Y mis datos?"** Se guardan en tu dispositivo. No dependen de un servidor externo.

---

## 4. Personalización de marca (white-label)

Implementado en [lib/core/branding/brand_config.dart](../lib/core/branding/brand_config.dart).

Qué cambia con la marca:

- **Nombre del negocio y lema** en el login y en el título de la app.
- **Color primario, contenedor y secundario:** botones, FAB, navegación, agenda y tarjetas. Todo el sistema de diseño se re-colorea desde un solo lugar ([AppTheme.forBrand](../lib/core/theme/app_theme.dart)).
- **Símbolo de moneda** (`RD$`, `$`, `Q`…) en el dashboard, los movimientos y los cupones.

**Truco de demo:** ten dos builds instalados (por ejemplo `salon` y `barberia`) y cambia entre ellos delante del cliente. Ver la misma app con otra identidad en 5 segundos es más convincente que cualquier explicación.

**Crear la marca de un prospecto (5 min):** agrega una entrada a `BrandConfig.presets`:

```dart
'donpepe': BrandConfig(
  key: 'donpepe',
  businessName: 'Spa Don Pepe',
  tagline: 'Relájate, nosotros agendamos',
  primary: Color(0xFF2E5E4E),         // color de su logo / letrero
  primaryContainer: Color(0xFF3F7A66),
  secondary: Color(0xFFC9A227),
  currencySymbol: 'Q', // GTQ – Quetzal
),
```

Luego ejecuta `fvm flutter run --dart-define=BRAND=donpepe`. Saca los colores de su Instagram o de su letrero. Llegar con _su_ marca ya puesta cierra ventas.

---

## 5. Pendiente para una personalización más completa

| Mejora                                                                            | Esfuerzo | Impacto en ventas                       |
| --------------------------------------------------------------------------------- | -------- | --------------------------------------- |
| Logo del cliente (imagen) en el login, en lugar de la inicial                     | Bajo     | Alto                                    |
| Nombre del _tenant_ en el AppBar del home                                         | Bajo     | Medio                                   |
| Icono y nombre del app por cliente (flavors + `flutter_launcher_icons`)           | Medio    | Alto                                    |
| Marca configurable en tiempo de ejecución (sin recompilar)                        | Medio    | Alto para vender como SaaS              |
| Datos aislados por tenant (hoy todos los usuarios comparten los datos de negocio) | Medio    | Requisito antes de vender multi-negocio |

---

## 6. Qué NO mostrar todavía

- **Leads, embudo de ventas o catálogo de productos/inventario:** no existen. Si preguntan, di "está en el roadmap".
- **Varios negocios en un mismo dispositivo:** los datos de negocio todavía no se separan por tenant.
- **Reportes exportables o sincronización en la nube:** no existen.
- **La cuenta `test`/`test`:** úsala solo para desarrollo.
