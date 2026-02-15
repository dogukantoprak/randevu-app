import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_profile.dart';
import '../domain/user_role.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    firebase_auth.FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
});

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._firebaseAuth, this._firestore);

  Stream<firebase_auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    // Role will be set *after* signup in a separate step or via a trigger,
    // but for client-side simplicity, we can create the profile here.
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Create initial profile with default role (Customer)
    if (credential.user != null) {
      final userProfile = UserProfile(
        uid: credential.user!.uid,
        email: email,
        role: UserRole.customer, // Default, can be changed later
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(credential.user!.uid).set(userProfile.toMap());
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
  
  Future<void> updateRole(String uid, UserRole role) async {
    await _firestore.collection('users').doc(uid).update({'role': role.name});
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserProfile.fromDocument(doc);
    }
    return null;
  }
}
