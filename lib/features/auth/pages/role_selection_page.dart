import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:washgo/dataconnect-generated/example.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:washgo/core/session/session_manager.dart';
import 'package:washgo/features/auth/repositories/auth_repository.dart';
import 'package:washgo/features/auth/repositories/firebase_auth_repository.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      appBar: AppBar(
        title: const Text(
          'Selección de Rol',
          style: TextStyle(color: Color(0xFF151C27)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF151C27)),
            tooltip: 'Cerrar Sesión',
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '¿Cómo quieres usar WashGo?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF151C27),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _RoleCard(
              title: 'Cliente',
              description:
                  'Quiero lavar mi auto y encontrar los mejores servicios.',
              icon: Icons.directions_car,
              onTap: () async {
                await _saveUserRole(UserRole.CLIENTE);
                if (context.mounted) {
                  context.go('/onboarding-cliente');
                }
              },
            ),
            const SizedBox(height: 16),
            _RoleCard(
              title: 'Empleado',
              description:
                  'Trabajo en un autolavado o soy lavador independiente.',
              icon: Icons.local_car_wash,
              onTap: () async {
                await _saveUserRole(UserRole.EMPLEADO);
                if (context.mounted) {
                  context.go('/onboarding-employee');
                }
              },
            ),
            const SizedBox(height: 16),
            _RoleCard(
              title: 'Administrador',
              description:
                  'Soy dueño de un autolavado y quiero gestionar mi negocio.',
              icon: Icons.storefront,
              onTap: () async {
                await _saveUserRole(UserRole.ADMINISTRADOR);
                if (context.mounted) {
                  context.go('/create-laundry');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
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
      } catch (e) {
        debugPrint('Error al cerrar sesión: $e');
      }
    }
  }

  Future<void> _saveUserRole(UserRole role) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      try {
        final AuthRepository authRepository = FirebaseAuthRepository();
        // Fetch existing roles to append instead of replacing
        final existingUser = await authRepository.getCurrentUser();
        List<UserRole> existingRoles = [];
        if (existingUser != null) {
          existingRoles = existingUser.roles;
        }

        if (!existingRoles.contains(role)) {
          existingRoles.add(role);
        }

        // Si elige Empleado o Administrador, automáticamente se le asigna también el rol de Cliente
        if (role == UserRole.EMPLEADO || role == UserRole.ADMINISTRADOR) {
          if (!existingRoles.contains(UserRole.CLIENTE)) {
            existingRoles.add(UserRole.CLIENTE);
          }
        }

        await authRepository.upsertUser(
          email: user.email!,
          nombreCompleto: user.displayName ?? 'Usuario',
          roles: existingRoles,
        );
            
        // Automatically set it as active session role
        SessionManager.activeRole = role;
      } catch (e) {
        debugPrint('Error guardando rol de usuario: $e');
      }
    }
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC3C6D6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF1FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF0056D2), size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF151C27),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF424654),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF737785)),
          ],
        ),
      ),
    );
  }
}
