import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';

class CategoryOption {
  final String key; // 'Moto', 'Pequeño', 'Mediano', 'Grande'
  final String title;
  final String examples;
  final IconData icon;
  final String emoji;

  const CategoryOption({
    required this.key,
    required this.title,
    required this.examples,
    required this.icon,
    required this.emoji,
  });
}

const List<CategoryOption> _categoryOptions = [
  CategoryOption(
    key: 'Moto',
    title: 'Moto',
    examples: 'Motocicleta, Scooter, Motoneta',
    icon: Icons.motorcycle_rounded,
    emoji: '🏍',
  ),
  CategoryOption(
    key: 'Pequeño',
    title: 'Pequeño',
    examples: 'Hatchback, Sedán compacto, Coupé',
    icon: Icons.directions_car_filled_rounded,
    emoji: '🚗',
  ),
  CategoryOption(
    key: 'Mediano',
    title: 'Mediano',
    examples: 'Sedán mediano, Crossover, SUV compacto',
    icon: Icons.directions_car_rounded,
    emoji: '🚙',
  ),
  CategoryOption(
    key: 'Grande',
    title: 'Grande',
    examples: 'SUV grande, Pick-up / Camioneta, Minivan / Van',
    icon: Icons.airport_shuttle_rounded,
    emoji: '🚐',
  ),
];

class VehicleCategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String> onSelected;

  const VehicleCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0, top: 4.0),
          child: Text(
            'Categoría del Vehículo',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.onSurface,
            ),
          ),
        ),
        Text(
          'Selecciona la categoría que mejor describa el tamaño de tu vehículo. Esta categoría será utilizada por los establecimientos para calcular el precio de los servicios.',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.outline,
          ),
        ),
        const SizedBox(height: 12),
        ..._categoryOptions.map((option) {
          final isSelected = selectedCategory == option.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () => onSelected(option.key),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primary.withValues(alpha: 0.06) 
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  boxShadow: isSelected 
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.primary.withValues(alpha: 0.12) 
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        option.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.title,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isSelected ? AppColors.primary : AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            option.examples,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isSelected 
                                  ? AppColors.primary.withValues(alpha: 0.8) 
                                  : AppColors.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
                        size: 24,
                      )
                    else
                      Icon(
                        Icons.radio_button_unchecked_rounded,
                        color: Colors.grey.shade400,
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
