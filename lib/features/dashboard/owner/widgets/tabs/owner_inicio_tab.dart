import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/orders/models/washgo_order.dart';
import 'package:washgo/features/laundries/models/washgo_business.dart';
import 'package:washgo/features/laundries/models/employee_request.dart';
import 'package:washgo/core/utils/observations_parser.dart';
import 'package:washgo/dataconnect-generated/example.dart';

class ServiceStatData {
  final String name;
  final int quantity;
  final double earnings;

  ServiceStatData({
    required this.name,
    required this.quantity,
    required this.earnings,
  });
}

class OwnerDashboardStats {
  final int statusPendientes;
  final int statusEnProgreso;
  final int statusCompletados;
  final int statusCancelados;
  final List<ServiceStatData> topServices;
  final int totalClients;
  final int recurrentClients;
  final int newClientsMonth;

  OwnerDashboardStats({
    required this.statusPendientes,
    required this.statusEnProgreso,
    required this.statusCompletados,
    required this.statusCancelados,
    required this.topServices,
    required this.totalClients,
    required this.recurrentClients,
    required this.newClientsMonth,
  });

  factory OwnerDashboardStats.calculate(List<WashGoOrder> allOrders) {
    int pendientes = 0;
    int enProgreso = 0;
    int completados = 0;
    int cancelados = 0;

    for (final order in allOrders) {
      switch (order.status) {
        case OrderStatus.PENDIENTE_PAGO:
        case OrderStatus.EN_COLA:
        case OrderStatus.ACEPTADO:
          pendientes++;
          break;
        case OrderStatus.EN_CAMINO:
        case OrderStatus.EN_SERVICIO:
          enProgreso++;
          break;
        case OrderStatus.COMPLETADO:
          completados++;
          break;
        case OrderStatus.CANCELADO:
          cancelados++;
          break;
      }
    }

    final Map<String, _ServiceStatBuilder> serviceMap = {};
    for (final order in allOrders) {
      if (order.status == OrderStatus.COMPLETADO) {
        final name = order.serviceName ?? 'General';
        if (!serviceMap.containsKey(name)) {
          serviceMap[name] = _ServiceStatBuilder(name: name);
        }
        serviceMap[name]!.quantity++;
        serviceMap[name]!.earnings += order.price;
      }
    }
    final topServices = serviceMap.values
        .map((s) => ServiceStatData(name: s.name, quantity: s.quantity, earnings: s.earnings))
        .toList()
      ..sort((a, b) => b.quantity.compareTo(a.quantity));

    final Map<String, List<WashGoOrder>> clientOrders = {};
    for (final order in allOrders) {
      final clientId = order.client.id;
      if (!clientOrders.containsKey(clientId)) {
        clientOrders[clientId] = [];
      }
      clientOrders[clientId]!.add(order);
    }

    final totalClients = clientOrders.keys.length;
    int recurrentClients = 0;
    int newClientsMonth = 0;
    final now = DateTime.now();

    for (final entry in clientOrders.entries) {
      final orders = entry.value;
      if (orders.length > 1) {
        recurrentClients++;
      } else if (orders.length == 1) {
        final orderTime = _parseOrderDateTimeStatic(orders.first);
        if (orderTime != null) {
          if (orderTime.year == now.year && orderTime.month == now.month) {
            newClientsMonth++;
          }
        } else {
          newClientsMonth++;
        }
      }
    }

    return OwnerDashboardStats(
      statusPendientes: pendientes,
      statusEnProgreso: enProgreso,
      statusCompletados: completados,
      statusCancelados: cancelados,
      topServices: topServices,
      totalClients: totalClients,
      recurrentClients: recurrentClients,
      newClientsMonth: newClientsMonth,
    );
  }

  static DateTime? _parseOrderDateTimeStatic(WashGoOrder order) {
    try {
      final parsed = ParsedObservations.parse(order.observations);
      final dateTimeStr = parsed.dateTime.trim();
      final parts = dateTimeStr.split(' ');
      if (parts.length == 2) {
        final dateParts = parts[0].split('/');
        final timeParts = parts[1].split(':');
        if (dateParts.length == 3 && timeParts.length == 2) {
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          return DateTime(year, month, day, hour, minute);
        }
      }
    } catch (_) {}
    return null;
  }
}

class _ServiceStatBuilder {
  final String name;
  int quantity = 0;
  double earnings = 0.0;
  _ServiceStatBuilder({required this.name});
}

class OwnerInicioTab extends StatelessWidget {
  final bool isReservationConfigured;
  final List<WashGoOrder> allOrders;
  final WashGoBusiness? business;
  final List<EmployeeRequest> requests;
  final int todayOrdersCount;
  final double weeklyEarnings;
  final int completedServicesCount;
  final double cashEarnings;
  final double electronicEarnings;
  final OwnerDashboardStats dashboardStats;
  final List<WashGoBusiness> myBusinesses;
  final Map<String, double> monthlyRevenueByBranch;
  final void Function(String)? onSwitchBusiness;

  const OwnerInicioTab({
    super.key,
    required this.isReservationConfigured,
    required this.allOrders,
    required this.business,
    required this.requests,
    required this.todayOrdersCount,
    required this.weeklyEarnings,
    required this.completedServicesCount,
    required this.cashEarnings,
    required this.electronicEarnings,
    required this.dashboardStats,
    this.myBusinesses = const [],
    this.monthlyRevenueByBranch = const {},
    this.onSwitchBusiness,
  });


  Widget _buildWarningReservationConfig(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        border: Border.all(color: Colors.amber.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configuración de reservas pendiente',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.amber.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Debes configurar la capacidad simultánea y tiempo de anticipación antes de recibir reservas programadas. De lo contrario, solo podrás recibir lavados inmediatos ("Ahora").',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.amber.shade800,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    context.go('/owner-dashboard/config');
                  },
                  icon: const Icon(Icons.settings_rounded, size: 16),
                  label: const Text('Configurar Ahora'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade800,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard(
            title: 'Solicitudes',
            value: requests.length.toString(),
            icon: Icons.person_add_alt_1_rounded,
            color: Colors.orange.shade500,
            bgColor: Colors.orange.shade50,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            title: 'Pedidos Hoy',
            value: todayOrdersCount.toString(),
            icon: Icons.receipt_long_rounded,
            color: AppColors.primary,
            bgColor: AppColors.primary.withValues(alpha: 0.1),
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            title: 'Ingresos Semanales',
            value: '\$${weeklyEarnings.toStringAsFixed(0)}',
            icon: Icons.monetization_on_rounded,
            color: Colors.green.shade600,
            bgColor: Colors.green.shade50,
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialOverview() {
    if (business == null) {
      return const SizedBox.shrink();
    }

    final double saldoInicial = business!.saldoPrepagoInicial;
    final double saldoConsumido = business!.saldoPrepagoConsumido;
    final double saldoDisponible = business!.saldoPrepagoDisponible;
    final int serviciosRealizados = completedServicesCount;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 700;
        final List<Widget> cards = [
          _buildPrepaidBalanceCard(
            inicial: saldoInicial,
            consumido: saldoConsumido,
            disponible: saldoDisponible,
            width: isWide ? (constraints.maxWidth - 16) / 2 : double.infinity,
          ),
          _buildIncomeBreakdownCard(
            context: context,
            cashIncome: cashEarnings,
            electronicIncome: electronicEarnings,
            serviciosRealizados: serviciosRealizados,
            width: isWide ? (constraints.maxWidth - 16) / 2 : double.infinity,
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.analytics_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Resumen Financiero',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 16),
                  Expanded(child: cards[1]),
                ],
              )
            else
              Column(
                children: [
                  cards[0],
                  const SizedBox(height: 16),
                  cards[1],
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildPrepaidBalanceCard({
    required double inicial,
    required double consumido,
    required double disponible,
    required double width,
  }) {
    final double progress = inicial > 0 ? (consumido / inicial).clamp(0.0, 1.0) : 0.0;
    final double percentage = progress * 100;

    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0), // Very light amber
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Color(0xFFF57C00), // Amber
                  size: 24,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Saldo Prepago',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE65100),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '\$${disponible.toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Disponible de \$${inicial.toStringAsFixed(2)} inicial',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade100,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF57C00)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Consumido: $percentage% (Unidad)',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '\$${consumido.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE65100),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeBreakdownCard({
    required BuildContext context,
    required double cashIncome,
    required double electronicIncome,
    required int serviciosRealizados,
    required double width,
  }) {
    final double totalIncome = cashIncome + electronicIncome;

    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  color: Colors.green.shade600,
                  size: 24,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Ingresos Totales',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '\$${totalIncome.toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Generado en $serviciosRealizados servicios completados',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.money_rounded, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          'Efectivo',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${cashIncome.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 35, color: Colors.grey.shade200),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.payment_rounded, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          'Pago Electrónico',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${electronicIncome.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _showBranchRevenueModal(context),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.storefront_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Ver ingresos por local',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBranchRevenueModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.analytics_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Ingresos por Local',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Total recaudado acumulado en el mes actual.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              if (myBusinesses.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('No tienes locales registrados.'),
                )
              else
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(ctx).size.height * 0.45,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: myBusinesses.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final b = myBusinesses[index];
                      final revenue = monthlyRevenueByBranch[b.id] ?? 0.0;
                      final isSelected = business?.id == b.id;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        onTap: () {
                          Navigator.pop(ctx);
                          if (!isSelected && onSwitchBusiness != null) {
                            onSwitchBusiness!(b.id);
                          }
                        },
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isSelected
                                ? Icons.storefront_rounded
                                : Icons.store_outlined,
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey.shade600,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          b.nombre,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          b.businessCode.isNotEmpty
                              ? 'Código: ${b.businessCode}'
                              : 'RUC: ${b.ruc}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${revenue.toStringAsFixed(2)}',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                            if (isSelected)
                              Text(
                                'Seleccionado',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceStatusStats() {
    final pendientes = dashboardStats.statusPendientes;
    final enProgreso = dashboardStats.statusEnProgreso;
    final completados = dashboardStats.statusCompletados;
    final cancelados = dashboardStats.statusCancelados;

    Widget buildRow({
      required String label,
      required int count,
      required Color color,
    }) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Text(
              count.toString(),
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estado de Servicios',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Icon(Icons.bar_chart_rounded, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              buildRow(label: 'Pendiente', count: pendientes, color: AppColors.error),
              const SizedBox(height: 8),
              buildRow(label: 'En Progreso', count: enProgreso, color: AppColors.primary),
              const SizedBox(height: 8),
              buildRow(label: 'Completado', count: completados, color: AppColors.success),
              const SizedBox(height: 8),
              buildRow(label: 'Cancelado', count: cancelados, color: AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopServicesTable(BuildContext context) {
    final sortedStats = dashboardStats.topServices;
    final displayStats = sortedStats.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Servicios Más Solicitados',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (sortedStats.length > 3)
                TextButton(
                  onPressed: () {
                    _showAllTopServicesDialog(context, sortedStats);
                  },
                  child: Text(
                    'Ver Todos',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  'Servicio',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Cantidad',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Ingreso',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          if (displayStats.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No hay datos de servicios completados.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            ...displayStats.map((stat) {
              IconData icon = Icons.directions_car_rounded;
              if (stat.name.toLowerCase().contains('moto')) {
                icon = Icons.two_wheeler_rounded;
              } else if (stat.name.toLowerCase().contains('motor')) {
                icon = Icons.build_rounded;
              } else if (stat.name.toLowerCase().contains('interior') || stat.name.toLowerCase().contains('tapiz')) {
                icon = Icons.layers_rounded;
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  icon,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  stat.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            stat.quantity.toString(),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '\$${stat.earnings.toStringAsFixed(0)}',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],
              );
            }),
        ],
      ),
    );
  }

  void _showAllTopServicesDialog(BuildContext context, List<ServiceStatData> stats) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Todos los Servicios',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade50,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(
                          'Servicio',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Cantidad',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Ingresos',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: stats.length,
                      itemBuilder: (context, index) {
                        final stat = stats[index];
                        IconData icon = Icons.directions_car_rounded;
                        if (stat.name.toLowerCase().contains('moto')) {
                          icon = Icons.two_wheeler_rounded;
                        } else if (stat.name.toLowerCase().contains('motor')) {
                          icon = Icons.build_rounded;
                        } else if (stat.name.toLowerCase().contains('interior') || stat.name.toLowerCase().contains('tapiz')) {
                          icon = Icons.layers_rounded;
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            icon,
                                            color: AppColors.primary,
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            stat.name,
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      stat.quantity.toString(),
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      '\$${stat.earnings.toStringAsFixed(2)}',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildClientStats() {
    final totalRegistrados = dashboardStats.totalClients;
    final recurrentes = dashboardStats.recurrentClients;
    final nuevosMes = dashboardStats.newClientsMonth;

    Widget buildMetricCard({
      required String label,
      required String value,
      required IconData icon,
      required Color color,
    }) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            Icon(
              icon,
              color: color.withValues(alpha: 0.3),
              size: 36,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people_alt_rounded, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Clientes',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  children: [
                    Expanded(
                      child: buildMetricCard(
                        label: 'Total Registrados',
                        value: totalRegistrados.toString(),
                        icon: Icons.account_circle_rounded,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: buildMetricCard(
                        label: 'Nuevos (Mes)',
                        value: nuevosMes.toString(),
                        icon: Icons.person_add_rounded,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: buildMetricCard(
                        label: 'Recurrentes',
                        value: recurrentes.toString(),
                        icon: Icons.loop_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    buildMetricCard(
                      label: 'Total Registrados',
                      value: totalRegistrados.toString(),
                      icon: Icons.account_circle_rounded,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: 8),
                    buildMetricCard(
                      label: 'Nuevos (Mes)',
                      value: nuevosMes.toString(),
                      icon: Icons.person_add_rounded,
                      color: AppColors.success,
                    ),
                    const SizedBox(height: 8),
                    buildMetricCard(
                      label: 'Recurrentes',
                      value: recurrentes.toString(),
                      icon: Icons.loop_rounded,
                      color: AppColors.primary,
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.outline,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isReservationConfigured) ...[
            _buildWarningReservationConfig(context),
            const SizedBox(height: 24),
          ],
          _buildStatsRow(),
          const SizedBox(height: 24),
          _buildFinancialOverview(),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isWide = constraints.maxWidth > 700;
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildServiceStatusStats()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTopServicesTable(context)),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildServiceStatusStats(),
                    const SizedBox(height: 24),
                    _buildTopServicesTable(context),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 24),
          _buildClientStats(),
        ],
      ),
    );
  }
}
