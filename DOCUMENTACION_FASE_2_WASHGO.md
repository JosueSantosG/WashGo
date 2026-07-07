# WashGo - Documentación de Fase 2

## Estado
Fase 2 finalizada.

Esta documentación resume las funcionalidades que ya fueron implementadas, mejoradas o agregadas en el código actual de WashGo. El alcance real de esta fase se concentra en la experiencia comercial, la operación diaria y la monetización del producto.

## 1. Reserva y Agendamiento

La reserva dejó de ser un flujo simple y pasó a ser un proceso más completo y controlado:

- Selección de vehículo del usuario antes de confirmar la reserva.
- Carga dinámica del catálogo de servicios por negocio.
- Cálculo del precio del servicio según tipo de vehículo.
- Validación del horario real de atención del negocio.
- Diferenciación entre reserva inmediata y reserva programada.
- Selección de fecha y hora válida según la disponibilidad del local.
- Carga del tiempo estimado de espera del negocio.
- Manejo de reservas activas y seguimiento del estado del servicio.
- Asociación de metadatos de la reserva para completar el flujo operativo.

## 2. Flujo de Pago

Se integró una etapa de pago previa a la creación final de la orden:

- Pantalla de selección de pago antes de confirmar la reserva.
- Pago con cuenta PayPal.
- Pago con tarjeta de crédito o débito a través de PayPal.
- Opción de pago en sitio para servicios presenciales.
- Regla especial para servicios a domicilio: el pago adelantado es obligatorio.
- Integración con un servicio PayPal capaz de trabajar en modo sandbox o modo real según la configuración.

## 3. Facturación Automática

Se implementó un flujo de facturación más robusto y reutilizable:

- Generación automática de factura al completar una orden.
- Creación de número único de factura.
- Cálculo de subtotal, impuestos, descuento y total.
- Almacenamiento del PDF de la factura en Firebase Storage.
- Actualización del estado de la factura cuando el PDF se genera correctamente o falla.
- Asociación de la URL del PDF al pedido completado.
- Uso de observaciones finales, incluyendo notas del empleado cuando existen.
- Consumo automático del saldo prepago del pedido cuando aplica.

## 4. Historial y Gestión de Facturas

Se agregó una capa completa de consulta y reutilización de facturas para los distintos roles:

- Historial de facturas para clientes.
- Historial de facturas para empleados.
- Historial de facturas para negocios/dueños.
- Vista de detalle de factura por cliente o por dueño.
- Regeneración del PDF desde la interfaz.
- Opciones para ver, compartir o imprimir la factura.
- Exportación CSV en el panel de facturación del dueño.

## 5. Panel del Cliente

La experiencia del cliente también se reforzó en la fase 2:

- Vista de reservas activas y reservas completadas o canceladas.
- Línea de progreso del estado de la orden.
- Posición de cola cuando el negocio la expone.
- Acciones directas de contacto con el negocio.
- Cancelación y reprogramación de reservas.
- Acceso a opciones de factura desde cada reserva.
- Historial de facturas con filtros por fecha, método de pago y búsqueda por texto.

## 6. Panel del Empleado

El área operativa del empleado quedó más completa y productiva:

- Cola de pedidos pendientes.
- Órdenes activas asignadas al empleado.
- Historial paginado de servicios atendidos.
- Acceso a facturas generadas por los servicios completados.
- Formateo y lectura clara del método de pago.
- Acciones para contactar al cliente más rápido.
- Visualización del detalle del servicio con soporte para observaciones y notas de entrega.

## 7. Panel del Dueño / Administrador

El módulo comercial del negocio recibió mejoras importantes:

- Métricas de facturación y rendimiento del negocio.
- Cálculo de ingresos totales.
- Separación de ingresos por efectivo y PayPal.
- Conteo de facturas del día.
- Ticket promedio.
- Filtros avanzados por texto, fecha, empleado, método de pago y estado.
- Exportación de datos comerciales.
- Vista de detalle de facturas con regeneración de PDF.
- Centro de notificaciones internas dentro del dashboard.

## 8. SuperAdmin

La capa de administración global también quedó implementada:

- Listado de negocios pendientes, aprobados y rechazados.
- Aprobación o rechazo de locales.
- Aprobación de precios de servicios antes de activar un negocio.
- Envío de notificaciones internas al dueño cuando cambia el estado de su local.
- Panel global de calificaciones y feedback de la app.

## 9. Mejoras Técnicas y Operativas

Además de las pantallas visibles, la fase 2 incorporó lógica de soporte para operación real:

- Consumo de saldo prepago al completar órdenes.
- Reglas de acceso para pantallas de consumo prepago.
- Manejo de historial paginado para evitar cargas pesadas.
- Refuerzo del flujo de órdenes con estados operativos más claros.
- Uso de componentes visuales más consistentes y una interfaz más pulida en los paneles principales.

## 10. Alcance Real de la Fase 2

Con base en el código, la fase 2 ya cubre estos frentes:

- Reservas con disponibilidad real.
- Pagos con PayPal y efectivo.
- Facturación PDF y exportación.
- Paneles para cliente, empleado, dueño y superadmin.
- Control operativo y comercial del negocio.
- Notificaciones internas y métricas de negocio.

## 11. Elementos Que Siguen Siendo Roadmap

Para evitar confusiones con la documentación, estos puntos no deben describirse como finalizados en esta fase si no están en producción real:

- Notificaciones push nativas.
- Facturación fiscal externa completa.
- Integraciones multi-sucursal avanzadas.
- Automatización contable más profunda.

## 12. Referencias de Código

Los módulos que sostienen esta fase están distribuidos principalmente en:

- [lib/features/dashboard/client/pages/laundry_booking_page.dart](lib/features/dashboard/client/pages/laundry_booking_page.dart)
- [lib/features/dashboard/client/widgets/payment_selection_page.dart](lib/features/dashboard/client/widgets/payment_selection_page.dart)
- [lib/features/invoices/repositories/invoice_repository.dart](lib/features/invoices/repositories/invoice_repository.dart)
- [lib/features/invoices/pages/client_invoice_history_page.dart](lib/features/invoices/pages/client_invoice_history_page.dart)
- [lib/features/dashboard/client/widgets/tabs/bookings_tab.dart](lib/features/dashboard/client/widgets/tabs/bookings_tab.dart)
- [lib/features/dashboard/employee/employee_dashboard_page.dart](lib/features/dashboard/employee/employee_dashboard_page.dart)
- [lib/features/dashboard/owner/owner_dashboard_page.dart](lib/features/dashboard/owner/owner_dashboard_page.dart)
- [lib/features/dashboard/owner/widgets/owner_billing_tab.dart](lib/features/dashboard/owner/widgets/owner_billing_tab.dart)
- [lib/features/dashboard/admin/super_admin_dashboard_page.dart](lib/features/dashboard/admin/super_admin_dashboard_page.dart)
- [lib/features/dashboard/admin/widgets/app_ratings_tab.dart](lib/features/dashboard/admin/widgets/app_ratings_tab.dart)
