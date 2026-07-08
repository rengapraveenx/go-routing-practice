import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// Profile page — demonstrates sub-routes and query params.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            // Navigate to sub-route with query param
            onPressed: () => context.go('${AppRoutes.settings}?tab=general'),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Avatar
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.gradientStart, AppColors.gradientEnd],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          (user?.name.isNotEmpty == true
                                  ? user!.name[0]
                                  : 'U')
                              .toUpperCase(),
                          style: AppTextStyles.displayLarge
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(user?.name ?? 'User', style: AppTextStyles.headlineLarge),
                    const SizedBox(height: 4),
                    Text(user?.email ?? '', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Menu items
              _ProfileMenuItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                subtitle: 'Sub-route + query param demo',
                onTap: () => context.go('${AppRoutes.settings}?tab=general'),
              ),
              _ProfileMenuItem(
                icon: Icons.info_outline_rounded,
                label: 'Settings (notifications tab)',
                subtitle: '?tab=notifications',
                onTap: () =>
                    context.go('${AppRoutes.settings}?tab=notifications'),
              ),
              const SizedBox(height: 24),

              // Logout
              OutlinedButton.icon(
                onPressed: () =>
                    context.read<AuthBloc>().add(const AuthLogoutRequested()),
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                label: const Text('Logout',
                    style: TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: AppTextStyles.bodyLarge),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
