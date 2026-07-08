import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/profile/repositories/vehicle_repository.dart';
import 'package:washgo/features/profile/repositories/firebase_vehicle_repository.dart';
import 'package:washgo/features/dashboard/client/models/vehicle_item.dart';

class VehicleDialogs {
  static final VehicleRepository _vehicleRepository = FirebaseVehicleRepository();

  static void _showSnackBar(
    BuildContext context,
    String msg, {
    Color? backgroundColor,
  }) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static void confirmDeleteVehicle(
    BuildContext context,
    VehicleItem vehicle,
    VoidCallback onVehicleChanged,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Eliminar Vehículo',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar tu ${vehicle.categoryDisplayName}?',
            style: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(color: AppColors.outline),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                try {
                  await _vehicleRepository.deleteVehicle(vehicle.id);

                  if (context.mounted) {
                    _showSnackBar(context, 'Vehículo eliminado.');
                    onVehicleChanged();
                  }
                } catch (e) {
                  if (context.mounted) {
                    _showSnackBar(
                      context,
                      'Error al eliminar vehículo: $e',
                      backgroundColor: AppColors.error,
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  static void showAddVehicleDialog(
    BuildContext context,
    VoidCallback onVehicleChanged,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddVehicleDialog(
          vehicleRepository: _vehicleRepository,
          onVehicleChanged: onVehicleChanged,
        );
      },
    );
  }

  static void showEditVehicleDialog(
    BuildContext context,
    VehicleItem vehicle,
    VoidCallback onVehicleChanged,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return EditVehicleDialog(
          vehicleRepository: _vehicleRepository,
          vehicle: vehicle,
          onVehicleChanged: onVehicleChanged,
        );
      },
    );
  }
}

String _normalizeDbCategory(String? dbCategory) {
  if (dbCategory == null) return 'Pequeño';
  final lower = dbCategory.toLowerCase().trim();
  if (lower.contains('moto')) return 'Moto';
  if (lower.contains('hatchback') || lower.contains('pequeñ') || lower.contains('pequen')) return 'Pequeño';
  if (lower.contains('suv') || lower.contains('grand')) return 'Grande';
  if (lower.contains('median') || lower.contains('sedan') || lower.contains('crossover')) return 'Mediano';
  return 'Pequeño'; // Default fallback
}

class AddVehicleDialog extends StatefulWidget {
  final VehicleRepository vehicleRepository;
  final VoidCallback onVehicleChanged;

  const AddVehicleDialog({
    super.key,
    required this.vehicleRepository,
    required this.onVehicleChanged,
  });

  @override
  State<AddVehicleDialog> createState() => _AddVehicleDialogState();
}

class _AddVehicleDialogState extends State<AddVehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();

  Map<String, String> _categoryToModelIdMap = {};
  String? _selectedCategory;
  String? _selectedModelId;

  bool _loadingData = false;
  bool _saving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCategoryMapping();
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _initializeCategoryMapping() async {
    if (!mounted) return;
    setState(() {
      _loadingData = true;
      _errorMessage = null;
    });
    try {
      final brands = await widget.vehicleRepository.getVehicleBrands();
      if (!mounted) return;

      final results = await Future.wait(
        brands.map((b) => widget.vehicleRepository.getVehicleModelsByBrand(b['id']!))
      );

      if (!mounted) return;

      final newMap = <String, String>{};
      for (final modelsList in results) {
        for (final model in modelsList) {
          final id = model['id'] as String?;
          final cat = model['category'] as String?;
          if (id == null || cat == null) continue;

          final normalized = _normalizeDbCategory(cat);
          if (!newMap.containsKey(normalized)) {
            newMap[normalized] = id;
          }
        }
      }

      setState(() {
        _categoryToModelIdMap = newMap;
        _loadingData = false;
        if (_selectedCategory != null) {
          _selectedModelId = _categoryToModelIdMap[_selectedCategory];
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingData = false;
        _errorMessage = 'Error al inicializar categorías: $e';
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      setState(() {
        _errorMessage = 'Por favor, selecciona una categoría.';
      });
      return;
    }

    final modelId = _selectedModelId ?? _categoryToModelIdMap[_selectedCategory];
    if (modelId == null) {
      setState(() {
        _errorMessage = 'Error al asignar el modelo para esta categoría. Inténtalo de nuevo.';
      });
      return;
    }

    setState(() {
      _saving = true;
      _errorMessage = null;
    });

    try {
      final plateVal = _plateController.text.trim().toUpperCase();
      await widget.vehicleRepository.addVehicle(
        modelId: modelId,
        plate: plateVal.isEmpty ? null : plateVal,
        category: _selectedCategory,
      );
      if (mounted) {
        Navigator.pop(context);
        widget.onVehicleChanged();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _errorMessage = 'Error al guardar el vehículo: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          const Icon(Icons.add_road_rounded, color: AppColors.primary, size: 28),
          const SizedBox(width: 12),
          Text(
            'Agregar Vehículo',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: GoogleFonts.inter(color: AppColors.error, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              if (_loadingData)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Cargando categorías...'),
                      ],
                    ),
                  ),
                )
              else ...[
                // CATEGORY SELECTOR (PREMIUM CARDS)
                VehicleCategorySelector(
                  selectedCategory: _selectedCategory,
                  onSelected: (cat) {
                    setState(() {
                      _selectedCategory = cat;
                      _selectedModelId = _categoryToModelIdMap[cat];
                    });
                  },
                ),
                const SizedBox(height: 16),

                // PLATE FIELD
                TextField(
                  controller: _plateController,
                  textCapitalization: TextCapitalization.characters,
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Placa (Opcional - ej: GYB-1234)',
                    labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.pin, color: AppColors.primary),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: Text(
            'Cancelar',
            style: GoogleFonts.inter(color: AppColors.outline, fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          onPressed: (_saving || _loadingData) ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Text(
                  'Guardar',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}

class EditVehicleDialog extends StatefulWidget {
  final VehicleRepository vehicleRepository;
  final VehicleItem vehicle;
  final VoidCallback onVehicleChanged;

  const EditVehicleDialog({
    super.key,
    required this.vehicleRepository,
    required this.vehicle,
    required this.onVehicleChanged,
  });

  @override
  State<EditVehicleDialog> createState() => _EditVehicleDialogState();
}

class _EditVehicleDialogState extends State<EditVehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _plateController;

  Map<String, String> _categoryToModelIdMap = {};
  String? _selectedCategory;
  String? _selectedModelId;

  bool _loadingData = false;
  bool _saving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _plateController = TextEditingController(text: widget.vehicle.plate);
    _selectedCategory = _normalizeDbCategory(widget.vehicle.type);
    _selectedModelId = widget.vehicle.modelId;
    _initializeCategoryMapping();
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _initializeCategoryMapping() async {
    if (!mounted) return;
    setState(() {
      _loadingData = true;
      _errorMessage = null;
    });
    try {
      final brands = await widget.vehicleRepository.getVehicleBrands();
      if (!mounted) return;

      final results = await Future.wait(
        brands.map((b) => widget.vehicleRepository.getVehicleModelsByBrand(b['id']!))
      );

      if (!mounted) return;

      final newMap = <String, String>{};
      for (final modelsList in results) {
        for (final model in modelsList) {
          final id = model['id'] as String?;
          final cat = model['category'] as String?;
          if (id == null || cat == null) continue;

          final normalized = _normalizeDbCategory(cat);
          if (!newMap.containsKey(normalized)) {
            newMap[normalized] = id;
          }
        }
      }

      setState(() {
        _categoryToModelIdMap = newMap;
        _loadingData = false;
        if (_selectedCategory != null && _selectedModelId == null) {
          _selectedModelId = _categoryToModelIdMap[_selectedCategory];
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingData = false;
        _errorMessage = 'Error al inicializar categorías: $e';
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      setState(() {
        _errorMessage = 'Por favor, selecciona una categoría.';
      });
      return;
    }

    // If they changed the category, resolve the mapped model ID. Otherwise, keep current.
    String? modelId = _selectedModelId;
    if (_selectedCategory != _normalizeDbCategory(widget.vehicle.type)) {
      modelId = _categoryToModelIdMap[_selectedCategory];
    }

    if (modelId == null) {
      setState(() {
        _errorMessage = 'Error al asignar el modelo para esta categoría. Inténtalo de nuevo.';
      });
      return;
    }

    setState(() {
      _saving = true;
      _errorMessage = null;
    });

    try {
      final plateVal = _plateController.text.trim().toUpperCase();
      await widget.vehicleRepository.updateVehicle(
        id: widget.vehicle.id,
        modelId: modelId,
        plate: plateVal.isEmpty ? null : plateVal,
        category: _selectedCategory,
      );
      if (mounted) {
        Navigator.pop(context);
        widget.onVehicleChanged();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _errorMessage = 'Error al actualizar el vehículo: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          const Icon(Icons.edit_road_rounded, color: AppColors.primary, size: 28),
          const SizedBox(width: 12),
          Text(
            'Editar Vehículo',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: GoogleFonts.inter(color: AppColors.error, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (_loadingData)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Cargando categorías...'),
                      ],
                    ),
                  ),
                )
              else ...[
                // CATEGORY SELECTOR (PREMIUM CARDS)
                VehicleCategorySelector(
                  selectedCategory: _selectedCategory,
                  onSelected: (cat) {
                    setState(() {
                      _selectedCategory = cat;
                      _selectedModelId = _categoryToModelIdMap[cat];
                    });
                  },
                ),
                const SizedBox(height: 16),

                // PLATE FIELD
                TextField(
                  controller: _plateController,
                  textCapitalization: TextCapitalization.characters,
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Placa (Opcional - ej: GYB-1234)',
                    labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.pin, color: AppColors.primary),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: Text(
            'Cancelar',
            style: GoogleFonts.inter(color: AppColors.outline, fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          onPressed: (_saving || _loadingData) ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Text(
                  'Guardar',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}

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
