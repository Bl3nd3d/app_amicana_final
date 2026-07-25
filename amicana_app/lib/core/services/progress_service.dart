import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amicana_app/core/models/progress_model.dart';

class ProgressService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Progress> watchUserProgress() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      // If no user is logged in, return a stream with a single event of an empty Progress object.
      return Stream.value(Progress());
    }

    final userDocRef = _firestore.collection('users').doc(user.uid);

    return userDocRef.snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return Progress.fromFirestore(snapshot.data()!);
      } else {
        // If the document doesn't exist, return empty progress.
        return Progress();
      }
    });
  }

  Future<void> saveQuizResolution(
      {required String quizId,
      required int score,
      required String category}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception("User not logged in. Cannot save resolution.");
    }

    final batch = _firestore.batch();

    final userRef = _firestore.collection('users').doc(user.uid);
    final resolutionRef = userRef.collection('resolutions').doc();

    // 1. Guardar el detalle de la resolución
    batch.set(resolutionRef, {
      'quizId': quizId,
      'scoreObtained': score,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 2. Actualizar el consolidado dinámicamente
    // Esto asume que el documento del usuario ya existe.
    // Si no, la transacción fallará, lo cual es seguro.
    batch.update(userRef, {
      'globalScore': FieldValue.increment(score),
      'categoryStats.$category': FieldValue.increment(score),
      'completedQuizzes': FieldValue.arrayUnion([quizId]),
    });

    await batch.commit(); // Se ejecuta todo o nada
  }
}
