import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/appointment_model.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/domain/user_role.dart';

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepository(FirebaseFirestore.instance);
});

class AppointmentRepository {
  final FirebaseFirestore _firestore;

  AppointmentRepository(this._firestore);

  Future<void> createAppointment(AppointmentModel appointment) async {
    await _firestore.collection('appointments').doc(appointment.id).set(appointment.toMap());
  }

  Future<void> cancelAppointment(String appointmentId) async {
    await _firestore.collection('appointments').doc(appointmentId).update({'status': 'cancelled'});
  }

  Stream<List<AppointmentModel>> getAppointmentsForCustomer(String customerId) {
    return _firestore
        .collection('appointments')
        .where('customerId', isEqualTo: customerId)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => AppointmentModel.fromDocument(doc)).toList());
  }

  Stream<List<AppointmentModel>> getAppointmentsForOwner(String ownerId) {
    return _firestore
        .collection('appointments')
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => AppointmentModel.fromDocument(doc)).toList());
  }
}

final myAppointmentsProvider = StreamProvider.autoDispose<List<AppointmentModel>>((ref) {
  final authState = ref.watch(authControllerProvider);
  final repository = ref.watch(appointmentRepositoryProvider);
  
  if (authState.userProfile == null) return const Stream.empty();

  if (authState.userProfile!.role == UserRole.customer) {
    return repository.getAppointmentsForCustomer(authState.userProfile!.uid);
  } else {
    return repository.getAppointmentsForOwner(authState.userProfile!.uid);
  }
});
