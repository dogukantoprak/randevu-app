import 'package:flutter/material.dart';

class OwnerCalendarScreen extends StatelessWidget {
  const OwnerCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, size: 64, color: Colors.indigo[200]),
            const SizedBox(height: 16),
            Text(
              'No bookings for today',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Add Booking Manually'),
            )
          ],
        ),
      ),
    );
  }
}
