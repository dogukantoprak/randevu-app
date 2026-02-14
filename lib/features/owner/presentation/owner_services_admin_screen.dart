import 'package:flutter/material.dart';

class OwnerServicesAdminScreen extends StatelessWidget {
  const OwnerServicesAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Services')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
           return Card(
             margin: const EdgeInsets.only(bottom: 12),
             child: ListTile(
               leading: Container(
                 width: 48,
                 height: 48,
                 decoration: BoxDecoration(
                   color: Theme.of(context).colorScheme.primaryContainer,
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: Icon(Icons.cut, color: Theme.of(context).colorScheme.onPrimaryContainer),
               ),
               title: Text('Service ${index + 1}'),
               subtitle: const Text('30 mins • \$25'),
               trailing: IconButton(
                 icon: const Icon(Icons.edit_outlined),
                 onPressed: () {},
               ),
             ),
           );
        },
      ),
    );
  }
}
