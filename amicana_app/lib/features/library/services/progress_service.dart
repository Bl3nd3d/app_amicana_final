import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:amicana_app/core/data/seed_data.dart';
import 'package:amicana_app/core/models/progress_model.dart';
import 'package:amicana_app/core/models/user_model.dart' as app_user;

class ProgressService {
  final firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Progress> getProgress() async {
    final fbUser = _firebaseAuth.currentUser;
    if (fbUser == null) {
      throw Exception('User not logged in');
    }

    // Fetch user data from Firestore
    final userDoc = await _firestore.collection('users').doc(fbUser.uid).get();
    
    app_user.User currentUser;
    if (userDoc.exists) {
      currentUser = app_user.User.fromFirestore(userDoc);
    } else {
      // Fallback if user document doesn't exist for some reason
      final name = fbUser.displayName ?? fbUser.email!.split('@').first;
      final capitalizedName = name.substring(0, 1).toUpperCase() + name.substring(1);
      currentUser = app_user.User(
        id: fbUser.uid,
        name: capitalizedName,
        email: fbUser.email!,
        roles: ['usuario_normal'],
        completedChapterIds: [], // Default to empty
      );
    }
    
    // 1. Get total number of chapters
    int totalChapters = 0;
    for (var book in seedBooksData) {
      if (book['chapters'] is List) {
        totalChapters += (book['chapters'] as List).length;
      }
    }

    // 2. Get completed chapters for the current user
    final completedChapters = currentUser.completedChapterIds.length;

    return Progress(
      totalCompletedChapters: completedChapters,
      categoryStats: {}, // This service doesn't calculate category-specific stats
    );
  }
}
