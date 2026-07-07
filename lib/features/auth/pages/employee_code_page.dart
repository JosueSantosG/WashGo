import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/core/session/session_manager.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/features/auth/models/business_summary.dart';
import 'package:washgo/features/auth/repositories/auth_repository.dart';
import 'package:washgo/features/auth/repositories/firebase_auth_repository.dart';

class EmployeeCodePage extends StatefulWidget {
  const EmployeeCodePage({super.key});

  @override
  State<EmployeeCodePage> createState() => _EmployeeCodePageState();
}

class _EmployeeCodePageState extends State<EmployeeCodePage> {
  final AuthRepository _authRepository = FirebaseAuthRepository();
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  BusinessSummary? _businessFound;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _confirmSignOut() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cerrar Sesión?'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión y volver a la pantalla de ingreso?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseAuth.instance.signOut();
        SessionManager.activeRole = null;
        if (mounted) {
          context.go('/role-selection');
        }
      } catch (e) {
        debugPrint('Error al cerrar sesión: $e');
      }
    }
  }

  void _changeProfile() {
    context.go('/select-active-role');
  }

  Future<void> _searchBusiness() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _businessFound = null;
    });

    try {
      final business = await _authRepository.getBusinessByCode(code);
      
      if (business != null) {
        setState(() {
          _businessFound = business;
        });
      } else {
        setState(() {
          _errorMessage = 'No se encontró ninguna lavandería con ese código.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ocurrió un error. Verifica el código e intenta nuevamente.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendRequest() async {
    if (_businessFound == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authRepository.requestEmployeeAccess(_businessFound!.id);
      
      if (mounted) {
        // Redirigir al auth-gate para que evalúe el nuevo estado
        context.go('/auth-gate');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al enviar la solicitud.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Unirme a Lavandería', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Cambiar de Perfil',
            onPressed: _changeProfile,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Cerrar Sesión',
            onPressed: _confirmSignOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ingresa el código de la lavandería donde vas a trabajar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Código del Negocio (Ej. WGX91K)',
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_businessFound == null)
                ElevatedButton(
                  onPressed: _searchBusiness,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Buscar Lavandería', style: TextStyle(color: Colors.white)),
                )
              else ...[
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.store, size: 48, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text(
                          _businessFound!.nombre,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        if (_businessFound!.descripcion != null)
                          Text(_businessFound!.descripcion!),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _sendRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Enviar Solicitud al Dueño', style: TextStyle(color: Colors.white)),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
