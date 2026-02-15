import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String serviceId;
  final String customerId;
  final String ownerId;
  final DateTime dateTime;
  final String status; // 'pending', 'confirmed', 'cancelled'
  final String serviceName;
  final double price;
  final DateTime createdAt;

  AppointmentModel({
    required this.id,
    required this.serviceId,
    required this.customerId,
    required this.ownerId,
    required this.dateTime,
    required this.status,
    required this.serviceName,
    required this.price,
    required this.createdAt,
  });

  factory AppointmentModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      id: doc.id,
      serviceId: data['serviceId'] ?? '',
      customerId: data['customerId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      dateTime: (data['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'pending',
      serviceName: data['serviceName'] ?? 'Unknown Service',
      price: (data['price'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'customerId': customerId,
      'ownerId': ownerId,
      'dateTime': Timestamp.fromDate(dateTime),
      'status': status,
      'serviceName': serviceName,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
