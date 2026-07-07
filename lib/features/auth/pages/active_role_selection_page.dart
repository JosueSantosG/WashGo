import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:washgo/config/theme/app_colors.dart';
import 'package:washgo/core/session/session_manager.dart';
import 'package:washgo/features/auth/repositories/auth_repository.dart';
import 'package:washgo/features/auth/repositories/firebase_auth_repository.dart';

class ActiveRoleSelectionPage extends StatefulWidget {
  const ActiveRoleSelectionPage({super.key});

  @override
  State<ActiveRoleSelectionPage> createState() => _ActiveRoleSelectionPageState();
}

class _ActiveRoleSelectionPageState extends State<ActiveRoleSelectionPage> {
  final AuthRepository _authRepository = FirebaseAuthRepository();
  List<UserRole> _roles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (!mounted) return;
      if (user != null) {
        setState(() {
          _roles = user.roles;
          _isLoading = false;
        });
      } else {
        context.go('/role-selection');
      }
    } catch (e) {
      if (!mounted) return;
      context.go('/role-selection');
    }
  }

  String _roleName(UserRole role) {
    switch (role) {
      case UserRole.CLIENTE:
        return 'Cliente';
      case UserRole.EMPLEADO:
        return 'Empleado';
      case UserRole.ADMINISTRADOR:
        return 'Dueño / Administrador';
      case UserRole.SUPER_ADMIN:
        return 'Super Admin';
    }
  }

  IconData _roleIcon(UserRole role) {
    switch (role) {
      case UserRole.CLIENTE:
        return Icons.directions_car;
      case UserRole.EMPLEADO:
        return Icons.local_car_wash;
      case UserRole.ADMINISTRADOR:
        return Icons.storefront;
      case UserRole.SUPER_ADMIN:
        return Icons.admin_panel_settings;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona tu Perfil'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _roles.length + 1, // +1 for the "Add Role" option
              itemBuilder: (context, index) {
                if (index == _roles.length) {
                  return TextButton.icon(
                    onPressed: () => context.push('/role-selection'),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar otro perfil (ej. Volverme Dueño)'),
                  );
                }
                
                final role = _roles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: Icon(_roleIcon(role), color: AppColors.primary, size: 32),
                    title: Text(_roleName(role),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Entrar a la app con este perfil'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      SessionManager.activeRole = role;
                      context.go('/auth-gate');
                    },
                  ),
                );
              },
            ),
    );
  }
}
