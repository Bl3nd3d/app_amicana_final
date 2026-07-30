import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amicana_app/core/models/progress_model.dart';
import 'package:amicana_app/core/models/quiz_resolution_model.dart';

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

  Future<void> updateChapterProgress(String chapterId, bool isCompleted) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception("User not logged in. Cannot update chapter progress.");
    }
    final userDocRef = _firestore.collection('users').doc(user.uid);

    if (isCompleted) {
      await userDocRef.update({
        'completedChapterIds': FieldValue.arrayUnion([chapterId])
      });
    } else {
      await userDocRef.update({
        'completedChapterIds': FieldValue.arrayRemove([chapterId])
      });
    }
  }

  Future<void> saveQuizResolution({
    required String quizId,
    required String quizTitle,
    required int score,
    required int totalQuestions,
    required String category,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception("User not logged in. Cannot save resolution.");
    }

    final batch = _firestore.batch();

    final userRef = _firestore.collection('users').doc(user.uid);
    final resolutionRef = userRef.collection('resolutions').doc();

    // 1. Guardar el detalle de la resolución (con título y total de
    // preguntas desnormalizados, para poder mostrar el historial sin
    // tener que volver a buscar la trivia original).
    batch.set(resolutionRef, {
      'quizId': quizId,
      'quizTitle': quizTitle,
      'category': category,
      'scoreObtained': score,
      'totalQuestions': totalQuestions,
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

  /// Devuelve el historial de trivias resueltas, más recientes primero.
  /// Pasar [limit] para traer solo las últimas N (ej. en la pantalla de
  /// Progreso); dejarlo en null trae todo el historial (ej. para calcular
  /// un promedio general en el Perfil).
  Stream<List<QuizResolution>> watchQuizResolutions({int? limit}) {
    final user = _firebaseAuth.currentUser;
    if (user == null) return Stream.value(const []);

    Query<Map<String, dynamic>> query = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('resolutions')
        .orderBy('timestamp', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map(
        (snap) => snap.docs.map((d) => QuizResolution.fromFirestore(d)).toList());
  }
}
