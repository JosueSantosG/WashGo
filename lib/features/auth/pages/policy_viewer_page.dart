import 'package:flutter/material.dart';
import 'package:washgo/config/theme/app_colors.dart';

enum PolicyType { terms, privacy }

class PolicyViewerPage extends StatelessWidget {
  final PolicyType type;

  const PolicyViewerPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isTerms = type == PolicyType.terms;
    final title = isTerms ? 'Términos de Servicio' : 'Política de Privacidad';
    final subtitle = isTerms
        ? 'Condiciones generales de uso de la plataforma WashGo'
        : 'Cómo recopilamos, utilizamos y protegemos sus datos personales';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.08),
                        AppColors.primary.withValues(alpha: 0.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isTerms ? Icons.description_outlined : Icons.shield_outlined,
                        color: AppColors.primary,
                        size: 36,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Última actualización: 19 de Julio, 2026',
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.outline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Content
                if (isTerms)
                  ..._buildTermsSections(textTheme)
                else
                  ..._buildPrivacySections(textTheme),

                const SizedBox(height: 48),
                Center(
                  child: Text(
                    '© ${DateTime.now().year} WashGo. Todos los derechos reservados.',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.outline,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTermsSections(TextTheme textTheme) {
    return [
      _sectionHeader(textTheme, '1. Aceptación de los Términos'),
      _sectionBody(textTheme,
          'Al acceder, descargar o utilizar la aplicación móvil o sitio web de WashGo, usted acepta regirse por estos Términos de Servicio y por todas las leyes y regulaciones aplicables. Si no está de acuerdo con alguno de estos términos, tiene prohibido utilizar o acceder a esta plataforma.'),
      _sectionHeader(textTheme, '2. Descripción del Servicio'),
      _sectionBody(textTheme,
          'WashGo es una plataforma tecnológica que conecta a propietarios de vehículos (Clientes) con proveedores locales de servicios de lavado y mantenimiento automotriz (Negocios/Lavanderías). WashGo no proporciona servicios de lavado de manera directa; actúa únicamente como intermediario facilitador de reservas, pagos y gestión de flujos de trabajo.'),
      _sectionHeader(textTheme, '3. Cuentas de Usuario y Registro'),
      _sectionBody(textTheme,
          'Para acceder a ciertas funciones, debe registrarse y mantener una cuenta activa. Usted es responsable de mantener la confidencialidad de sus credenciales y de toda la actividad que ocurra bajo su cuenta. WashGo se reserva el derecho de rechazar el registro o cancelar cuentas que violen nuestras políticas.'),
      _sectionHeader(textTheme, '4. Tarifas, Pagos y Saldos Prepago'),
      _sectionBody(textTheme,
          'Los clientes pagan los servicios a través de los medios autorizados en la plataforma (Efectivo, PayPal, Transferencia Bancaria, etc.). Para los negocios asociados, WashGo opera bajo un modelo de saldo prepago prepagado. Los negocios deben mantener un saldo prepago positivo en su cuenta para recibir reservas de clientes. El saldo prepago se debitará automáticamente al procesar o confirmar cada pedido de acuerdo con las tarifas vigentes.'),
      _sectionHeader(textTheme, '5. Obligaciones y Conducta del Usuario'),
      _sectionBody(textTheme,
          'Tanto los clientes como los negocios y empleados se comprometen a interactuar de manera respetuosa y honesta. Queda estrictamente prohibido utilizar la plataforma para fines ilícitos, suplantación de identidad, proporcionar información falsa (incluyendo RUCs de negocios) o intentar vulnerar la seguridad del sistema.'),
      _sectionHeader(textTheme, '6. Limitación de Responsabilidad'),
      _sectionBody(textTheme,
          'WashGo no se hace responsable por daños directos, indirectos, incidentales o consecuentes derivados del uso del servicio, de la calidad del lavado realizado por los negocios asociados, o de altercados entre usuarios en los establecimientos.'),
      _sectionHeader(textTheme, '7. Modificaciones a los Términos'),
      _sectionBody(textTheme,
          'Nos reservamos el derecho de modificar estos términos en cualquier momento. La notificación de cambios se realizará publicando los nuevos términos en la aplicación. El uso continuado de la plataforma después de dichas modificaciones constituirá su consentimiento a los nuevos términos.'),
      _sectionHeader(textTheme, '8. Regulación para Empleados Multi-Sucursal'),
      _sectionBody(textTheme,
          'Los empleados pueden postularse y pertenecer de manera simultánea a múltiples locales o sucursales independientes en WashGo. El empleado es responsable de seleccionar la sucursal activa correcta en su aplicación antes de iniciar su jornada o registrar asistencia. Asimismo, los empleados conservan el derecho de desvincularse voluntariamente de cualquier local en cualquier momento a través de su perfil, regresando a un estado sin asignar si no les quedan sucursales activas.'),
      _sectionHeader(textTheme, '9. Consecuencias de la Eliminación de Cuenta para Propietarios'),
      _sectionBody(textTheme,
          'Si un propietario decide eliminar su cuenta, acepta que todos sus locales asociados serán desactivados definitiva e inmediatamente y sus empleados serán desvinculados de dichos locales. La eliminación no exime al propietario de obligaciones de pago pendientes con WashGo, empleados o procesadores de pago externos.'),
      _sectionHeader(textTheme, '10. Fallas en Procesamiento de Pagos y Mensajería de Errores'),
      _sectionBody(textTheme,
          'Ante fallas en la red o caídas del sistema de base de datos, la plataforma mostrará mensajes de error simplificados para no exponer datos técnicos o de seguridad sensibles. Si un pago es debitado de su cuenta de PayPhone o PayPal pero la aplicación muestra un error de base de datos, el cliente debe utilizar la opción "Ya pagué – Verificar" o contactar al soporte de WashGo presentando su comprobante de pago digital para la acreditación manual de la orden.'),
    ];
  }

  List<Widget> _buildPrivacySections(TextTheme textTheme) {
    return [
      _sectionHeader(textTheme, '1. Información que Recopilamos'),
      _sectionBody(textTheme,
          'Recopilamos información necesaria para proporcionar y mejorar nuestros servicios, incluyendo:\n'
          '• Datos de Registro: Nombre completo, dirección de correo electrónico y número de teléfono.\n'
          '• Información del Vehículo: Tipo de vehículo (o categoría), necesario para cotizar los servicios correctos.\n'
          '• Información del Negocio: Nombre comercial, dirección física, RUC (Registro Único de Contribuyentes) y datos de contacto.\n'
          '• Ubicación: Datos de geolocalización en tiempo real para sugerir lavanderías cercanas (solo con su consentimiento explícito).\n'
          '• Archivos y Acceso a Dispositivo: Acceso a la cámara y galería de imágenes para la captura y carga de comprobantes de transferencia bancaria.\n'
          '• Información de Uso y Pagos: Historial de pedidos, reservas, transacciones mediante pasarelas de pago externas (PayPal) y comprobantes de transferencias bancarias cargados por el usuario, así como valoraciones del servicio.'),
      _sectionHeader(textTheme, '2. Uso de la Información'),
      _sectionBody(textTheme,
          'Utilizamos la información recopilada para:\n'
          '• Facilitar la conexión entre clientes y negocios asociados.\n'
          '• Procesar, validar y registrar transacciones de pago, transferencias y deducción de saldos prepago.\n'
          '• Optimizar la experiencia del usuario y ofrecer soporte técnico.\n'
          '• Cumplir con requerimientos legales y fiscales aplicables en Ecuador.'),
      _sectionHeader(textTheme, '3. Compartición de Datos'),
      _sectionBody(textTheme,
          'No vendemos ni alquilamos su información personal a terceros. Sus datos se comparten únicamente entre las partes involucradas en una reserva (por ejemplo, proporcionar el nombre del cliente y tipo de vehículo al negocio de lavado), con los propietarios de locales asociados en el caso de los Empleados (quienes verán su nombre, teléfono y registros de actividad laboral en dicha sucursal), o con proveedores de infraestructura esenciales (como Firebase y pasarelas de pago autorizadas como PayPal o PayPhone) bajo estrictas medidas de confidencialidad.'),
      _sectionHeader(textTheme, '4. Seguridad de los Datos'),
      _sectionBody(textTheme,
          'Implementamos medidas de seguridad técnicas y organizativas para proteger su información contra accesos no autorizados, pérdida o alteración. Esto incluye encriptación SSL/TLS, políticas estrictas de autenticación mediante Firebase Auth y reglas robustas de base de datos a nivel de servidor.'),
      _sectionHeader(textTheme, '5. Derechos del Usuario (ARCO)'),
      _sectionBody(textTheme,
          'Usted tiene derecho a acceder, rectificar, cancelar u oponerse al tratamiento de sus datos personales. Puede actualizar su información de perfil directamente en la sección "Mi Perfil" dentro de la aplicación móvil.'),
      _sectionHeader(textTheme, '6. Eliminación de Cuenta y Anonimización'),
      _sectionBody(textTheme,
          'Si desea eliminar su cuenta de la plataforma WashGo, puede hacerlo de las siguientes maneras:\n'
          '• En la Aplicación: Diríjase a la sección de configuración de su perfil y seleccione la opción "Eliminar mi cuenta".\n'
          '• Por Correo Electrónico: Envíe una solicitud formal de eliminación de datos a soporte@washgo.app.\n\n'
          'Al procesarse la solicitud, eliminaremos permanentemente sus credenciales de inicio de sesión (Firebase Auth) y anonimizaremos sus datos de perfil (nombre, correo electrónico, teléfono y foto de perfil) en nuestra base de datos, reemplazándolos con registros genéricos ("Usuario Eliminado"). Para cumplir con regulaciones fiscales, contables y de auditoría de los locales y clientes, mantendremos de forma indefinida los históricos de transacciones, órdenes de servicio y facturas en formato estrictamente anonimizado, sin posibilidad de volver a vincularlos a su identidad.'),
    ];
  }

  Widget _sectionHeader(TextTheme textTheme, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.onSurface,
        ),
      ),
    );
  }

  Widget _sectionBody(TextTheme textTheme, String text) {
    return Text(
      text,
      style: textTheme.bodyMedium?.copyWith(
        color: AppColors.onSurfaceVariant,
        height: 1.5,
      ),
    );
  }
}
