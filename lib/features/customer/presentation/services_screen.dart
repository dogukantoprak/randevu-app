import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/appointment_model.dart';
import '../data/appointment_repository.dart';
import '../../owner/data/service_repository.dart';
import '../../owner/domain/service_model.dart';
import '../../auth/application/auth_controller.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryStart.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.search_rounded, color: AppColors.primaryStart),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: servicesAsync.when(
        data: (services) {
           if (services.isEmpty) {
             return Center(
               child: Text(
                 'No services available yet',
                 style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
               ),
             );
           }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _ServiceItem(service: service, index: index);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _ServiceItem extends ConsumerWidget {
  final ServiceModel service;
  final int index;

  const _ServiceItem({required this.service, required this.index});

  Color _getServiceColor(int index) {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFF3F8CFF),
      const Color(0xFFFF6584),
      const Color(0xFF00C9A7),
      const Color(0xFFFFB347),
      const Color(0xFF6C63FF), // repeat
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _getServiceColor(index);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  IconData(service.iconCode, fontFamily: 'MaterialIcons'),
                  color: color, 
                  size: 28
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
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded,
                            size: 14, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(
                          service.durationFormatted,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          service.priceFormatted,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _showBookingDialog(context, ref, service);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Text(
                        'Book',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showBookingDialog(BuildContext context, WidgetRef ref, ServiceModel service) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    
    if (date != null && context.mounted) {
       final time = await showTimePicker(
         context: context,
         initialTime: const TimeOfDay(hour: 10, minute: 0),
       );
       
       if (time != null && context.mounted) {
         final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
         final user = ref.read(authControllerProvider).userProfile;
         
         if (user == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login to book')));
            return;
         }
         
         final appointment = AppointmentModel(
           id: FirebaseFirestore.instance.collection('appointments').doc().id,
           serviceId: service.id,
           customerId: user.uid,
           ownerId: service.ownerId,
           dateTime: dateTime,
           status: 'pending',
           serviceName: service.name,
           price: service.price,
           createdAt: DateTime.now(),
         );
         
         await ref.read(appointmentRepositoryProvider).createAppointment(appointment);
         
         if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Booking request sent for ${service.name}!'),
                backgroundColor: AppColors.success,
              )
            );
         }
       }
    }
  }
}
