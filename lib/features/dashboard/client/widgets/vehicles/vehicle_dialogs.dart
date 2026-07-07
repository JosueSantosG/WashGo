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
            '¿Estás seguro de que deseas eliminar tu ${vehicle.brandModel}?',
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
  final _categoryController = TextEditingController();

  List<Map<String, String>> _brands = [];
  List<Map<String, dynamic>> _models = [];

  String? _selectedBrandId;
  String? _selectedModelId;
  String? _detectedCategory;

  bool _loadingBrands = false;
  bool _loadingModels = false;
  bool _saving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  @override
  void dispose() {
    _plateController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _loadBrands() async {
    if (!mounted) return;
    setState(() {
      _loadingBrands = true;
      _errorMessage = null;
    });
    try {
      final brands = await widget.vehicleRepository.getVehicleBrands();
      if (!mounted) return;
      setState(() {
        _brands = brands;
        _loadingBrands = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingBrands = false;
        _errorMessage = 'Error al cargar marcas: $e';
      });
    }
  }

  Future<void> _loadModels(String brandId) async {
    if (!mounted) return;
    setState(() {
      _loadingModels = true;
      _selectedModelId = null;
      _detectedCategory = null;
      _categoryController.clear();
      _models = [];
      _errorMessage = null;
    });
    try {
      final models = await widget.vehicleRepository.getVehicleModelsByBrand(brandId);
      if (!mounted) return;
      setState(() {
        _models = models;
        _loadingModels = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingModels = false;
        _errorMessage = 'Error al cargar modelos: $e';
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedModelId == null || _detectedCategory == null) {
      setState(() {
        _errorMessage = 'Por favor, selecciona una marca y un modelo.';
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
        modelId: _selectedModelId!,
        plate: plateVal.isEmpty ? null : plateVal,
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
    IconData categoryIcon = Icons.directions_car_filled_rounded;
    if (_detectedCategory == 'SUV') categoryIcon = Icons.airport_shuttle_rounded;
    if (_detectedCategory == 'Hatchback') categoryIcon = Icons.directions_car_filled_rounded;
    if (_detectedCategory == 'Moto') categoryIcon = Icons.motorcycle_rounded;

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
              
              // BRAND DROPDOWN
              _loadingBrands
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: CircularProgressIndicator(),
                    )
                  : DropdownButtonFormField<String>(
                      initialValue: _selectedBrandId,
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Marca',
                        labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.branding_watermark, color: AppColors.primary),
                      ),
                      validator: (value) => value == null ? 'Por favor selecciona una marca' : null,
                      items: _brands.map((brand) {
                        return DropdownMenuItem<String>(
                          value: brand['id'],
                          child: Text(brand['name'] ?? ''),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedBrandId = val;
                          });
                          _loadModels(val);
                        }
                      },
                    ),
              const SizedBox(height: 16),

              // MODEL DROPDOWN
              DropdownButtonFormField<String>(
                initialValue: _selectedModelId,
                disabledHint: Text(
                  _selectedBrandId == null ? 'Selecciona una marca primero' : 'Cargando modelos...',
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.outline),
                ),
                style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurface),
                decoration: InputDecoration(
                  labelText: 'Modelo',
                  labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.car_rental, color: AppColors.primary),
                  suffixIcon: _loadingModels
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                ),
                validator: (value) => value == null ? 'Por favor selecciona un modelo' : null,
                items: _models.map((model) {
                  return DropdownMenuItem<String>(
                    value: model['id'],
                    child: Text(model['name'] ?? ''),
                  );
                }).toList(),
                onChanged: _selectedBrandId == null || _loadingModels
                    ? null
                    : (val) {
                        if (val != null) {
                          final selectedModel = _models.firstWhere((m) => m['id'] == val);
                          setState(() {
                            _selectedModelId = val;
                            _detectedCategory = selectedModel['category'];
                            _categoryController.text = _detectedCategory ?? '';
                          });
                        }
                      },
              ),
              const SizedBox(height: 16),

              // CATEGORY DISPLAY (READ ONLY)
              if (_detectedCategory != null) ...[
                TextField(
                  controller: _categoryController,
                  readOnly: true,
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Categoría Auto-detectada',
                    labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.outline),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(categoryIcon, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 16),
              ],

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
          onPressed: _saving ? null : _save,
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
  final _categoryController = TextEditingController();

  List<Map<String, String>> _brands = [];
  List<Map<String, dynamic>> _models = [];

  String? _selectedBrandId;
  String? _selectedModelId;
  String? _detectedCategory;

  bool _loadingBrands = false;
  bool _loadingModels = false;
  bool _saving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _plateController = TextEditingController(text: widget.vehicle.plate);
    _selectedBrandId = widget.vehicle.brandId;
    _selectedModelId = widget.vehicle.modelId;
    _detectedCategory = widget.vehicle.type;
    _categoryController.text = _detectedCategory ?? '';
    _initializeData();
  }

  @override
  void dispose() {
    _plateController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    if (!mounted) return;
    setState(() {
      _loadingBrands = true;
      _errorMessage = null;
    });
    try {
      final brands = await widget.vehicleRepository.getVehicleBrands();
      if (!mounted) return;
      setState(() {
        _brands = brands;
        _loadingBrands = false;
      });

      if (_selectedBrandId != null) {
        setState(() {
          _loadingModels = true;
        });
        final models = await widget.vehicleRepository.getVehicleModelsByBrand(_selectedBrandId!);
        if (!mounted) return;
        setState(() {
          _models = models;
          _loadingModels = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingBrands = false;
        _loadingModels = false;
        _errorMessage = 'Error al cargar datos del vehículo: $e';
      });
    }
  }

  Future<void> _loadModels(String brandId) async {
    if (!mounted) return;
    setState(() {
      _loadingModels = true;
      _selectedModelId = null;
      _detectedCategory = null;
      _categoryController.clear();
      _models = [];
      _errorMessage = null;
    });
    try {
      final models = await widget.vehicleRepository.getVehicleModelsByBrand(brandId);
      if (!mounted) return;
      setState(() {
        _models = models;
        _loadingModels = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingModels = false;
        _errorMessage = 'Error al cargar modelos: $e';
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedModelId == null || _detectedCategory == null) {
      setState(() {
        _errorMessage = 'Por favor, selecciona una marca y un modelo.';
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
        modelId: _selectedModelId!,
        plate: plateVal.isEmpty ? null : plateVal,
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
    IconData categoryIcon = Icons.directions_car_filled_rounded;
    if (_detectedCategory == 'SUV') categoryIcon = Icons.airport_shuttle_rounded;
    if (_detectedCategory == 'Hatchback') categoryIcon = Icons.directions_car_filled_rounded;
    if (_detectedCategory == 'Moto') categoryIcon = Icons.motorcycle_rounded;

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

              // BRAND DROPDOWN
              _loadingBrands
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: CircularProgressIndicator(),
                    )
                  : DropdownButtonFormField<String>(
                      initialValue: _selectedBrandId,
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Marca',
                        labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.branding_watermark, color: AppColors.primary),
                      ),
                      validator: (value) => value == null ? 'Por favor selecciona una marca' : null,
                      items: _brands.map((brand) {
                        return DropdownMenuItem<String>(
                          value: brand['id'],
                          child: Text(brand['name'] ?? ''),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedBrandId = val;
                          });
                          _loadModels(val);
                        }
                      },
                    ),
              const SizedBox(height: 16),

              // MODEL DROPDOWN
              DropdownButtonFormField<String>(
                initialValue: _selectedModelId,
                disabledHint: Text(
                  _selectedBrandId == null ? 'Selecciona una marca primero' : 'Cargando modelos...',
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.outline),
                ),
                style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurface),
                decoration: InputDecoration(
                  labelText: 'Modelo',
                  labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.car_rental, color: AppColors.primary),
                  suffixIcon: _loadingModels
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                ),
                validator: (value) => value == null ? 'Por favor selecciona un modelo' : null,
                items: _models.map((model) {
                  return DropdownMenuItem<String>(
                    value: model['id'],
                    child: Text(model['name'] ?? ''),
                  );
                }).toList(),
                onChanged: _selectedBrandId == null || _loadingModels
                    ? null
                    : (val) {
                        if (val != null) {
                          final selectedModel = _models.firstWhere((m) => m['id'] == val);
                          setState(() {
                            _selectedModelId = val;
                            _detectedCategory = selectedModel['category'];
                            _categoryController.text = _detectedCategory ?? '';
                          });
                        }
                      },
              ),
              const SizedBox(height: 16),

              // CATEGORY DISPLAY (READ ONLY)
              if (_detectedCategory != null) ...[
                TextField(
                  controller: _categoryController,
                  readOnly: true,
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Categoría Auto-detectada',
                    labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.outline),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(categoryIcon, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 16),
              ],

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
          onPressed: _saving ? null : _save,
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
