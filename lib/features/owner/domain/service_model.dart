import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String id;
  final String ownerId;
  final String name;
  final int durationMinutes;
  final double price;
  final int iconCode; // Store IconData.codePoint
  final DateTime createdAt;

  ServiceModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.durationMinutes,
    required this.price,
    required this.iconCode,
    required this.createdAt,
  });

  factory ServiceModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceModel(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      durationMinutes: data['durationMinutes'] ?? 30,
      price: (data['price'] ?? 0).toDouble(),
      iconCode: data['iconCode'] ?? 0xe198, // Default to a standard icon if missing
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'durationMinutes': durationMinutes,
      'price': price,
      'iconCode': iconCode,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String get durationFormatted => '$durationMinutes min';
  String get priceFormatted => '\$${price.toStringAsFixed(0)}';
}
