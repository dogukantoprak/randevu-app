import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
             margin: const EdgeInsets.only(bottom: 16),
             child: ListTile(
               leading: CircleAvatar(
                 backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                 child: Icon(Icons.cut, color: Theme.of(context).primaryColor),
               ),
               title: Text('Service ${index + 1}'),
               subtitle: const Text('Duration: 30 min • Price: \$20'),
               trailing: ElevatedButton(
                 onPressed: () {},
                 child: const Text('Book'),
               ),
             ),
          );
        },
      ),
    );
  }
}
