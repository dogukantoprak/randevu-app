import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_controller.dart';

class OwnerSettingsScreen extends ConsumerWidget {
  const OwnerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Settings')),
      body: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('My Business'),
            accountEmail: Text('owner@business.com'),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.store),
            ),
            decoration: BoxDecoration(color: Colors.indigo), // Or use theme color
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Business Hours'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Staff Management'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
               ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }
}
