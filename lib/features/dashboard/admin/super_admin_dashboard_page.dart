import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:washgo/features/auth/models/super_admin_session.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/dashboard/admin/widgets/app_ratings_tab.dart';
import 'package:washgo/core/utils/type_utils.dart';

class SuperAdminDashboardPage extends StatefulWidget {
  const SuperAdminDashboardPage({super.key});

  @override
  State<SuperAdminDashboardPage> createState() =>
      _SuperAdminDashboardPageState();
}

class _SuperAdminDashboardPageState extends State<SuperAdminDashboardPage> {
  List<SuperAdminGetBusinessesBusinesses> _allBusinesses = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _activeFilter = 'PENDING'; // 'ALL', 'PENDING', 'APPROVED', 'REJECTED'
  final Map<String, bool> _updatingIds = {};
  // Store controllers for editing service prices
  final Map<String, TextEditingController> _priceControllers = {};
  int _selectedIndex = 0;
  final Map<String, bool> _expandedBusinessIds = {};
  final Map<String, bool> _expandedServiceIds = {};

  @override
  void dispose() {
    for (final controller in _priceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadBusinesses();
  }

  Future<void> _loadBusinesses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await ExampleConnector.instance
          .superAdminGetBusinesses()
          .execute();

      // Clear old controllers to avoid memory leaks and reload with fresh data
      for (final controller in _priceControllers.values) {
        controller.dispose();
      }
      _priceControllers.clear();

      setState(() {
        _allBusinesses = response.data.businesses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los locales: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateStatus(
    String businessId,
    BusinessStatus newStatus,
  ) async {
    setState(() {
      _updatingIds[businessId] = true;
    });

    try {
      // Find the business in local list to get owner id and name before updating
      final business = _allBusinesses.firstWhere((b) => b.id == businessId);
      final ownerId = business.owner.id;
      final businessName = business.nombre;

      if (newStatus == BusinessStatus.APPROVED) {
        // Approve service prices first
        for (final service in business.services_on_business) {
          final pKey = '${businessId}_${service.id}_pequeno';
          final mKey = '${businessId}_${service.id}_mediano';
          final gKey = '${businessId}_${service.id}_grande';
          final moKey = '${businessId}_${service.id}_moto';

          final pController = _priceControllers[pKey];
          final mController = _priceControllers[mKey];
          final gController = _priceControllers[gKey];
          final moController = _priceControllers[moKey];

          final defaultP = service.precioPendiente
              ? safeDouble(service.precioOwnerPequeno)
              : safeDouble(service.precioPequeno);
          final defaultM = service.precioPendiente
              ? safeDouble(service.precioOwnerMediano)
              : safeDouble(service.precioMediano);
          final defaultG = service.precioPendiente
              ? safeDouble(service.precioOwnerGrande)
              : safeDouble(service.precioGrande);
          final defaultMo = service.precioPendiente
              ? safeDouble(service.precioOwnerMoto)
              : safeDouble(service.precioMoto);

          var pPrice = pController != null
              ? (double.tryParse(pController.text.trim()) ?? defaultP)
              : defaultP;
          if (pPrice < 0) pPrice = defaultP;

          var mPrice = mController != null
              ? (double.tryParse(mController.text.trim()) ?? defaultM)
              : defaultM;
          if (mPrice < 0) mPrice = defaultM;

          var gPrice = gController != null
              ? (double.tryParse(gController.text.trim()) ?? defaultG)
              : defaultG;
          if (gPrice < 0) gPrice = defaultG;

          var moPrice = moController != null
              ? (double.tryParse(moController.text.trim()) ?? defaultMo)
              : defaultMo;
          if (moPrice < 0) moPrice = defaultMo;

          await ExampleConnector.instance
              .superAdminApproveServicePrice(
                id: service.id,
                precioAprobadoPequeno: pPrice,
                precioAprobadoMediano: mPrice,
                precioAprobadoGrande: gPrice,
                precioAprobadoMoto: moPrice,
              )
              .execute();
        }
      }

      await ExampleConnector.instance
          .superAdminUpdateBusinessStatus(id: businessId, status: newStatus)
          .execute();

      // Create notification
      try {
        String titulo;
        String mensaje;
        if (newStatus == BusinessStatus.APPROVED) {
          titulo = '¡Local Aprobado!';
          mensaje =
              '¡Tu local "$businessName" fue aprobado! Los precios de tus servicios están activos.';
        } else if (newStatus == BusinessStatus.REJECTED) {
          titulo = 'Local Rechazado';
          mensaje =
              'Tu local "$businessName" ha sido rechazado por el súper administrador.';
        } else {
          titulo = 'Local en Pendiente';
          mensaje =
              'El estado de tu local "$businessName" ha sido cambiado a pendiente de aprobación.';
        }

        await ExampleConnector.instance
            .createNotification(
              userId: ownerId,
              titulo: titulo,
              mensaje: mensaje,
            )
            .execute();
      } catch (e) {
        debugPrint('Error creating notification: $e');
      }

      if (!mounted) return;

      _showSnackBar(
        newStatus == BusinessStatus.APPROVED
            ? 'Local aprobado exitosamente'
            : newStatus == BusinessStatus.REJECTED
            ? 'Local rechazado exitosamente'
            : 'Local puesto en pendiente exitosamente',
        isError: false,
      );

      // Recargar datos
      await _loadBusinesses();
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error al actualizar el estado: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _updatingIds[businessId] = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: isError ? AppColors.error : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _handleLogout() async {
    SuperAdminSession.logout();
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
    if (!mounted) return;
    context.go(AppRoutes.login);
    _showSnackBar('Sesión cerrada correctamente', isError: false);
  }

  BusinessStatus? _getBusinessStatus(
    SuperAdminGetBusinessesBusinesses laundry,
  ) {
    final s = laundry.status;
    return s is Known<BusinessStatus> ? s.value : null;
  }

  List<SuperAdminGetBusinessesBusinesses> get _filteredBusinesses {
    if (_activeFilter == 'ALL') return _allBusinesses;
    if (_activeFilter == 'PENDING') {
      return _allBusinesses
          .where(
            (b) => _getBusinessStatus(b) == BusinessStatus.PENDING_APPROVAL,
          )
          .toList();
    }
    if (_activeFilter == 'APPROVED') {
      return _allBusinesses
          .where((b) => _getBusinessStatus(b) == BusinessStatus.APPROVED)
          .toList();
    }
    if (_activeFilter == 'REJECTED') {
      return _allBusinesses
          .where((b) => _getBusinessStatus(b) == BusinessStatus.REJECTED)
          .toList();
    }
    return _allBusinesses;
  }

  @override
  Widget build(BuildContext context) {
    // Stats counters
    final total = _allBusinesses.length;
    final pending = _allBusinesses
        .where((b) => _getBusinessStatus(b) == BusinessStatus.PENDING_APPROVAL)
        .length;
    final approved = _allBusinesses
        .where((b) => _getBusinessStatus(b) == BusinessStatus.APPROVED)
        .length;
    final rejected = _allBusinesses
        .where((b) => _getBusinessStatus(b) == BusinessStatus.REJECTED)
        .length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WashGo SuperAdmin',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.onBackground,
              ),
            ),
            Text(
              'Panel de Control Global',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.outline),
            ),
          ],
        ),
        backgroundColor: AppColors.surface,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              tooltip: 'Recargar locales',
              icon: const Icon(Icons.refresh, color: AppColors.primary),
              onPressed: _isLoading ? null : _loadBusinesses,
            ),
          const SizedBox(width: 8),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            icon: const Icon(Icons.logout, size: 18),
            label: Text(
              'Salir',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            onPressed: _handleLogout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _selectedIndex == 0
          ? (_isLoading && _allBusinesses.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadBusinesses,
                    child: CustomScrollView(
                      slivers: [
                        // Stats Section
                        SliverPadding(
                          padding: const EdgeInsets.all(20.0),
                          sliver: SliverToBoxAdapter(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final cardWidth =
                                    (constraints.maxWidth - 20) / 2;
                                return Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: [
                                    _buildStatCard(
                                      title: 'Total Locales',
                                      value: total.toString(),
                                      icon: Icons.store,
                                      color: AppColors.primary,
                                      width: cardWidth,
                                    ),
                                    _buildStatCard(
                                      title: 'Pendientes',
                                      value: pending.toString(),
                                      icon: Icons.pending_actions,
                                      color: AppColors.warning,
                                      width: cardWidth,
                                    ),
                                    _buildStatCard(
                                      title: 'Aprobados',
                                      value: approved.toString(),
                                      icon: Icons.check_circle_outline,
                                      color: Colors.green.shade600,
                                      width: cardWidth,
                                    ),
                                    _buildStatCard(
                                      title: 'Rechazados',
                                      value: rejected.toString(),
                                      icon: Icons.cancel_outlined,
                                      color: AppColors.error,
                                      width: cardWidth,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),

                        // Filter Tabs
                        SliverToBoxAdapter(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Row(
                              children: [
                                _buildFilterTab(
                                  label: 'Pendientes ($pending)',
                                  filterKey: 'PENDING',
                                ),
                                const SizedBox(width: 8),
                                _buildFilterTab(
                                  label: 'Aprobados ($approved)',
                                  filterKey: 'APPROVED',
                                ),
                                const SizedBox(width: 8),
                                _buildFilterTab(
                                  label: 'Rechazados ($rejected)',
                                  filterKey: 'REJECTED',
                                ),
                                const SizedBox(width: 8),
                                _buildFilterTab(
                                  label: 'Todos ($total)',
                                  filterKey: 'ALL',
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Business List
                        SliverPadding(
                          padding: const EdgeInsets.all(20.0),
                          sliver: _errorMessage.isNotEmpty
                              ? SliverToBoxAdapter(child: _buildErrorWidget())
                              : _filteredBusinesses.isEmpty
                              ? SliverToBoxAdapter(child: _buildEmptyWidget())
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate((
                                    context,
                                    index,
                                  ) {
                                    final laundry = _filteredBusinesses[index];
                                    return _buildLaundryCard(laundry);
                                  }, childCount: _filteredBusinesses.length),
                                ),
                        ),
                      ],
                    ),
                  ))
          : const AppRatingsTab(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.storefront_rounded),
                activeIcon: Icon(
                  Icons.storefront_rounded,
                  color: AppColors.primary,
                ),
                label: 'Locales',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics_outlined),
                activeIcon: Icon(
                  Icons.analytics_rounded,
                  color: AppColors.primary,
                ),
                label: 'Métricas de la App',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({required String label, required String filterKey}) {
    final isActive = _activeFilter == filterKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilter = filterKey;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.primary : AppColors.outline,
          ),
        ),
      ),
    );
  }

  Widget _buildLaundryCard(SuperAdminGetBusinessesBusinesses laundry) {
    final status = _getBusinessStatus(laundry);
    final isUpdating = _updatingIds[laundry.id] ?? false;

    Color badgeColor;
    String statusText;
    switch (status) {
      case BusinessStatus.APPROVED:
        badgeColor = Colors.green.shade600;
        statusText = 'APROBADO';
        break;
      case BusinessStatus.REJECTED:
        badgeColor = AppColors.error;
        statusText = 'RECHAZADO';
        break;
      case BusinessStatus.PENDING_APPROVAL:
      default:
        badgeColor = AppColors.warning;
        statusText = 'PENDIENTE';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey<String>('expansion_${laundry.id}'),
          initiallyExpanded: _expandedBusinessIds[laundry.id] ?? false,
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedBusinessIds[laundry.id] = expanded;
              if (!expanded) {
                // Liberar los controladores de precio al colapsar para evitar fugas de memoria
                for (final service in laundry.services_on_business) {
                  final pKey = '${laundry.id}_${service.id}_pequeno';
                  final mKey = '${laundry.id}_${service.id}_mediano';
                  final gKey = '${laundry.id}_${service.id}_grande';
                  final moKey = '${laundry.id}_${service.id}_moto';
                  _priceControllers.remove(pKey)?.dispose();
                  _priceControllers.remove(mKey)?.dispose();
                  _priceControllers.remove(gKey)?.dispose();
                  _priceControllers.remove(moKey)?.dispose();
                  _expandedServiceIds.remove('${laundry.id}_${service.id}');
                }
              }
            });
          },
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.outline,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              status == BusinessStatus.APPROVED
                  ? Icons.store
                  : status == BusinessStatus.REJECTED
                  ? Icons.store_mall_directory_outlined
                  : Icons.storefront,
              color: badgeColor,
            ),
          ),
          title: Text(
            laundry.nombre,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.onSurface,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusText,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
                Text(
                  'Código: ${laundry.businessCode}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.outline,
                  ),
                ),
                if (status == BusinessStatus.APPROVED &&
                    laundry.services_on_business.any((s) => s.precioPendiente))
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.notifications_active,
                          size: 10,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Cambio de precio pendiente (${laundry.services_on_business.where((s) => s.precioPendiente).length})',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          children: [
            if (_expandedBusinessIds[laundry.id] == true)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(color: AppColors.outlineVariant),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Propietario',
                      laundry.owner.nombreCompleto,
                    ),
                    _buildDetailRow('RUC', laundry.ruc),
                    _buildDetailRow(
                      'Descripción',
                      laundry.descripcion ?? 'Sin descripción proporcionada.',
                    ),
                    if (laundry.latitud != null &&
                        laundry.longitud != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ubicación: ',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final lat = laundry.latitud;
                                  final lng = laundry.longitud;
                                  final uri = Uri.parse(
                                    'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
                                  );
                                  try {
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(
                                        uri,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    } else {
                                      debugPrint('Could not launch $uri');
                                    }
                                  } catch (e) {
                                    debugPrint(
                                      'Error launching navigation URL: $e',
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.map_outlined,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        'Ver en Google Maps',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      _buildDetailRow('Ubicación', 'No especificada'),
                    ],
                    const SizedBox(height: 12),

                    // Tarjeta de Saldo Prepago
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Saldo Prepago del Local',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildPrepaidItem(
                                'Inicial',
                                '\$${laundry.saldoPrepagoInicial.toStringAsFixed(2)}',
                              ),
                              _buildPrepaidItem(
                                'Consumido',
                                '\$${laundry.saldoPrepagoConsumido.toStringAsFixed(2)}',
                              ),
                              _buildPrepaidItem(
                                'Disponible',
                                '\$${(laundry.saldoPrepagoInicial - laundry.saldoPrepagoConsumido).toStringAsFixed(2)}',
                                isHighlight: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(
                            height: 1,
                            color: AppColors.outlineVariant,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  context.push(
                                    AppRoutes.prepaidConsumption,
                                    extra: {
                                      'businessId': laundry.id,
                                      'businessName': laundry.nombre,
                                      'saldoInicial':
                                          laundry.saldoPrepagoInicial,
                                      'saldoConsumido':
                                          laundry.saldoPrepagoConsumido,
                                      'saldoDisponible':
                                          laundry.saldoPrepagoInicial -
                                          laundry.saldoPrepagoConsumido,
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.bar_chart_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                label: Text(
                                  'Ver Estadísticas',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildServicesSection(laundry),
                    const SizedBox(height: 20),

                    // Actions
                    if (isUpdating)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary.withValues(
                                alpha: 0.1,
                              ),
                              foregroundColor: AppColors.primary,
                              elevation: 0,
                              minimumSize: const Size(0, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(
                              Icons.account_balance_wallet,
                              size: 16,
                            ),
                            label: const Text('Gestionar Prepago'),
                            onPressed: () => _showManagePrepaidDialog(laundry),
                          ),
                          if (status != BusinessStatus.REJECTED)
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: const BorderSide(color: AppColors.error),
                                minimumSize: const Size(0, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.close, size: 16),
                              label: const Text('Rechazar'),
                              onPressed: () => _updateStatus(
                                laundry.id,
                                BusinessStatus.REJECTED,
                              ),
                            ),
                          if (status != BusinessStatus.APPROVED)
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                minimumSize: const Size(0, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.check, size: 16),
                              label: const Text('Aprobar'),
                              onPressed: () => _updateStatus(
                                laundry.id,
                                BusinessStatus.APPROVED,
                              ),
                            )
                          else
                            // Si ya está aprobado, permitimos pasarlo a pendiente
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.warning,
                                side: const BorderSide(
                                  color: AppColors.warning,
                                ),
                                minimumSize: const Size(0, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.history, size: 16),
                              label: const Text('Desactivar (Pendiente)'),
                              onPressed: () => _updateStatus(
                                laundry.id,
                                BusinessStatus.PENDING_APPROVAL,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrepaidItem(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: AppColors.outline),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isHighlight ? AppColors.primary : AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  void _showManagePrepaidDialog(SuperAdminGetBusinessesBusinesses laundry) {
    final formKey = GlobalKey<FormState>();
    final inicialController = TextEditingController(
      text: laundry.saldoPrepagoInicial.toString(),
    );
    final consumidoController = TextEditingController(
      text: laundry.saldoPrepagoConsumido.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Gestionar Prepago',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Local: ${laundry.nombre}',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: inicialController,
                    decoration: InputDecoration(
                      labelText: 'Saldo Prepago Inicial (\$)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.add_circle_outline),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor ingresa un valor';
                      }
                      final doubleValue = double.tryParse(value);
                      if (doubleValue == null) {
                        return 'Ingresa un número válido';
                      }
                      if (doubleValue < 0) {
                        return 'El saldo no puede ser negativo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: consumidoController,
                    decoration: InputDecoration(
                      labelText: 'Saldo Prepago Consumido (\$)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.remove_circle_outline),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor ingresa un valor';
                      }
                      final doubleValue = double.tryParse(value);
                      if (doubleValue == null) {
                        return 'Ingresa un número válido';
                      }
                      if (doubleValue < 0) {
                        return 'El saldo consumido no puede ser negativo';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(color: AppColors.outline),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final inicial = double.parse(inicialController.text);
                  final consumido = double.parse(consumidoController.text);
                  Navigator.of(context).pop();
                  _updatePrepaidBalance(
                    laundry.id,
                    laundry.owner.id,
                    laundry.nombre,
                    inicial,
                    consumido,
                  );
                }
              },
              child: Text(
                'Guardar',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatePrepaidBalance(
    String businessId,
    String ownerId,
    String businessName,
    double inicial,
    double consumido,
  ) async {
    setState(() {
      _updatingIds[businessId] = true;
    });

    try {
      await ExampleConnector.instance
          .superAdminUpdateBusinessPrepaid(
            id: businessId,
            saldoPrepagoInicial: inicial,
            saldoPrepagoConsumido: consumido,
          )
          .execute();

      // Create notification
      try {
        final disponible = inicial - consumido;
        await ExampleConnector.instance
            .createNotification(
              userId: ownerId,
              titulo: 'Saldo Prepago Actualizado',
              mensaje:
                  'El súper administrador ha actualizado el saldo de "$businessName". Nuevo saldo disponible: \$${disponible.toStringAsFixed(2)}',
            )
            .execute();
      } catch (e) {
        debugPrint('Error al crear notificación de prepago: $e');
      }

      if (!mounted) return;

      _showSnackBar('Saldo prepago actualizado exitosamente', isError: false);

      // Recargar datos
      await _loadBusinesses();
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error al actualizar el saldo prepago: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _updatingIds[businessId] = false;
        });
      }
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurface),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    IconData icon;
    String message;
    switch (_activeFilter) {
      case 'PENDING':
        icon = Icons.done_all;
        message = '¡No hay locales pendientes de aprobación!';
        break;
      case 'APPROVED':
        icon = Icons.store_outlined;
        message = 'No hay locales aprobados.';
        break;
      case 'REJECTED':
        icon = Icons.delete_outline;
        message = 'No hay locales rechazados.';
        break;
      default:
        icon = Icons.storefront;
        message = 'Aún no se han registrado locales.';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(icon, size: 64, color: AppColors.outline.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.outline,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 40),
          const SizedBox(height: 12),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: AppColors.error, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadBusinesses,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPriceInput({
    required String label,
    required double currentPrice,
    required double proposedPrice,
    required TextEditingController controller,
    required bool isPendingApproval,
    required bool hasPendingPrice,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isPendingApproval
                  ? 'Dueño: \$${proposedPrice.toStringAsFixed(2)}'
                  : 'Dueño: \$${proposedPrice.toStringAsFixed(2)} • Activo: \$${currentPrice.toStringAsFixed(2)}',
              style: GoogleFonts.inter(fontSize: 10, color: AppColors.outline),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 38,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              prefixIcon: const Icon(Icons.attach_money, size: 14),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: GoogleFonts.inter(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection(SuperAdminGetBusinessesBusinesses laundry) {
    final status = _getBusinessStatus(laundry);
    final isPendingApproval = status == BusinessStatus.PENDING_APPROVAL;

    // We show all services so that the super admin can edit/update prices at any time
    final servicesToShow = laundry.services_on_business;

    if (servicesToShow.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.outlineVariant.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.outline,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Este local aún no tiene servicios registrados.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.outline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final hasPendingChanges = servicesToShow.any((s) => s.precioPendiente);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isPendingApproval
                  ? 'Servicios a Aprobar'
                  : hasPendingChanges
                  ? 'Servicios con Cambios Pendientes'
                  : 'Servicios y Precios Activos',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: hasPendingChanges
                    ? AppColors.warning
                    : AppColors.onSurface,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color:
                    (hasPendingChanges ? AppColors.warning : AppColors.primary)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${servicesToShow.length} ${servicesToShow.length == 1 ? 'servicio' : 'servicios'}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: hasPendingChanges
                      ? AppColors.warning
                      : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: servicesToShow.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final service = servicesToShow[index];
            final pKey = '${laundry.id}_${service.id}_pequeno';
            final mKey = '${laundry.id}_${service.id}_mediano';
            final gKey = '${laundry.id}_${service.id}_grande';
            final moKey = '${laundry.id}_${service.id}_moto';

            final initialP = service.precioPendiente
                ? safeDouble(service.precioOwnerPequeno)
                : safeDouble(service.precioPequeno);
            final initialM = service.precioPendiente
                ? safeDouble(service.precioOwnerMediano)
                : safeDouble(service.precioMediano);
            final initialG = service.precioPendiente
                ? safeDouble(service.precioOwnerGrande)
                : safeDouble(service.precioGrande);
            final initialMo = service.precioPendiente
                ? safeDouble(service.precioOwnerMoto)
                : safeDouble(service.precioMoto);

            if (!_priceControllers.containsKey(pKey)) {
              _priceControllers[pKey] = TextEditingController(
                text: initialP.toStringAsFixed(2),
              );
            }
            if (!_priceControllers.containsKey(mKey)) {
              _priceControllers[mKey] = TextEditingController(
                text: initialM.toStringAsFixed(2),
              );
            }
            if (!_priceControllers.containsKey(gKey)) {
              _priceControllers[gKey] = TextEditingController(
                text: initialG.toStringAsFixed(2),
              );
            }
            if (!_priceControllers.containsKey(moKey)) {
              _priceControllers[moKey] = TextEditingController(
                text: initialMo.toStringAsFixed(2),
              );
            }

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: service.precioPendiente
                    ? AppColors.warning.withValues(alpha: 0.03)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: service.precioPendiente
                      ? AppColors.warning.withValues(alpha: 0.3)
                      : AppColors.outlineVariant,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (service.precioPendiente)
                        const Padding(
                          padding: EdgeInsets.only(right: 6.0),
                          child: Icon(
                            Icons.notification_important_outlined,
                            size: 16,
                            color: AppColors.warning,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          service.nombre,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${service.duracionMinutos} min • ${service.tipo.stringValue == 'LOCAL' ? 'En Local' : 'A Domicilio'}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.outline,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.outlineVariant),
                  const SizedBox(height: 12),
                  // Price Input Grid (2 columns, 2 rows)
                  Row(
                    children: [
                      Expanded(
                        child: _buildCategoryPriceInput(
                          label: 'Pequeño',
                          currentPrice: safeDouble(service.precioPequeno),
                          proposedPrice: safeDouble(
                            service.precioOwnerPequeno,
                          ),
                          controller: _priceControllers[pKey]!,
                          isPendingApproval: isPendingApproval,
                          hasPendingPrice: service.precioPendiente,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCategoryPriceInput(
                          label: 'Mediano',
                          currentPrice: safeDouble(service.precioMediano),
                          proposedPrice: safeDouble(
                            service.precioOwnerMediano,
                          ),
                          controller: _priceControllers[mKey]!,
                          isPendingApproval: isPendingApproval,
                          hasPendingPrice: service.precioPendiente,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCategoryPriceInput(
                          label: 'Grande',
                          currentPrice: safeDouble(service.precioGrande),
                          proposedPrice: safeDouble(service.precioOwnerGrande),
                          controller: _priceControllers[gKey]!,
                          isPendingApproval: isPendingApproval,
                          hasPendingPrice: service.precioPendiente,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCategoryPriceInput(
                          label: 'Moto',
                          currentPrice: safeDouble(service.precioMoto),
                          proposedPrice: safeDouble(service.precioOwnerMoto),
                          controller: _priceControllers[moKey]!,
                          isPendingApproval: isPendingApproval,
                          hasPendingPrice: service.precioPendiente,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        if (!isPendingApproval) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: hasPendingChanges
                    ? AppColors.warning
                    : AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                minimumSize: const Size(0, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(
                hasPendingChanges
                    ? Icons.check_circle_outline
                    : Icons.save_outlined,
                size: 16,
              ),
              label: Text(
                hasPendingChanges
                    ? 'Aprobar y Guardar Precios'
                    : 'Guardar Cambios de Precios',
              ),
              onPressed: () => _approvePendingPrices(laundry, servicesToShow),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _approvePendingPrices(
    SuperAdminGetBusinessesBusinesses laundry,
    List<SuperAdminGetBusinessesBusinessesServicesOnBusiness> services,
  ) async {
    setState(() {
      _updatingIds[laundry.id] = true;
    });

    try {
      final List<String> approvedDetails = [];
      for (final service in services) {
        final pKey = '${laundry.id}_${service.id}_pequeno';
        final mKey = '${laundry.id}_${service.id}_mediano';
        final gKey = '${laundry.id}_${service.id}_grande';
        final moKey = '${laundry.id}_${service.id}_moto';

        final pController = _priceControllers[pKey];
        final mController = _priceControllers[mKey];
        final gController = _priceControllers[gKey];
        final moController = _priceControllers[moKey];

        final defaultP = service.precioPendiente
            ? safeDouble(service.precioOwnerPequeno)
            : safeDouble(service.precioPequeno);
        final defaultM = service.precioPendiente
            ? safeDouble(service.precioOwnerMediano)
            : safeDouble(service.precioMediano);
        final defaultG = service.precioPendiente
            ? safeDouble(service.precioOwnerGrande)
            : safeDouble(service.precioGrande);
        final defaultMo = service.precioPendiente
            ? safeDouble(service.precioOwnerMoto)
            : safeDouble(service.precioMoto);

        var pPrice = pController != null
            ? (double.tryParse(pController.text.trim()) ?? defaultP)
            : defaultP;
        if (pPrice < 0) pPrice = defaultP;

        var mPrice = mController != null
            ? (double.tryParse(mController.text.trim()) ?? defaultM)
            : defaultM;
        if (mPrice < 0) mPrice = defaultM;

        var gPrice = gController != null
            ? (double.tryParse(gController.text.trim()) ?? defaultG)
            : defaultG;
        if (gPrice < 0) gPrice = defaultG;

        var moPrice = moController != null
            ? (double.tryParse(moController.text.trim()) ?? defaultMo)
            : defaultMo;
        if (moPrice < 0) moPrice = defaultMo;

        // Call the mutation
        await ExampleConnector.instance
            .superAdminApproveServicePrice(
              id: service.id,
              precioAprobadoPequeno: pPrice,
              precioAprobadoMediano: mPrice,
              precioAprobadoGrande: gPrice,
              precioAprobadoMoto: moPrice,
            )
            .execute();

        approvedDetails.add(
          '${service.nombre}: Peq: \$${pPrice.toStringAsFixed(2)}, Med: \$${mPrice.toStringAsFixed(2)}, Gra: \$${gPrice.toStringAsFixed(2)}, Moto: \$${moPrice.toStringAsFixed(2)}',
        );
      }

      // Send notification to the owner about the approved service prices
      try {
        final ownerId = laundry.owner.id;
        final hasPending = laundry.services_on_business.any(
          (s) => s.precioPendiente,
        );
        final titulo = hasPending
            ? 'Cambios de Precio Aprobados'
            : 'Precios de Servicios Actualizados';
        final messageText = hasPending
            ? 'Los precios de los siguientes servicios han sido aprobados y ya están activos:\n${approvedDetails.join('\n')}'
            : 'El súper administrador ha actualizado los precios de tus servicios:\n${approvedDetails.join('\n')}';

        await ExampleConnector.instance
            .createNotification(
              userId: ownerId,
              titulo: titulo,
              mensaje: messageText,
            )
            .execute();
      } catch (e) {
        debugPrint('Error al crear notificación de aprobación de precios: $e');
      }

      if (!mounted) return;

      _showSnackBar('Precios actualizados exitosamente', isError: false);

      // Reload businesses
      await _loadBusinesses();
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error al aprobar/actualizar precios: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _updatingIds[laundry.id] = false;
        });
      }
    }
  }
}
