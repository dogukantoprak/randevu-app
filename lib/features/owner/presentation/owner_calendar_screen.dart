import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../customer/data/appointment_repository.dart';
import '../../customer/domain/appointment_model.dart';

class OwnerCalendarScreen extends ConsumerWidget {
  const OwnerCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(myAppointmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
           // Date chips (visual only for now)
           Padding(
             padding: const EdgeInsets.all(20),
             child: SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  final now = DateTime.now();
                  final date = now.add(Duration(days: index));
                  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  final dayName = days[date.weekday - 1]; // 1-7, mapped to 0-6 array? No, simpler
                  
                  // Simple mapping
                  // weekday 1=Mon, 7=Sun
                  
                  final isSelected = index == 0; // Today selected
                  
                  return Container(
                    width: 56,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.primaryGradient : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primaryStart.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                              ),
                            ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayName, // Just simple day name
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white.withOpacity(0.8) : const Color(0xFF6B6B8D),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : const Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
           ),
          
          Expanded(
            child: appointmentsAsync.when(
              data: (appointments) {
                if (appointments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.event_busy_rounded, size: 40, color: Colors.grey.shade400),
                        ),
                        const SizedBox(height: 16),
                        Text('No bookings found', style: TextStyle(color: Colors.grey.shade500)),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final apt = appointments[index];
                    return _OwnerAppointmentCard(appointment: apt);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerAppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  const _OwnerAppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
             width: 4, height: 40,
             decoration: BoxDecoration(
               color: appointment.status == 'cancelled' ? Colors.red : AppColors.primaryStart,
               borderRadius: BorderRadius.circular(2),
             ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.serviceName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  _formatDate(appointment.dateTime),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${appointment.price.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                appointment.status,
                style: TextStyle(
                  fontSize: 12, 
                  color: appointment.status == 'cancelled' ? Colors.red : Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${_monthName(date.month)} • $hour:$minute';
  }
  
  String _monthName(int month) => 
      ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][month-1];
}
