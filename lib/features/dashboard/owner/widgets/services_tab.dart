import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/features/laundries/models/washgo_service.dart';

class ServicesTab extends StatelessWidget {
  final List<WashGoService> services;
  final AnimationController animationController;
  final void Function(String id, bool active, String nombre) onToggleActive;
  final void Function(WashGoService service) onEditService;
  final void Function(String id, String nombre) onDeleteService;
  final VoidCallback onAddService;

  const ServicesTab({
    super.key,
    required this.services,
    required this.animationController,
    required this.onToggleActive,
    required this.onEditService,
    required this.onDeleteService,
    required this.onAddService,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gestión de Servicios',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Configura y organiza tu catálogo de limpieza.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            if (services.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.layers_clear_rounded,
                      size: 48,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No tienes servicios configurados',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Crea tu primer servicio de lavado usando el botón inferior.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: services.map((service) {
                  IconData serviceIcon = Icons.local_car_wash_rounded;
                  final lowerName = service.nombre.toLowerCase();
                  if (lowerName.contains('básico') ||
                      lowerName.contains('basico')) {
                    serviceIcon = Icons.local_car_wash;
                  } else if (lowerName.contains('premium') ||
                      lowerName.contains('completo')) {
                    serviceIcon = Icons.auto_awesome;
                  } else if (lowerName.contains('detallado') ||
                      lowerName.contains('interior')) {
                    serviceIcon = Icons.chair_rounded;
                  }

                  final tipoVal = service.tipo;
                  final tipoText = tipoVal == ServiceType.LOCAL
                      ? 'En Local'
                      : 'A Domicilio';

                  final isServiceActive = service.activo;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isServiceActive
                          ? Colors.white
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isServiceActive
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                      border: Border.all(
                        color: isServiceActive
                            ? Colors.grey.shade100
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: isServiceActive
                            ? Colors.blue.shade50
                            : Colors.grey.shade100,
                        child: Icon(
                          serviceIcon,
                          color: isServiceActive
                              ? AppColors.primary
                              : Colors.grey.shade400,
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              service.nombre,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isServiceActive
                                    ? AppColors.onSurface
                                    : Colors.grey.shade500,
                                decoration: isServiceActive
                                    ? null
                                    : TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                          if (!isServiceActive) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Inactivo',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isServiceActive
                                  ? Colors.blue.shade50
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tipoText,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isServiceActive
                                    ? AppColors.primary
                                    : Colors.grey.shade500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (service.descripcion != null &&
                              service.descripcion!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              service.descripcion!,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: isServiceActive
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: isServiceActive
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${service.duracionMinutos} min',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: isServiceActive
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _buildCategoryPrice('Pequeño', service.precioPequeno, isServiceActive),
                              _buildCategoryPrice('Mediano', service.precioMediano, isServiceActive),
                              _buildCategoryPrice('Grande', service.precioGrande, isServiceActive),
                              _buildCategoryPrice('Moto', service.precioMoto, isServiceActive),
                            ],
                          ),
                          if (service.precioPendiente) ...[
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.pause_circle_filled_rounded,
                                        size: 16,
                                        color: Colors.orange.shade800,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'SUSPENDIDO — Precios propuestos:',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange.shade800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      _buildCategoryPrice('Pequeño', service.precioOwnerPequeno, false, isProposed: true),
                                      _buildCategoryPrice('Mediano', service.precioOwnerMediano, false, isProposed: true),
                                      _buildCategoryPrice('Grande', service.precioOwnerGrande, false, isProposed: true),
                                      _buildCategoryPrice('Moto', service.precioOwnerMoto, false, isProposed: true),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Esperando aprobación del administrador',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: isServiceActive,
                            activeThumbColor: AppColors.primary,
                            onChanged: service.precioPendiente
                                ? null
                                : (value) {
                                    onToggleActive(service.id, value, service.nombre);
                                  },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit_outlined,
                              color: service.precioPendiente ? Colors.grey : Colors.blue,
                            ),
                            onPressed: service.precioPendiente
                                ? null
                                : () => onEditService(service),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Eliminar Servicio'),
                                  content: Text(
                                    '¿Estás seguro de que deseas eliminar "${service.nombre}"?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        onDeleteService(
                                          service.id,
                                          service.nombre,
                                        );
                                      },
                                      child: const Text(
                                        'Eliminar',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¿Quieres ofrecer más?',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Personaliza tus servicios para atraer más clientes.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.blue.shade900.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onAddService,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Agregar Nuevo Servicio'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPrice(String label, double price, bool isActive, {bool isProposed = false}) {
    final bgColor = isProposed 
        ? Colors.orange.shade100.withValues(alpha: 0.5)
        : (isActive ? Colors.blue.shade50 : Colors.grey.shade100);
    final borderColor = isProposed
        ? Colors.orange.shade200
        : (isActive ? Colors.blue.shade200 : Colors.grey.shade300);
    final labelColor = isProposed
        ? Colors.orange.shade800
        : (isActive ? Colors.blue.shade800 : Colors.grey.shade600);
    final priceColor = isProposed
        ? Colors.orange.shade900
        : (isActive ? Colors.blue.shade900 : Colors.grey.shade700);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: priceColor,
            ),
          ),
        ],
      ),
    );
  }
}
