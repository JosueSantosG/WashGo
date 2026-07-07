import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/config/routes/app_routes.dart';
import 'package:latlong2/latlong.dart';
import 'package:washgo/features/laundries/repositories/laundry_repository.dart';
import 'package:washgo/features/laundries/repositories/firebase_laundry_repository.dart';
import 'package:washgo/features/laundries/repositories/business_repository.dart';
import 'package:washgo/features/laundries/repositories/firebase_business_repository.dart';
import 'package:washgo/core/session/session_manager.dart';
import 'package:washgo/features/laundries/repositories/reservation_config_repository.dart';
import 'package:washgo/features/laundries/repositories/firebase_reservation_config_repository.dart';

class CreateLaundryPage extends StatefulWidget {
  const CreateLaundryPage({super.key});

  @override
  State<CreateLaundryPage> createState() => _CreateLaundryPageState();
}

class _CreateLaundryPageState extends State<CreateLaundryPage> {
  final LaundryRepository _laundryRepository = FirebaseLaundryRepository();
  final ReservationConfigRepository _reservationConfigRepository =
      FirebaseReservationConfigRepository();
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _rucController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _capacidadController = TextEditingController(text: '1');
  final _anticipacionController = TextEditingController(text: '30');

  @override
  void dispose() {
    _nombreController.dispose();
    _rucController.dispose();
    _telefonoController.dispose();
    _descripcionController.dispose();
    _capacidadController.dispose();
    _anticipacionController.dispose();
    super.dispose();
  }

  // The list of services to be registered (starts empty as requested)
  final List<Map<String, dynamic>> _addedServices = [];

  // Operating Hours details
  TimeOfDay _horaApertura = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _horaCierre = const TimeOfDay(hour: 18, minute: 0);

  // Selected operating days (1 = Lunes, 7 = Domingo)
  final List<String> _diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];
  final List<bool> _diasSeleccionados = [
    true,
    true,
    true,
    true,
    true,
    true,
    false,
  ]; // Default: Lun-Sab open, Dom closed

  bool _isLoading = false;
  LatLng? _selectedLocation;

  String _generateBusinessCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final code = String.fromCharCodes(
      Iterable.generate(
        5,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
    return 'WASH-$code';
  }

  Future<void> _selectTime(BuildContext context, bool isApertura) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isApertura ? _horaApagado : _horaEncendido,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isApertura) {
          _horaApertura = picked;
        } else {
          _horaCierre = picked;
        }
      });
    }
  }

  // Support old variable name mapping if any
  TimeOfDay get _horaApagado => _horaApertura;
  TimeOfDay get _horaEncendido => _horaCierre;

  void _showAddServiceDialog() {
    final dialogFormKey = GlobalKey<FormState>();
    final nombreController = TextEditingController();
    final precioPequenoController = TextEditingController();
    final precioMedianoController = TextEditingController();
    final precioGrandeController = TextEditingController();
    final precioMotoController = TextEditingController();
    final duracionController = TextEditingController();
    final descripcionController = TextEditingController();
    ServiceType tipoServicio = ServiceType.LOCAL;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(Icons.add_task_rounded, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Agregar Nuevo Servicio',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Form(
                  key: dialogFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nombreController,
                        style: GoogleFonts.inter(fontSize: 14),
                        decoration: InputDecoration(
                          labelText: 'Nombre del Servicio',
                          labelStyle: GoogleFonts.inter(fontSize: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(
                            Icons.design_services,
                            color: AppColors.primary,
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'El nombre es requerido'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Precios por Categoría (\$)',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: precioPequenoController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: GoogleFonts.inter(fontSize: 13),
                              decoration: InputDecoration(
                                labelText: 'Pequeño',
                                labelStyle: GoogleFonts.inter(fontSize: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                prefixIcon: const Icon(Icons.attach_money, size: 16, color: AppColors.primary),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Requerido';
                                final val = double.tryParse(value);
                                if (val == null || val <= 0) return 'Inválido';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: precioMedianoController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: GoogleFonts.inter(fontSize: 13),
                              decoration: InputDecoration(
                                labelText: 'Mediano',
                                labelStyle: GoogleFonts.inter(fontSize: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                prefixIcon: const Icon(Icons.attach_money, size: 16, color: AppColors.primary),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Requerido';
                                final val = double.tryParse(value);
                                if (val == null || val <= 0) return 'Inválido';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: precioGrandeController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: GoogleFonts.inter(fontSize: 13),
                              decoration: InputDecoration(
                                labelText: 'Grande',
                                labelStyle: GoogleFonts.inter(fontSize: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                prefixIcon: const Icon(Icons.attach_money, size: 16, color: AppColors.primary),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Requerido';
                                final val = double.tryParse(value);
                                if (val == null || val <= 0) return 'Inválido';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: precioMotoController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: GoogleFonts.inter(fontSize: 13),
                              decoration: InputDecoration(
                                labelText: 'Moto',
                                labelStyle: GoogleFonts.inter(fontSize: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                prefixIcon: const Icon(Icons.attach_money, size: 16, color: AppColors.primary),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Requerido';
                                final val = double.tryParse(value);
                                if (val == null || val <= 0) return 'Inválido';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: duracionController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.inter(fontSize: 14),
                              decoration: InputDecoration(
                                labelText: 'Duración (min)',
                                labelStyle: GoogleFonts.inter(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(
                                  Icons.timer_outlined,
                                  color: AppColors.primary,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Requerido';
                                }
                                final val = int.tryParse(value);
                                if (val == null || val <= 0) {
                                  return 'Inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<ServiceType>(
                              initialValue: tipoServicio,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.onSurface,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Tipo',
                                labelStyle: GoogleFonts.inter(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(
                                  Icons.category,
                                  color: AppColors.primary,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: ServiceType.LOCAL,
                                  child: Text('Local'),
                                ),
                                DropdownMenuItem(
                                  value: ServiceType.DOMICILIO,
                                  child: Text('Domicilio'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setDialogState(() {
                                    tipoServicio = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descripcionController,
                        style: GoogleFonts.inter(fontSize: 14),
                        decoration: InputDecoration(
                          labelText: 'Descripción del Servicio (Opcional)',
                          labelStyle: GoogleFonts.inter(fontSize: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(
                            Icons.description,
                            color: AppColors.primary,
                          ),
                        ),
                        minLines: 2,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(color: Colors.grey.shade600),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (dialogFormKey.currentState!.validate()) {
                      final double pPequeno = double.parse(precioPequenoController.text);
                      final double pMediano = double.parse(precioMedianoController.text);
                      final double pGrande = double.parse(precioGrandeController.text);
                      final double pMoto = double.parse(precioMotoController.text);
                      final int duracion = int.parse(duracionController.text);

                      setState(() {
                        _addedServices.add({
                          'nombre': nombreController.text.trim(),
                          'precioPequeno': pPequeno,
                          'precioMediano': pMediano,
                          'precioGrande': pGrande,
                          'precioMoto': pMoto,
                          'costo': 0.0,
                          'duracionMinutos': duracion,
                          'tipo': tipoServicio,
                          'descripcion': descripcionController.text.trim(),
                        });
                      });

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Servicio "${nombreController.text.trim()}" agregado.',
                          ),
                          backgroundColor: Colors.green.shade600,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditServiceDialog(int index) {
    final s = _addedServices[index];
    final dialogFormKey = GlobalKey<FormState>();
    final nombreController = TextEditingController(text: s['nombre']);
    final precioPequenoController = TextEditingController(text: s['precioPequeno'].toString());
    final precioMedianoController = TextEditingController(text: s['precioMediano'].toString());
    final precioGrandeController = TextEditingController(text: s['precioGrande'].toString());
    final precioMotoController = TextEditingController(text: s['precioMoto'].toString());
    final duracionController = TextEditingController(text: s['duracionMinutos'].toString());
    final descripcionController = TextEditingController(text: s['descripcion'] ?? '');
    ServiceType tipoServicio = s['tipo'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(Icons.edit_rounded, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Editar Servicio',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Form(
                  key: dialogFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nombreController,
                        style: GoogleFonts.inter(fontSize: 14),
                        decoration: InputDecoration(
                          labelText: 'Nombre del Servicio',
                          labelStyle: GoogleFonts.inter(fontSize: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(
                            Icons.design_services,
                            color: AppColors.primary,
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'El nombre es requerido'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Precios por Categoría (\$)',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: precioPequenoController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: GoogleFonts.inter(fontSize: 13),
                              decoration: InputDecoration(
                                labelText: 'Pequeño',
                                labelStyle: GoogleFonts.inter(fontSize: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                prefixIcon: const Icon(Icons.attach_money, size: 16, color: AppColors.primary),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Requerido';
                                final val = double.tryParse(value);
                                if (val == null || val <= 0) return 'Inválido';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: precioMedianoController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: GoogleFonts.inter(fontSize: 13),
                              decoration: InputDecoration(
                                labelText: 'Mediano',
                                labelStyle: GoogleFonts.inter(fontSize: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                prefixIcon: const Icon(Icons.attach_money, size: 16, color: AppColors.primary),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Requerido';
                                final val = double.tryParse(value);
                                if (val == null || val <= 0) return 'Inválido';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: precioGrandeController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: GoogleFonts.inter(fontSize: 13),
                              decoration: InputDecoration(
                                labelText: 'Grande',
                                labelStyle: GoogleFonts.inter(fontSize: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                prefixIcon: const Icon(Icons.attach_money, size: 16, color: AppColors.primary),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Requerido';
                                final val = double.tryParse(value);
                                if (val == null || val <= 0) return 'Inválido';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: precioMotoController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              style: GoogleFonts.inter(fontSize: 13),
                              decoration: InputDecoration(
                                labelText: 'Moto',
                                labelStyle: GoogleFonts.inter(fontSize: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                prefixIcon: const Icon(Icons.attach_money, size: 16, color: AppColors.primary),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Requerido';
                                final val = double.tryParse(value);
                                if (val == null || val <= 0) return 'Inválido';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: duracionController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.inter(fontSize: 14),
                              decoration: InputDecoration(
                                labelText: 'Duración (min)',
                                labelStyle: GoogleFonts.inter(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(
                                  Icons.timer_outlined,
                                  color: AppColors.primary,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Requerido';
                                }
                                final val = int.tryParse(value);
                                if (val == null || val <= 0) {
                                  return 'Inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<ServiceType>(
                              initialValue: tipoServicio,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.onSurface,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Tipo',
                                labelStyle: GoogleFonts.inter(fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(
                                  Icons.category,
                                  color: AppColors.primary,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: ServiceType.LOCAL,
                                  child: Text('Local'),
                                ),
                                DropdownMenuItem(
                                  value: ServiceType.DOMICILIO,
                                  child: Text('Domicilio'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setDialogState(() {
                                    tipoServicio = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descripcionController,
                        style: GoogleFonts.inter(fontSize: 14),
                        decoration: InputDecoration(
                          labelText: 'Descripción del Servicio (Opcional)',
                          labelStyle: GoogleFonts.inter(fontSize: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(
                            Icons.description,
                            color: AppColors.primary,
                          ),
                        ),
                        minLines: 2,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.inter(color: Colors.grey.shade600),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (dialogFormKey.currentState!.validate()) {
                      final double pPequeno = double.parse(precioPequenoController.text);
                      final double pMediano = double.parse(precioMedianoController.text);
                      final double pGrande = double.parse(precioGrandeController.text);
                      final double pMoto = double.parse(precioMotoController.text);
                      final int duracion = int.parse(duracionController.text);

                      setState(() {
                        _addedServices[index] = {
                          'nombre': nombreController.text.trim(),
                          'precioPequeno': pPequeno,
                          'precioMediano': pMediano,
                          'precioGrande': pGrande,
                          'precioMoto': pMoto,
                          'costo': s['costo'] ?? 0.0,
                          'duracionMinutos': duracion,
                          'tipo': tipoServicio,
                          'descripcion': descripcionController.text.trim(),
                        };
                      });

                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _crearLavanderia() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, selecciona la ubicación del local en el mapa.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_addedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes agregar al menos un servicio para registrar el local.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Check if at least one operating day is selected
    if (!_diasSeleccionados.contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona al menos un día de atención.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final uuid = const Uuid().v4();
      final businessCode = _generateBusinessCode();

      // 1. Create Business
      await _laundryRepository.createBusiness(
        id: uuid,
        nombre: _nombreController.text.trim(),
        ruc: _rucController.text.trim(),
        businessCode: businessCode,
        descripcion: _descripcionController.text.isNotEmpty
            ? _descripcionController.text.trim()
            : null,
        telefono: _telefonoController.text.trim(),
        latitud: _selectedLocation!.latitude,
        longitud: _selectedLocation!.longitude,
      );

      // 2. Create all Services from the list
      for (final service in _addedServices) {
        await _laundryRepository.createService(
          businessId: uuid,
          nombre: service['nombre'],
          precioPequeno: service['precioPequeno'],
          precioMediano: service['precioMediano'],
          precioGrande: service['precioGrande'],
          precioMoto: service['precioMoto'],
          duracionMinutos: service['duracionMinutos'],
          tipo: service['tipo'],
          descripcion: service['descripcion']?.isNotEmpty == true
              ? service['descripcion']
              : 'Configurado durante el registro inicial del negocio.',
        );
      }

      // 3. Create Operating Hours for each day (1 = Lunes, 7 = Domingo)
      final String aperturaStr =
          '${_horaApertura.hour.toString().padLeft(2, '0')}:${_horaApertura.minute.toString().padLeft(2, '0')}';
      final String cierreStr =
          '${_horaCierre.hour.toString().padLeft(2, '0')}:${_horaCierre.minute.toString().padLeft(2, '0')}';

      for (int i = 1; i <= 7; i++) {
        final bool esDescanso = !_diasSeleccionados[i - 1];
        await _laundryRepository.createBusinessHour(
          businessId: uuid,
          diaDeLaSemana: i,
          esDiaDescanso: esDescanso,
          horaApertura: esDescanso ? null : aperturaStr,
          horaCierre: esDescanso ? null : cierreStr,
        );
      }

      // 4. Create Reservation Config
      final int capacidad = int.tryParse(_capacidadController.text) ?? 1;
      final int anticipacion = int.tryParse(_anticipacionController.text) ?? 0;
      await _reservationConfigRepository.saveConfig(
        businessId: uuid,
        capacidadSimultanea: capacidad,
        tiempoAnticipacionMinutos: anticipacion,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '¡Local "${_nombreController.text.trim()}" creado exitosamente! Código: $businessCode',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Auto-switch to the newly created business
      final BusinessRepository businessRepository = FirebaseBusinessRepository();
      await businessRepository.switchCurrentBusiness(uuid);

      // Set active role and redirect or pop
      SessionManager.activeRole = UserRole.ADMINISTRADOR;
      if (mounted) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        } else {
          context.go(AppRoutes.ownerDashboard);
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar lavandería: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Configuración del Negocio',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Registra tu Local',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Completa los datos para iniciar tu negocio en WashGo',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Section 1: Basic Info
              _buildSectionCard(
                title: 'Información del Local',
                icon: Icons.store_rounded,
                children: [
                  TextFormField(
                    controller: _nombreController,
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'Nombre de la Lavandería',
                      labelStyle: GoogleFonts.inter(fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(
                        Icons.store,
                        color: AppColors.primary,
                      ),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'El nombre es requerido'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _rucController,
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'RUC / Identificación Fiscal',
                      labelStyle: GoogleFonts.inter(fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(
                        Icons.assignment,
                        color: AppColors.primary,
                      ),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'El RUC es requerido'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _telefonoController,
                    keyboardType: TextInputType.phone,
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'Número de Teléfono del Local',
                      labelStyle: GoogleFonts.inter(fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: AppColors.primary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El número de teléfono es requerido';
                      }
                      final cleanVal = value.replaceAll(RegExp(r'\s+|-|\+'), '');
                      if (cleanVal.length < 7 || int.tryParse(cleanVal) == null) {
                        return 'Ingresa un número de teléfono válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descripcionController,
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'Descripción del Local',
                      labelStyle: GoogleFonts.inter(fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(
                        Icons.description,
                        color: AppColors.primary,
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),

              // Section 2: Ubicación
              _buildSectionCard(
                title: 'Ubicación en el Mapa',
                icon: Icons.location_on_rounded,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.pin_drop_outlined, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedLocation == null
                              ? 'No se ha seleccionado una ubicación'
                              : 'Lat: ${_selectedLocation!.latitude.toStringAsFixed(5)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(5)}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: _selectedLocation == null
                                ? Colors.grey.shade600
                                : AppColors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // PASS NULL if _selectedLocation is null to let the map auto-center on the user's current GPS location
                      final result = await context.push<LatLng>(
                        AppRoutes.mapPicker,
                        extra: _selectedLocation,
                      );
                      if (result != null) {
                        setState(() {
                          _selectedLocation = result;
                        });
                      }
                    },
                    icon: const Icon(Icons.map, size: 18),
                    label: Text(
                      _selectedLocation == null
                          ? 'Fijar Mapa'
                          : 'Cambiar Ubicación',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),

              // Section 3: Servicios (Gestion de servicios)
              _buildSectionCard(
                title: 'Servicios del Local',
                icon: Icons.local_laundry_service_rounded,
                children: [
                  ElevatedButton.icon(
                    onPressed: _showAddServiceDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(
                      'Agregar Servicio',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade50,
                      foregroundColor: Colors.green.shade700,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(
                        Icons.list_alt_rounded,
                        color: Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Servicios Agregados (${_addedServices.length})',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_addedServices.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.amber.shade800,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Debes agregar al menos un servicio para registrar el local (ej. Lavado Completo).',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.amber.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _addedServices.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final s = _addedServices[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primary.withValues(
                                  alpha: 0.1,
                                ),
                                child: Icon(
                                  s['tipo'] == ServiceType.LOCAL
                                      ? Icons.store_rounded
                                      : Icons.directions_car_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s['nombre'],
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${s['tipo'] == ServiceType.LOCAL ? 'En Local' : 'A Domicilio'} • ${s['duracionMinutos']} min',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${s['precioPequeno'].toStringAsFixed(0)} - \$${s['precioGrande'].toStringAsFixed(0)}',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _showEditServiceDialog(index),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _addedServices.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),

              // Section 4: Horario de Atención
              _buildSectionCard(
                title: 'Horario de Atención',
                icon: Icons.access_time_filled_rounded,
                children: [
                  Text(
                    'Selecciona los días que atiende tu local:',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.start,
                    children: List.generate(7, (index) {
                      final isSelected = _diasSeleccionados[index];
                      final label = _diasSemana[index].substring(0, 3);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _diasSeleccionados[index] =
                                !_diasSeleccionados[index];
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            label,
                            style: GoogleFonts.inter(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectTime(context, true),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hora Apertura',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.login_rounded,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _horaApertura.format(context),
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectTime(context, false),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hora Cierre',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.logout_rounded,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _horaCierre.format(context),
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_horaApertura.hour == _horaCierre.hour &&
                      _horaApertura.minute == _horaCierre.minute) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Al configurar la misma hora de apertura y cierre, el local se considerará abierto las 24 horas del día.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),

              // Section 5: Configuración de Reservas
              _buildSectionCard(
                title: 'Configuración de Reservas',
                icon: Icons.settings_suggest_rounded,
                children: [
                  Text(
                    'Define los límites de capacidad y tiempo de espera para las reservas programadas:',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _capacidadController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.inter(fontSize: 14),
                          decoration: InputDecoration(
                            labelText: 'Capacidad Simultánea',
                            helperText: 'Nro. máx. de reservas a la vez',
                            labelStyle: GoogleFonts.inter(fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(
                              Icons.people_alt_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Requerido';
                            }
                            final val = int.tryParse(value);
                            if (val == null || val <= 0) {
                              return 'Debe ser >= 1';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _anticipacionController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.inter(fontSize: 14),
                          decoration: InputDecoration(
                            labelText: 'Tiempo de Anticipación (min)',
                            helperText: 'Tiempo de espera para programar',
                            labelStyle: GoogleFonts.inter(fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(
                              Icons.hourglass_empty_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Requerido';
                            }
                            final val = int.tryParse(value);
                            if (val == null || val < 0) {
                              return 'Debe ser >= 0';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _isLoading ? null : _crearLavanderia,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Registrar Lavandería',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
