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

  Future<void> saveProgress(String category, String chapterId) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      // Don't save progress if there's no user logged in.
      throw Exception("User not logged in. Cannot save progress.");
    }

    final userDocRef = _firestore.collection('users').doc(user.uid);

    // Using .set with merge:true will create the document if it doesn't exist,
    // and update it if it does. This handles the "lazy creation" case.
    return userDocRef.set({
      'completedChapters': FieldValue.arrayUnion([chapterId]),
      'stats': {
        category: FieldValue.increment(1),
      },
      // Also save user email to have it in the doc as per the schema example
      'email': user.email,
    }, SetOptions(merge: true));
  }
}
