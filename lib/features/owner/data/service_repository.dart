import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/service_model.dart';
import '../../auth/application/auth_controller.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository(FirebaseFirestore.instance);
});

class ServiceRepository {
  final FirebaseFirestore _firestore;

  ServiceRepository(this._firestore);

  // Add a new service
  Future<void> addService(ServiceModel service) async {
    await _firestore.collection('services').doc(service.id).set(service.toMap());
  }

  // Update a service
  Future<void> updateService(ServiceModel service) async {
    await _firestore.collection('services').doc(service.id).update(service.toMap());
  }

  // Delete a service
  Future<void> deleteService(String serviceId) async {
    await _firestore.collection('services').doc(serviceId).delete();
  }

  // Get services for a specific owner (stream)
  Stream<List<ServiceModel>> getServicesByOwner(String ownerId) {
    return _firestore
        .collection('services')
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ServiceModel.fromDocument(doc)).toList();
    });
  }

  // Get all services (for customers to browse)
  Stream<List<ServiceModel>> getAllServices() {
    return _firestore
        .collection('services')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ServiceModel.fromDocument(doc)).toList();
    });
  }
}

// Controller for managing services
final servicesProvider = StreamProvider.autoDispose<List<ServiceModel>>((ref) {
  final authState = ref.watch(authControllerProvider);
  final repository = ref.watch(serviceRepositoryProvider);
  
  // If owner, return their services. If customer, return all (or filtered).
  if (authState.userProfile?.role.name == 'owner') {
     return repository.getServicesByOwner(authState.userProfile!.uid);
  } else {
     return repository.getAllServices();
  }
});
