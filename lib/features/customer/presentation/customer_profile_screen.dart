import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../data/appointment_repository.dart';

class CustomerProfileScreen extends ConsumerWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final appointmentsAsync = ref.watch(myAppointmentsProvider);
    final bookingsCount = appointmentsAsync.asData?.value.length ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryStart.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                   Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.person_rounded, size: 44, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authState.userProfile?.email.split('@')[0] ?? 'Customer Name',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authState.userProfile?.email ?? 'customer@email.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats row
            Row(
              children: [
                _StatCard(
                  icon: Icons.calendar_month_rounded,
                  value: '$bookingsCount', // Real data
                  label: 'Bookings',
                  color: AppColors.primaryStart,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  icon: Icons.favorite_rounded,
                  value: '0',
                  label: 'Favorites',
                  color: AppColors.accent,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  icon: Icons.star_rounded,
                  value: '0',
                  label: 'Reviews',
                  color: AppColors.accentAlt,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Settings list
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                   _SettingsTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Profile',
                    color: AppColors.primaryStart,
                    onTap: () {},
                  ),
                  Divider(height: 1, indent: 68, color: Colors.grey.shade100),
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    color: AppColors.accentAlt,
                    onTap: () {},
                  ),
                  Divider(height: 1, indent: 68, color: Colors.grey.shade100),
                  _SettingsTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    color: AppColors.success,
                    onTap: () {},
                  ),
                  Divider(height: 1, indent: 68, color: Colors.grey.shade100),
                  _SettingsTile(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    color: AppColors.accent,
                    onTap: () {
                      ref.read(authControllerProvider.notifier).logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B6B8D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: title == 'Logout' ? color : const Color(0xFF1A1A2E),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Colors.grey.shade300,
      ),
      onTap: onTap,
    );
  }
}
