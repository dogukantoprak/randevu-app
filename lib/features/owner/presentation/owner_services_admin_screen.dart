import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_theme.dart';
import '../data/service_repository.dart';
import '../domain/service_model.dart';
import '../../auth/application/auth_controller.dart';

class OwnerServicesAdminScreen extends ConsumerWidget {
  const OwnerServicesAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsyncCallback = ref.watch(servicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Services'),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryStart.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const _AddServiceDialog(),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add_rounded, size: 28, color: Colors.white),
        ),
      ),
      body: servicesAsyncCallback.when(
        data: (services) {
          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.spa_outlined, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'No services yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first service',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _ServiceListItem(service: service, index: index);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _ServiceListItem extends ConsumerWidget {
  final ServiceModel service;
  final int index;

  const _ServiceListItem({required this.service, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final color = _getServiceColor(index);

     return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Duration(milliseconds: 400 + (index * 80)),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    IconData(service.iconCode, fontFamily: 'MaterialIcons'),
                    color: color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.schedule_rounded,
                            text: service.durationFormatted,
                          ),
                          const SizedBox(width: 10),
                          _InfoChip(
                            icon: Icons.attach_money_rounded,
                            text: service.priceFormatted,
                            color: color,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Confirm delete
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Service?'),
                        content: Text('Are you sure you want to delete "${service.name}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(serviceRepositoryProvider).deleteService(service.id);
                              Navigator.pop(ctx);
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.delete_outline_rounded, size: 20, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
        ),
      );
  }

   Color _getServiceColor(int index) {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFF3F8CFF),
      const Color(0xFFFF6584),
      const Color(0xFF00C9A7),
      const Color(0xFFFFB347),
    ];
    return colors[index % colors.length];
  }
}


class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _InfoChip({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? Colors.grey).withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? Colors.grey.shade500),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color ?? Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddServiceDialog extends ConsumerStatefulWidget {
  const _AddServiceDialog();

  @override
  ConsumerState<_AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends ConsumerState<_AddServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController(text: '30');
  final _priceController = TextEditingController();
  int _selectedIconCode = 0xe198; // Default icon (spa)

  final Map<String, int> _iconOptions = {
    'Haircut': 0xf06bb, // cut
    'Spa': 0xe5f8,     // spa
    'Face': 0xe263,    // face
    'Color': 0xe40a,   // palette
    'Hand': 0xe934,    // back_hand
    'Star': 0xe0d6,    // auto_awesome
  };

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Service',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Service Name', hintText: 'e.g. Haircut'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Duration (min)', suffixText: 'min'),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Price', prefixText: '\$'),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedIconCode,
                decoration: const InputDecoration(labelText: 'Icon'),
                items: _iconOptions.entries.map((e) {
                  return DropdownMenuItem(
                    value: e.value,
                    child: Row(
                      children: [
                        Icon(IconData(e.value, fontFamily: 'MaterialIcons'), size: 20),
                        const SizedBox(width: 8),
                        Text(e.key),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedIconCode = val); // Just setState to update dropdown
                },
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryStart,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add Service'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(authControllerProvider).userProfile;
      if (user == null) return;

      final id = FirebaseFirestore.instance.collection('services').doc().id;
      final service = ServiceModel(
        id: id,
        ownerId: user.uid,
        name: _nameController.text.trim(),
        durationMinutes: int.tryParse(_durationController.text) ?? 30,
        price: double.tryParse(_priceController.text) ?? 0,
        iconCode: _selectedIconCode,
        createdAt: DateTime.now(),
      );

      ref.read(serviceRepositoryProvider).addService(service);
      Navigator.pop(context);
    }
  }
}
