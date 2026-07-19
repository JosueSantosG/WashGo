# Documentación Técnica Oficial — WashGo

**Versión:** 1.0.0+1  
**Fecha del documento:** 16 de julio de 2026  
**Fecha límite de publicación:** 31 de julio de 2026  
**Analista Técnico:** Senior Product Technical Analyst  
**Stack:** Flutter + Firebase + PostgreSQL (Data Connect)

---

## 1. Resumen Ejecutivo

WashGo es una plataforma multi-tenant de lavandería que conecta clientes con negocios de lavandería (Dueños), empleados de lavandería y un administrador global (SuperAdmin). Desarrollada en Flutter (multiplataforma: iOS, Android, Web, Desktop) con backend en Firebase (Auth, Cloud Functions v2, Storage, Crashlytics, App Check) y base de datos PostgreSQL con GraphQL nativo mediante Firebase Data Connect.

El sistema se encuentra en un 85-90% de desarrollo funcional. El frontend Flutter está completo en la mayoría de sus pantallas por rol (cliente, empleado, dueño, superadmin). La infraestructura de pagos soporta 5 métodos: PayPal (API real + simulador), PayPhone (Links API), Transferencia Bancaria (carga de comprobante + revisión), Efectivo y Prepago (saldo por consumo). El backend Cloud Functions implementa toda la lógica de negocio: creación y captura de órdenes de pago, verificación asíncrona, generación de facturas en PDF, subida y revisión de comprobantes, consumo de prepago con idempotencia, y limpieza programada de órdenes expiradas cada 15 minutos.

El principal riesgo a la fecha es el bajo cubrimiento de pruebas (10 tests) y la necesidad de cumplir con el requisito de 14 días de Closed Testing en Google Play que, comenzando hoy 16 de julio, consume el ciclo hasta el 30 de julio, dejando un solo día hábil para publicación. La funcionalidad flujo completo (sin login hasta reserva, pagos con PayPal real, PayPhone, transferencias, facturación electrónica) está operativa.

---

## 2. Arquitectura del Sistema

### 2.1 Diagrama de Capas

```
┌────────────────────────────────────────────────────────────┐
│                    CLIENTE (Flutter)                         │
│  iOS / Android / Web / Desktop                              │
│  GoRouter + RefreshListenable (Auth State)                  │
├────────────────────────────────────────────────────────────┤
│                    SERVICIOS (Firebase)                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌───────────┐  │
│  │ Auth     │  │ Storage  │  │Crashlytcs│  │ App Check │  │
│  └──────────┘  └──────────┘  └──────────┘  └───────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │           Cloud Functions v2 (index.js)              │  │
│  │  PayPal | PayPhone | Bank Transfer | Invoice |       │  │
│  │  Prepaid | Cleanup (cron cada 15 min)               │  │
│  └──────────────────────────────────────────────────────┘  │
├────────────────────────────────────────────────────────────┤
│               DATA LAYER (Firebase Data Connect)            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │        PostgreSQL + GraphQL (schema.gql)             │  │
│  │  20+ tablas, 50+ queries, 30+ mutations             │  │
│  │  3 niveles de auth: PUBLIC | USER | NO_ACCESS        │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────┘
```

### 2.2 Stack Tecnológico

| Componente | Tecnología | Versión/Detalle |
|---|---|---|
| Frontend | Flutter | SDK ^3.11.1, Dart 3.x |
| Autenticación | Firebase Auth | Email/Password, Google Sign-In |
| Base de datos | PostgreSQL via Firebase Data Connect | GraphQL nativo |
| Backend serverless | Firebase Cloud Functions v2 | Node.js (index.js, ~1500 líneas) |
| Almacenamiento | Firebase Storage | Comprobantes de pago, facturas PDF |
| Monitoreo | Firebase Crashlytics | Solo producción, no web |
| Seguridad | Firebase App Check | Habilitado en firebase.json |
| Hosting web | Firebase Hosting | Callbacks de pago (5 HTML) |
| Ruteo | go_router | 6.0+, con refreshListenable |
| Mapas | flutter_map + geolocator | OpenStreetMap (sin Google Maps) |
| Facturación PDF | pdf + printing | Generación local + URL firmada |
| Testing | flutter_test | 10 archivos de prueba |

### 2.3 Modelo de Datos (PostgreSQL + Data Connect)

**20 tablas definidas en `dataconnect/schema/schema.gql`:**

| Tabla | Propósito | Relaciones clave |
|---|---|---|
| User | Usuarios multi-rol | Owns Business, es cliente/empleado |
| Business | Negocio de lavandería | Owner (User), Employees |
| BusinessHour | Horarios por día | Business |
| BusinessEmployee | Asignación empleado-negocio | Business, User |
| EmployeeRequest | Solicitudes de empleo | Business, User |
| Service | Servicio ofrecido | Business, precio por tamaño |
| Order | Órdenes de servicio | Business, Client, Employee, Service |
| Invoice | Factura por orden | Order (1:1) |
| InvoiceItem | Ítems de factura | Invoice |
| Review | Calificaciones post-servicio | Order (1:1), Business |
| Vehicle | Vehículo del cliente | Client (User), Model |
| VehicleBrand | Marca de vehículo | — |
| VehicleModel | Modelo de vehículo | Brand |
| Notification | Notificaciones in-app | User |
| PrepaidHistory | Consumos de prepago | Business |
| PrepaidServiceMetric | Métricas por servicio | Business, Service |
| BusinessReservationConfig | Config. reservas | Business (1:1) |
| OrderReservation | Cita agendada | Order (1:1) |
| PaymentProof | Comprobante transferencia | Order (1:1) |
| OrderLog | Auditoría de orden | Order |

**Enums principales:**

| Enum | Valores |
|---|---|
| UserRole | CLIENTE, EMPLEADO, ADMINISTRADOR, SUPER_ADMIN |
| OrderStatus | PENDIENTE_PAGO, EN_COLA, ACEPTADO, EN_CAMINO, EN_SERVICIO, COMPLETADO, CANCELADO |
| PaymentMethod | PAYPAL, CASH, TRANSFERENCIA_BANCARIA, PAYPHONE |
| ServiceType | LOCAL, DOMICILIO |
| BusinessStatus | PENDING_APPROVAL, APPROVED, REJECTED, INACTIVE |
| EmployeeStatus | UNASSIGNED, PENDING, ACTIVE, REJECTED |
| InvoiceStatus | PENDING, GENERATED, FAILED |
| PaymentProofStatus | PENDING, APPROVED, REJECTED |
| PaymentAccountType | GUAYAQUIL, PICHINCHA |

### 2.4 Niveles de Autenticación en Queries

- **PUBLIC** — Sin autenticación. Ej: `GetAllBusinesses`, `GetBusinessServices`, `GetGlobalAppRatings`
- **USER** — Usuario autenticado. Ej: `GetClientOrders`, `GetMyVehicles`, `GetMyBusinesses`
- **NO_ACCESS** — Solo ejecutable desde Cloud Functions (Admin SDK). Ej: `ServerGetOrderById`, `CompleteOrderWithInvoiceOnly`, `CreatePaymentProof`

### 2.5 Seguridad (Permission Checks)

Control de acceso granular mediante directivas `@check` y `@redact` en GraphQL. Patrones de validación:

- **Propietario de negocio:** `business.owner.id == auth.uid`
- **SuperAdmin:** `auth.token.email == 'root@washgo.com' || 'SUPER_ADMIN' in this.roles`
- **Empleado asignado:** `order.employeeId == auth.uid`
- **Propietario de orden:** `order.clientId == auth.uid`
- **Multi-rol combinado:** Operador `exists()` para verificar membresía en array de roles
- **Auto-asignación de roles:** Bloqueada — un usuario no puede asignarse ADMINISTRADOR o SUPER_ADMIN a sí mismo

### 2.6 Flujo de Autenticación

1. **Splash** → router guard verifica auth state
2. **No auth** → `/login` o `/register`
3. **Auth presente** → `/auth-gate` (verifica roles del usuario)
   - Sin roles → `/role-selection`
   - 1 rol → auto-asignado
   - Múltiples roles → selector manual
4. **Redirección por rol:** Cliente → dashboard cliente, Empleado → dashboard empleado (con chequeo de status), Dueño → dashboard dueño, SuperAdmin → dashboard SuperAdmin
5. **Guest flow (sin login):** BookingIntentManager (SharedPreferences, TTL 24h) permite crear reserva sin autenticación; al final del flujo se fuerza registro/login
6. **RefreshListenable:** `AppRouterRefreshNotifier` suscribe a cambios de auth + user subscription para navegación reactiva

### 2.7 Flujo de Órdenes (Ciclo de Vida)

```
PENDIENTE_PAGO ──► EN_COLA ──► ACEPTADO ──► EN_CAMINO ──► EN_SERVICIO ──► COMPLETADO
       │                                                                    │
       └──(cleanup 30 min)──► CANCELADO       CANCELADO ◄──────────────────┘
```

- **PENDIENTE_PAGO:** Solo transferencia bancaria (espera comprobante)
- **EN_COLA:** Pagos electrónicos confirmados (PayPal, PayPhone, Efectivo, Prepago)
- **Aceptación:** Solo un empleado puede tomar la orden (race condition prevenida con `@check` en Data Connect)
- **Completado:** Requiere factura (generación de PDF con número único `FAC-YYYYMMDD-[6 hex chars]`)

---

## 3. Documentación por Rol de Usuario

Cada sección utiliza la plantilla de 4 campos: **Qué hace**, **Cómo funciona / Detalle técnico**, **Por qué se hizo así**, **Estado real**.

---

### 3.1 Rol: Cliente

#### 3.1.1 Registro y Autenticación

**Qué hace:** El cliente se registra con email/contraseña o Google Sign-In, asigna su rol CLIENTE, completa su perfil (nombre, teléfono, foto opcional) y accede al dashboard.

**Cómo funciona / Detalle técnico:** El registro utiliza Firebase Auth (`createUserWithEmailAndPassword`) + mutación `UpsertUser` que inserta o actualiza el usuario en PostgreSQL usando `auth.uid` como clave primaria. El número de teléfono se almacena en una mutación separada (`UpdateUserPhone`). El flujo completo está mediado por `FirebaseAuthRepository` (implementación concreta de `AuthRepository` abstracto). El router guard en `route_guards.dart` fuerza la captura de teléfono antes de permitir la navegación principal.

**Por qué se hizo así:** Separar autenticación (Firebase Auth) de perfil (PostgreSQL) permite usar los servicios nativos de Firebase (reset password, verificación email) mientras se mantienen datos relacionales en PostgreSQL con joins y checks granulares.

**Estado real:** COMPLETO. Registro email/password, Google Sign-In, guest flow, captura de teléfono, multi-sesión.

#### 3.1.2 Explorar Negocios y Servicios

**Qué hace:** El cliente ve una lista de lavanderías disponibles con sus servicios, precios por tamaño de vehículo (pequeño, mediano, grande, moto), horarios de atención y ubicación en mapa.

**Cómo funciona / Detalle técnico:** Queries públicas (`GetAllBusinesses`, `GetBusinessServices`, `GetBusinessReservationConfig`) sin autenticación. Los negocios se filtran por `status: APPROVED`. Las ubicaciones se almacenan como latitud/longitud y se visualizan con flutter_map + OpenStreetMap. Los precios se muestran con dos modalidades: precios pendientes de aprobación (precioOwner*) vs precios aprobados por SuperAdmin (precio*).

**Por qué se hizo así:** Flutter_map evita dependencia de Google Maps (sin API key, sin costos adicionales). La separación precioOwner* / precio* permite que dueños sugieran precios que requieren aprobación del SuperAdmin antes de publicarse.

**Estado real:** COMPLETO. Vista de negocios, servicios, mapa, horarios. Sin embargo, no hay búsqueda por texto ni filtros por tipo de servicio en la UI.

#### 3.1.3 Crear Reserva (Booking Flow)

**Qué hace:** El cliente selecciona servicio, vehículo, método de pago, agenda fecha/hora y crea una orden de lavandería.

**Cómo funciona / Detalle técnico:** El flujo completo gestiona: selección de servicio y vehículo (con diálogos de creación/edición de vehículo), selección de método de pago (pantalla `payment_selection_page.dart` que condiciona el flujo posterior), agendamiento vía `OrderReservation` con capacidad simultánea y tiempo de anticipación configurados por el dueño. El `BookingIntentManager` permite persistir la intención de reserva en SharedPreferences (24h TTL) para flujo sin login. Las observaciones se parsean con `observations_parser.dart` para extraer notas estructuradas.

**Por qué se hizo así:** El patrón de intención de reserva (BookingIntent) desacopla la creación de la orden del momento del pago, permitiendo que el cliente explore y configure sin presión. SharedPreferences evita llamadas de red innecesarias.

**Estado real:** COMPLETO. Flujo completo de reserva con selección de vehículo, servicio, pago y agendamiento. Guest flow operativo.

#### 3.1.4 Pagos

##### PayPal

**Qué hace:** El cliente paga con PayPal en un diálogo embebido con dos modos: Simulador interactivo (sin credenciales reales) y API real de PayPal REST (Sandbox o Producción).

**Cómo funciona / Detalle técnico:** `PaypalService` maneja la configuración (modo simulado vs real, sandbox vs producción). El modo real usa `PaypalBackendService` que obtiene OAuth2 token (con Client ID + Secret desde variables de entorno de Flutter), crea orden en PayPal v2/checkout/orders, redirige al navegador para aprobación, y captura el pago vía `captureOrder`. El modo simulado emula login sandbox y genera un PAYID simulado. El backend Cloud Functions expone `create-order` y `complete-paypal-payment`. Callback HTML en `public/paypal-callback/success.html` redirige vía deep link `washgo://`.

**Por qué se hizo así:** El simulador permite desarrollo y testing sin cuentas PayPal reales. La API REST real está disponible para producción. Las credenciales se inyectan como variables de entorno de compilación (`--dart-define`).

**Estado real:** COMPLETO con advertencia CORS conocida para web. El simulador es completamente funcional. La API real funciona en dispositivos móviles. Las credenciales de producción no están inyectadas en el código — deben configurarse en el CI/CD.

##### PayPhone

**Qué hace:** El cliente paga con PayPhone (servicio ecuatoriano). PayPhone abre su propia interfaz, redirige al callback de WashGo, y la app verifica asincrónicamente que el pago fue aprobado.

**Cómo funciona / Detalle técnico:** El backend (`functions/index.js`) tiene 4 endpoints: `payphone/prepare` (crea sesión con IVA 15% incluido, retorna URL de redirección a PayPhone Links API), `payphone/callback/success` (endpoint POST que PayPhone llama al completar, ejecuta verify + store-transaction con idempotencia), `payphone/verify` (endpoint GET público para leer estado de transacción), y `complete-payphone-payment` (verifica con PayPhone API y actualiza orden a EN_COLA). El cliente pasa por `PayphoneSuccessPage` que primero almacena el transactionId via `store-transaction` (endpoint público de seguridad), luego completa el pago llamando al backend. Si Data Connect no está disponible (503), se guarda el ID para recuperación con botón "Ya pagué – Verificar".

**Por qué se hizo así:** La arquitectura asíncrona de PayPhone (callback POST vs espera síncrona) requiere el patrón de store-transaction + verify. La redirección a través del navegador (Hostinger/Firebase Hosting) maneja el deep link de retorno a la app.

**Estado real:** COMPLETO. Flujo prepare → PayPhone → callback → store → verify → complete. Manejo de casos borde: DB no disponible, timeouts, idempotencia en callback. Deep links configurados.

##### Transferencia Bancaria

**Qué hace:** El cliente selecciona transferencia bancaria, ve instrucciones con datos de cuenta (Guayaquil o Pichincha), realiza la transferencia externamente, y sube un comprobante (foto) para revisión del SuperAdmin.

**Cómo funciona / Detalle técnico:** La orden se crea con estado `PENDIENTE_PAGO`. El cliente sube la imagen del comprobante a Firebase Storage vía Cloud Function (`upload-proof`), que verifica que no exista un comprobante PENDING duplicado. El SuperAdmin revisa en `admin_payment_review_page.dart` y puede aprobar o rechazar. Al aprobar, el backend genera factura, actualiza orden a COMPLETADO y notifica al cliente. El endpoint `proof-status` es público (sin auth) para que el cliente consulte el estado de su comprobante. Tres cuentas bancarias disponibles: Guayaquil (ahorros y corriente) y Pichincha (ahorros).

**Por qué se hizo así:** El flujo de transferencia bancaria requiere intervención manual del SuperAdmin (revisión de comprobante) por naturaleza. No es automatizable sin un sistema de conciliación bancaria. La orden queda en PENDIENTE_PAGO para evitar stock reservado sin pago confirmado.

**Estado real:** COMPLETO. Instrucciones, subida de comprobante, revisión por SuperAdmin, aprobación/rechazo, notificación. Sin embargo, el cleanup automático cada 15 minutos cancela órdenes PENDIENTE_PAGO con más de 30 minutos de antigüedad — esto puede ser agresivo para transferencias bancarias reales donde el cliente puede tardar más en subir el comprobante.

##### Efectivo

**Qué hace:** El cliente selecciona pago en efectivo, la orden se crea directamente en EN_COLA con un recargo del 15% sobre el precio base (IVA incluido).

**Cómo funciona / Detalle técnico:** No hay flujo de pago externo. La orden se marca como EN_COLA inmediatamente. En la UI (`payment_selection_page.dart`) se aplica el 15% adicional visualmente antes de crear la orden. No se genera comprobante de pago hasta la factura al completar el servicio.

**Por qué se hizo así:** El pago en efectivo es el método más simple. El 15% adicional incentiva el uso de métodos electrónicos y cubre el riesgo de impago para el negocio.

**Estado real:** COMPLETO. Selección, cálculo de IVA 15%, creación de orden inmediata.

##### Prepago

**Qué hace:** El dueño del negocio carga saldo prepago (saldoPrepagoInicial) que se consume por servicio prestado. El cliente (asociado al negocio) se beneficia del saldo prepagado.

**Cómo funciona / Detalle técnico:** El negocio tiene `saldoPrepagoInicial` y `saldoPrepagoConsumido`. Al completar una orden vía prepago, el backend: (1) actualiza saldos del negocio, (2) registra en `prepaidHistory` el consumo, (3) actualiza o crea `prepaidServiceMetric`. La lógica de consumo está implementada con idempotencia (verificación de duplicados por orderId). El backend expone mutaciones `ConsumePrepaidAndUpdateMetric`, `ConsumePrepaidAndCreateMetric`, y las completas `CompleteOrderWithPrepaidAndUpdateMetric`/`CompleteOrderWithPrepaidAndCreateMetric`. La factura con prepago tiene IVA 18%.

**Por qué se hizo así:** El prepago es un modelo de consumo por servicio. Las métricas permiten al dueño ver qué servicios se consumen más. La separación entre update y create metric maneja el primer consumo (crear) vs consumos subsecuentes (actualizar).

**Estado real:** COMPLETO. Consumo con idempotencia, métricas por servicio, facturación con IVA 18%, historial de consumos.

#### 3.1.5 Historial de Órdenes y Facturas

**Qué hace:** El cliente ve sus órdenes activas y completadas, descarga facturas en PDF o CSV, y califica el servicio recibido.

**Cómo funciona / Detalle técnico:** Queries `GetClientOrders` (órdenes activas), `GetClientHistoryOrdersPaged` (historial paginado), `GetClientInvoices` (facturas). Las facturas se generan como PDF local con la librería `pdf`, se comparten con `share_plus`, y se almacenan en Firebase Storage con URL firmada. El endpoint `regenerate-pdf` permite regenerar facturas. `csv_exporter.dart` y `csv_download_stub.dart`/`csv_download_web.dart` manejan exportación CSV con diferenciación por plataforma.

**Por qué se hizo así:** La generación de PDF local evita dependencia de servicios externos. El sistema de URL firmada permite acceso controlado a facturas sin exponer Storage públicamente.

**Estado real:** COMPLETO. Visualización de historial, descarga de PDF, exportación CSV. La revisión/calificación también está implementada (`review_bottom_sheet.dart`, `CreateReview` mutation).

---

### 3.2 Rol: Empleado

#### 3.2.1 Solicitud y Activación de Empleado

**Qué hace:** Un usuario con rol EMPLEADO solicita unirse a un negocio existente, es aprobado por el dueño, y accede al dashboard de empleado.

**Cómo funciona / Detalle técnico:** El usuario primero selecciona rol EMPLEADO en `role_selection_page.dart`. Luego ingresa un código de negocio (businessCode) en `employee_code_page.dart`. La mutación `RequestEmployeeAccess` crea un `EmployeeRequest` con status PENDING. El dueño ve la solicitud en su tab "Empleados" y usa `ApproveEmployeeRequest` o `RejectEmployeeRequest`. Al aprobar, se actualiza `employeeStatus` a ACTIVE, se crea `BusinessEmployee` y se asigna el `currentBusinessId`. El `onboarding_page.dart` para empleados guía al usuario durante la espera.

**Por qué se hizo así:** El flujo de código de negocio evita que empleados puedan asignarse a negocios arbitrariamente. La aprobación explícita del dueño asegura control sobre quién trabaja en el negocio.

**Estado real:** COMPLETO. Registro, código de negocio, solicitud, aprobación/rechazo, activación. Manejo de estados UNASSIGNED → PENDING → ACTIVE/REJECTED.

#### 3.2.2 Gestión de Órdenes

**Qué hace:** El empleado ve órdenes en cola (EN_COLA), las acepta, actualiza su estado (ACEPTADO → EN_CAMINO → EN_SERVICIO → COMPLETADO), y completa el servicio generando factura.

**Cómo funciona / Detalle técnico:** Queries `GetActiveBusinessOrders` (órdenes activas del negocio donde trabaja), filtradas por status. `AcceptOrder` usa `@check(expr: "this == 'EN_COLA'")` para prevenir race conditions (dos empleados aceptando la misma orden). `UpdateOrderStatus` actualiza el estado. Al completar, `UpdateOrderCompletion` o `CompleteOrderWithInvoiceOnly` genera factura y marca COMPLETADO. El empleado puede registrar observaciones y subir URL de factura. `UpdateEmployeeAvailability` permite al empleado indicar si está disponible para nuevas órdenes.

**Por qué se hizo así:** El check EN_COLA en la mutación previene condiciones de carrera críticas. La disponibilidad del empleado permite a los dueños saber quién está disponible sin comunicación externa.

**Estado real:** COMPLETO. Aceptación de órdenes, actualización de estados, completado con factura, disponibilidad toggle. El dashboard de empleado (`employee_dashboard_page.dart`) incluye tabs de servicio activo, historial y perfil.

#### 3.2.3 Facturación

**Qué hace:** El empleado genera la factura al completar el servicio, visualiza detalles de facturas generadas, y las imprime o comparte.

**Cómo funciona / Detalle técnico:** `employee_service_invoice_detail_page.dart` muestra los detalles de la factura. El backend genera PDF con numeración `FAC-YYYYMMDD-[6 hex chars]`. El invoice cache manager evita regeneraciones innecesarias. Las facturas se listan con `GetEmployeeInvoices`.

**Por qué se hizo así:** La generación al momento de completar asegura que toda orden COMPLETADA tenga factura. El cache manager reduce carga en Storage.

**Estado real:** COMPLETO. Generación de PDF, visualización, compartición.

---

### 3.3 Rol: Dueño / Administrador

#### 3.3.1 Creación y Gestión del Negocio

**Qué hace:** El dueño registra su negocio con datos básicos (nombre, RUC, código único, descripción, teléfono, ubicación en mapa) y gestiona su perfil.

**Cómo funciona / Detalle técnico:** `CreateBusiness` inserta el negocio con `ownerId = auth.uid` y status `PENDING_APPROVAL`. `UpdateBusiness` permite editar datos (solo el dueño, verificado con `@check`). `SwitchCurrentBusiness` permite al dueño con múltiples negocios cambiar el contexto activo. `SuperAdminUpdateBusinessStatus` es llamada por el SuperAdmin para aprobar/rechazar el negocio. La ubicación se selecciona en `map_picker_page.dart`.

**Por qué se hizo así:** El status PENDING_APPROVAL previene que negocios no verificados aparezcan en la app. El RUC y código de negocio son identificadores únicos. Cada negocio es multi-tenant con datos completamente aislados.

**Estado real:** COMPLETO. Creación con mapa, edición, cambio de negocio, aprobación por SuperAdmin. El código de negocio se genera automáticamente.

#### 3.3.2 Gestión de Servicios

**Qué hace:** El dueño crea, edita, activa/desactiva servicios con precios por tamaño de vehículo y tipo (local/domicilio).

**Cómo funciona / Detalle técnico:** `CreateService` inserta servicio con `precioPendiente: true` y precios en campos `precioOwner*` (pendientes de aprobación). `UpdateService` modifica precios y también marca `precioPendiente: true`. `ToggleServiceActive` activa/desactiva. `DeleteService` elimina. `UpdateServiceDetails` solo cambia nombre/descripción/duración sin marcar precio pendiente. El SuperAdmin usa `SuperAdminApproveServicePrice` para copiar precios owner a precios aprobados y activar el servicio.

**Por qué se hizo así:** La separación precioOwner* / precio* implementa un flujo de aprobación de precios donde el SuperAdmin valida los precios sugeridos por el dueño antes de publicarlos. Esto es un requisito específico del modelo de negocio de lavandería.

**Estado real:** COMPLETO. CRUD completo de servicios, flujo de aprobación de precios, activación/desactivación.

#### 3.3.3 Gestión de Empleados

**Qué hace:** El dueño ve solicitudes de empleados pendientes, las aprueba o rechaza, y gestiona empleados activos.

**Cómo funciona / Detalle técnico:** Queries de negocio que listan `EmployeeRequest` con status PENDING. `ApproveEmployeeRequest` es una transacción de 3 pasos: actualiza request a ACTIVE, actualiza user a ACTIVE, crea BusinessEmployee. `RejectEmployeeRequest` revierte el proceso. El tab Empleados del dashboard del dueño muestra lista con estados.

**Por qué se hizo así:** Transacción de 3 pasos asegura consistencia. Si algún paso falla, la base de datos revierte todo.

**Estado real:** COMPLETO. Vista de solicitudes, aprobación, rechazo.

#### 3.3.4 Dashboard y Monitoreo

**Qué hace:** El dueño ve órdenes activas, historial, facturación, reseñas de clientes, configuración del negocio y métricas de prepago.

**Cómo funciona / Detalle técnico:** El dashboard tiene múltiples tabs (`owner_inicio_tab.dart`, `owner_billing_tab.dart`, `services_tab.dart`, `reviews_tab.dart`, `employees_tab.dart`, `owner_configuracion_tab.dart`). Queries: `GetBusinessOrders`, `GetActiveBusinessOrders`, `GetBusinessInvoices`, `GetBusinessReviews`, `GetPrepaidHistory`, `GetPrepaidServiceMetrics`. La configuración incluye horarios, capacidad de reservas y saldo prepago.

**Por qué se hizo así:** Tabs separados permiten crecimiento independiente de cada sección. Las queries de facturación permiten al dueño llevar control financiero dentro de la misma app.

**Estado real:** COMPLETO. Dashboard completo con tabs. Sin embargo, la visualización analítica es básica (tablas/listas, sin gráficos).

---

### 3.4 Rol: SuperAdmin

#### 3.4.1 Gestión de Negocios

**Qué hace:** El SuperAdmin ve todos los negocios registrados, aprueba/rechaza nuevos negocios, y gestiona su estado general.

**Cómo funciona / Detalle técnico:** `SuperAdminGetBusinesses` query con auth `@check(expr: "this.exists(r, r == 'SUPER_ADMIN')")`. `SuperAdminUpdateBusinessStatus` cambia el status del negocio. El SuperAdmin tiene su propio login (`super_admin_login_page.dart`) con detección de email específico (`root@washgo.com`).

**Por qué se hizo así:** El SuperAdmin es el rol más privilegiado. Todos los accesos están protegidos con checks de rol explícitos. El login separado permite acceso administrativo sin interferir con el flujo normal.

**Estado real:** COMPLETO. CRUD de negocios, aprobación/rechazo, dashboard SuperAdmin.

#### 3.4.2 Revisión de Pagos (Transferencias)

**Qué hace:** El SuperAdmin revisa comprobantes de transferencia bancaria subidos por clientes, los aprueba o rechaza, y gestiona el ciclo de pago completo.

**Cómo funciona / Detalle técnico:** `GetPendingPaymentProofs` (NO_ACCESS, solo Cloud Functions). `admin_payment_review_page.dart` es la UI del SuperAdmin. `review-proof` (Cloud Function) procesa la revisión: actualiza `PaymentProof` status, y si es APPROVED, ejecuta `CompleteOrderWithTransferAndInvoice`. Si es REJECTED, envía notificación al cliente. El SuperAdmin puede ver estadísticas con `GetTransferPaymentStats`.

**Por qué se hizo así:** La revisión manual es necesaria por la naturaleza de las transferencias bancarias. La automatización requeriría integración con APIs bancarias que no están disponibles.

**Estado real:** COMPLETO. Revisión, aprobación/rechazo, generación de factura automática al aprobar.

#### 3.4.3 Aprobación de Precios de Servicios

**Qué hace:** El SuperAdmin revisa los precios sugeridos por los dueños y los aprueba para publicación.

**Cómo funciona / Detalle técnico:** `SuperAdminApproveServicePrice` copia `precioOwner*` → `precio*`, marca `precioPendiente: false` y `activo: true`. Esto publica el servicio con los precios aprobados.

**Por qué se hizo así:** Control de calidad de precios. El dueño sugiere, el SuperAdmin valida.

**Estado real:** COMPLETO.

#### 3.4.4 Gestión de Vehículos (Marcas y Modelos)

**Qué hace:** El SuperAdmin crea/actualiza marcas y modelos de vehículos con categorías.

**Cómo funciona / Detalle técnico:** `UpsertVehicleBrand` y `UpsertVehicleModel` son exclusivas de SuperAdmin. Las categorías determinan el tamaño (pequeño, mediano, grande, moto) para precios.

**Por qué se hizo así:** Catálogo centralizado de vehículos para consistencia entre negocios.

**Estado real:** COMPLETO.

#### 3.4.5 Calificaciones Globales de la App

**Qué hace:** El SuperAdmin ve estadísticas de calificaciones de la aplicación.

**Cómo funciona / Detalle técnico:** `GetGlobalAppRatings` es una query PUBLIC que retorna calificaciones agregadas. `super_admin_dashboard_page.dart` incluye un tab (`app_ratings_tab.dart`) para visualización.

**Por qué se hizo así:** Query pública permite mostrar calificaciones sin autenticación en landing pages o stores.

**Estado real:** COMPLETO. Visualización de calificaciones agregadas.

---

## 4. Roadmap vs Realidad

| Fase/Componente | Estado Planeado | Estado Real | Brecha |
|---|---|---|---|
| **Fase 1: Fundación** | Autenticación, CRUD negocios, servicios | COMPLETO | Sin brecha |
| **Fase 1: Órdenes básicas** | Flujo cliente → empleado | COMPLETO | Sin brecha |
| **Fase 2: Pagos electrónicos** | PayPal, PayPhone, Transferencia | COMPLETO | PayPal real requiere CI/CD credentials; PayPhone requiere registro de merchant activo |
| **Fase 2: Facturación PDF** | Generación de facturas | COMPLETO | Sin brecha |
| **Fase 3: Prepago** | Sistema de saldo prepago | COMPLETO | Sin brecha |
| **Fase 3: Walk-in** | Órdenes presenciales | COMPLETO | Sin brecha |
| **Notificaciones** | Push + in-app | PARCIAL | Solo notificaciones in-app (tabla DB). Sin Firebase Cloud Messaging implementado. |
| **Analítica/Gráficos** | Dashboard con gráficos | NO INICIADO | Dueño y SuperAdmin ven solo listas/tablas. Sin visualización analítica. |
| **Búsqueda de negocios** | Búsqueda por texto/filtros | NO INICIADO | Solo listado completo sin filtros. |
| **Pruebas automatizadas** | Cobertura >70% | 10 tests unitarios | Brecha crítica. Sin pruebas de integración, widgets, o Cloud Functions. |
| **Infraestructura CI/CD** | Pipeline automático | NO INICIADO | Sin GitHub Actions ni configuración de despliegue automatizado. |
| **Notificaciones push** | Alertas en tiempo real | NO INICIADO | Solo tabla de notificaciones in-app sin delivery externo. |
| **Términos y políticas** | Pantallas legales | COMPLETO | `policy_viewer_page.dart` implementada. |
| **Flujo sin login** | Guest booking | COMPLETO | BookingIntentManager operativo. |

---

## 5. Presupuesto vs Estado Actual

| Concepto | Costo Estimado Mensual | Estado de Implementación |
|---|---|---|
| **Google Play Console** | $25 (único pago anual) | Cuenta requerida, no solicitada aún |
| **Apple Developer Program** | $99 (único pago anual) | Cuenta requerida, no solicitada aún |
| **Firebase Pay-as-you-go (Blaze)** | ~$0 - $50/mes (estimado inicial) | Plan Blaze requerido para Cloud Functions. Firestore/Storage/Auth tienen cuota gratuita. Data Connect tiene costo asociado. |
| **Hostinger (Hosting Web + Callbacks)** | ~$3 - $5/mes | Hosting contratado ya que callbacks de PayPhone/PayPal redirigen a Hostinger. |
| **Infraestructura total estimada** | **$25 - $149/mes** (sin contar manos de obra) | — |
| **Costo total publicación inicial** | **$774 - $1,924** (incluye: consolas, configuración, pruebas, publicación) | Pendiente de ejecución presupuestaria. |

**Nota:** Firebase Data Connect no tiene un tier gratuito publicitado claramente. El costo depende del volumen de datos y queries. Se recomienda monitorear el primer mes en producción.

---

## 6. Plan de Publicación (Día por Día)

**Inicio:** 16 de julio de 2026  
**Deadline:** 31 de julio de 2026  
**Requisito crítico:** 14 días de Closed Testing en Google Play

| Fecha | Actividad | Responsable | Dependencia |
|---|---|---|---|
| **16-jul (jueves)** | Día 1: Subir APK a Google Play Internal Testing + solicitar Closed Testing | Ing. Despliegue | Cuenta Google Play activa |
| **16-jul (jueves)** | Solicitar cuenta Apple Developer (inicio proceso) | Administración | Pago $99 |
| **17-jul (viernes)** | Verificar Internal Testing + invitar testers para Closed Testing | QA/Tester | APK día 1 |
| **18-19 jul (sáb-dom)** | Sin actividad (testing transcurre) | — | — |
| **20-jul (lunes)** | Verificar progreso Closed Testing (día 4/14) | PM | — |
| **20-30 jul (lunes-miér.)** | Closed Testing continúa (14 días obligatorios) | — | No requiere acción manual si testers activos |
| **30-jul (miércoles)** | Día 14: Completar Closed Testing. Solicitar revisión producción. | Ing. Despliegue | Closed Testing aprobado |
| **30-jul (miércoles)** | Subir a App Store Connect + TestFlight | Ing. Despliegue | Cuenta Apple aprobada |
| **31-jul (viernes)** | Último día hábil: Publicar en producción (Google Play + App Store) | PM + Ing. Despliegue | Revisión de ambas stores |
| **31-jul (viernes)** | Activar Firebase Blaze plan + dominios producción | DevOps | — |

**Riesgo del plan:** Si la revisión de Google Play para la producción toma más de 24 horas (lo cual es común), el deadline del 31 de julio no se cumple. Se recomienda tener una ventana de contingencia de +3 días hábiles.

### Pre-requisitos del día 1 (16-jul)

1. [ ] Generar Keystore/Keystore para firma Android
2. [ ] Configurar Firebase Project en modo producción (Blaze plan)
3. [ ] Inyectar variables de entorno PayPal (`PAYPAL_CLIENT_ID`, `PAYPAL_CLIENT_SECRET`, `PAYPAL_IS_SANDBOX`, `PAYPAL_USE_REAL_API`)
4. [ ] Configurar App Check con reCAPTCHA o SafetyNet
5. [ ] Verificar deep links (`washgo://`) en AndroidManifest.xml y Info.plist
6. [ ] Configurar dominio personalizado en Firebase Hosting para callbacks
7. [ ] Generar APK firmado con `flutter build appbundle --dart-define=ENV=prod`

---

## 7. Costos Confirmados

| Item | Monto | Tipo | Frecuencia |
|---|---|---|---|
| Google Play Console | $25 USD | Único | Anual |
| Apple Developer Program | $99 USD | Único | Anual |
| Firebase Blaze (estimado inicial) | $0 - $50 USD | Variable | Mensual |
| Hostinger Hosting | ~$5 USD | Fijo | Mensual |
| Hosting público (Firebase) | $0 (cuota gratuita) | — | — |
| **Total costo fijo anual** | **$124 USD** | — | — |
| **Total operativo mensual** | **~$55 USD** | — | — |

**Mano de obra no incluida** (desarrollo interno):

| Recurso | Dedicación | Costo Aprox. |
|---|---|---|
| Desarrollador Flutter | Full-time (~6 meses) | Por definir según tarifa local |
| DevOps/Infraestructura | Parcial (~2 semanas) | Por definir |
| QA Testing | Parcial (~1 semana) | Por definir |
| Diseño UI/UX | Parcial (~3 meses) | Por definir |

---

## 8. Riesgos y Bloqueadores

### 8.1 Riesgos Críticos

| # | Riesgo | Impacto | Probabilidad | Mitigación |
|---|---|---|---|---|
| R1 | **Closed Testing 14 días no se completa a tiempo** | No publicación en Google Play | Media-Alta | Iniciar hoy mismo, usar Internal Testing mientras Closed Testing se procesa. Si el deadline es inamovible, considerar publicación en Firebase App Distribution + Web como plan B. |
| R2 | **Revisión de Apple App Store > 48 horas** | Deadline no se cumple | Alta | Solicitar expedited review. Publicar web como alternativa inmediata. |
| R3 | **Firebase Data Connect no escalable** | Costos inesperados o límites de conexión | Media | Monitorear primer mes. Tener plan de migración a NeonDB o Supabase. |
| R4 | **PayPhone merchant account no configurada para producción** | PayPhone no funcional en producción | Alta | Verificar merchant ID y API keys con PayPhone antes del día 1. |

### 8.2 Riesgos Técnicos

| # | Riesgo | Impacto | Estado |
|---|---|---|---|
| R5 | **Cobertura de pruebas insuficiente** | Bugs en producción | Solo 10 tests. Sin pruebas de Cloud Functions. Sin pruebas de widget/integración. |
| R6 | **PayPal CORS en web conocido** | Flujo PayPal no funciona en navegador | Detectado y documentado. Solución: redirigir a backend proxy en lugar de llamar directo desde web. |
| R7 | **Sin CI/CD pipeline** | Despliegue manual propenso a error | No implementado. Todo el despliegue es manual. |
| R8 | **Sin notificaciones push (FCM)** | Usuarios no reciben alertas de cambio de estado | Solo notificaciones in-app. Para producción mínima viable puede ser aceptable. |
| R9 | **Cleanup automático de 30 minutos para transferencias** | Cliente que tarda en subir comprobante pierde orden | Ajustar ventana a 60-120 minutos para producción real. |
| R10 | **Sin logs estructurados en backend** | Depuración difícil en producción | `console.log` disperso sin formato consistente. |

### 8.3 Bloqueadores

| # | Bloqueador | Acción Requerida | Dueño |
|---|---|---|---|
| B1 | **Cuenta Google Play no activada** | Crear cuenta Google Play Developer ($25) | Administración |
| B2 | **Cuenta Apple Developer no activada** | Crear cuenta Apple Developer ($99) | Administración |
| B3 | **PayPal Client ID/Secret no inyectados** | Generar credenciales PayPal REST API y pasarlas como `--dart-define` | DevOps |
| B4 | **PayPhone merchant credentials** | Obtener merchantCode, API key de PayPhone para producción | Administración |
| B5 | **Firebase Blaze plan no activado** | Actualizar plan de Spark a Blaze en Firebase Console | DevOps |
| B6 | **Deep links no registrados en stores** | Configurar `washgo://` en Google Play (App Links) y Apple (Universal Links) | Ing. Despliegue |

---

## 9. Inventario Completo del Código Fuente

### 9.1 Resumen de Archivos

| Categoría | Cantidad | Descripción |
|---|---|---|
| Dart (lib/) | ~180 archivos | UI, modelos, servicios, repositorios |
| GraphQL (dataconnect/) | 3 archivos | schema.gql, queries.gql, mutations.gql |
| Backend (functions/) | 3 archivos | index.js + CJS/ESM wrappers |
| HTML públicos | 5 archivos | Callbacks PayPal y PayPhone |
| Pruebas | 10 archivos | Unitarias y de widgets |
| Configuración | 10+ archivos | pubspec.yaml, firebase.json, etc. |

### 9.2 Pantallas por Rol

**Cliente (13 pantallas):** Inicio, reserva, historial, pago (PayPal éxito/cancelación, PayPhone éxito/cancelación), instrucciones transferencia, subida comprobante, estado comprobante, política de privacidad, términos, onboarding.

**Empleado (4 pantallas):** Dashboard, detalle factura servicio, historial, perfil.

**Dueño (10 pantallas):** Dashboard (6 tabs: inicio, facturación, servicios, reseñas, empleados, configuración), detalle factura, creación de lavandería, selector de mapa, consumo prepago.

**SuperAdmin (3 pantallas):** Dashboard, revisión pagos, calificaciones app.

**Compartidas/Auth (10 pantallas):** Login, registro, auth-gate, selección de rol, detalle de rol, onboarding (cliente/empleado), código empleado, selección activa de rol, login superadmin, viewer políticas.

### 9.3 Servicios Cloud Functions

| Endpoint | Método | Propósito | Auth |
|---|---|---|---|
| `/paypal/create-order` | POST | Crear orden PayPal (REST + simulador) | Firebase Token |
| `/paypal/complete-paypal-payment` | POST | Capturar + EN_COLA | Firebase Token |
| `/payphone/prepare` | POST | Preparar sesión PayPhone (IVA 15%) | Firebase Token |
| `/payphone/verify` | GET | Verificar estado transacción | No Auth (público) |
| `/payphone/store-transaction` | POST | Almacenar transactionId safety net | No Auth (público) |
| `/payphone/callback/success` | POST | Callback asíncrono PayPhone | PayPhone firma |
| `/payphone/complete-payphone-payment` | POST | Verificar + EN_COLA | Firebase Token |
| `/orders/upload-proof` | POST | Subir comprobante a Storage | Firebase Token |
| `/orders/proof-status` | GET | Estado del comprobante | No Auth (público) |
| `/orders/proof-image` | GET | URL firmada del comprobante | Firebase Token |
| `/orders/review-proof` | POST | Aprobar/rechazar comprobante | Firebase Token (SUPER_ADMIN) |
| `/invoices/proxy-pdf` | GET | Proxy PDF con URL firmada | Firebase Token |
| `/invoices/regenerate-pdf` | POST | Regenerar factura | Firebase Token |
| `/invoices/admin-proxy-pdf` | GET | Proxy admin PDF | Firebase Token (SUPER_ADMIN) |
| `/invoices/resolve-order-id` | GET | Resolver orderId por invoiceId | Firebase Token |
| Cron cleanup | — | Cada 15 min, cancela PENDIENTE_PAGO >30 min | Admin SDK |

---

## 10. Conclusión

WashGo es un producto funcionalmente completo en su mayoría (85-90%). El mayor riesgo actual no es técnico sino de proceso: el requisito de 14 días de Closed Testing en Google Play consume casi todo el plazo disponible desde hoy (16-jul) hasta el deadline (31-jul), dejando una ventana de publicación extremadamente ajustada. Se recomienda:

1. **Iniciar el proceso de Google Play HOY** — subir APK a Internal Testing y solicitar Closed Testing inmediatamente.
2. **Iniciar el proceso de Apple Developer HOY** — la creación y verificación de la cuenta puede tomar días.
3. **Configurar Firebase Blaze plan** — requerido para Cloud Functions en producción. Sin esto, los pagos no funcionan.
4. **Inyectar credenciales de producción** — PayPal y PayPhone necesitan credenciales reales configuradas como dart-define.
5. **Plan de contingencia para deadline** — preparar publicación web como alternativa si las stores no aprueban a tiempo.
6. **Tablero de seguimiento** — crear tracking diario de los 10 ítems del plan de publicación.
