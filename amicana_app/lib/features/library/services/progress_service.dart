import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:amicana_app/core/data/seed_data.dart';
import 'package:amicana_app/core/models/progress_model.dart';
import 'package:amicana_app/core/models/user_model.dart';

class ProgressService {
  final firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;

  // This is a mock. In a real app, you'd fetch this from a persistent store.
  User _currentUser = User(
    id: '',
    name: '',
    email: '',
    roles: [],
    completedChapterIds: [],
  );

  ProgressService() {
    // In a real app, you would observe user changes.
    // For this example, we'll just get the current user once.
    final fbUser = _firebaseAuth.currentUser;
    if (fbUser != null) {
      // This is a simplification. You'd likely have a user service
      // to get your app-specific User object.
      final name = fbUser.displayName ?? fbUser.email!.split('@').first;
      final capitalizedName =
          name.substring(0, 1).toUpperCase() + name.substring(1);
      _currentUser = User(
        id: fbUser.uid,
        name: capitalizedName,
        email: fbUser.email!,
        roles: ['usuario_normal'],
        // This is the crucial part. We don't have a way to get the
        // completedChapterIds from firebase auth directly.
        // This should be fetched from your database (e.g., Firestore).
        // For now, we'll use a mock value.
        completedChapterIds: ['tsl-capitulo-1'],
      );
    }
  }

  Future<Progress> getProgress() async {
    // 1. Get total number of chapters
    int totalChapters = 0;
    for (var book in seedBooksData) {
      if (book['chapters'] is List) {
        totalChapters += (book['chapters'] as List).length;
      }
    }

    // 2. Get completed chapters for the current user
    final completedChapters = _currentUser.completedChapterIds.length;

    // 3. Calculate percentages
    double readingPercentage =
        totalChapters > 0 ? completedChapters / totalChapters : 0.0;

    // Mock data for other stats
    double speakerPercentage = readingPercentage * 0.8; // Example logic
    double writingPercentage = readingPercentage * 0.3; // Example logic

    // Mock ranked list
    var rankedList = [
      {'rank': 4, 'title': 'Copywriting', 'icon': 'image_outlined'},
      {
        'rank': 5,
        'title': 'Questions',
        'icon': 'youtube_searched_for_outlined'
      },
      {'rank': 5, 'title': 'Community Post', 'icon': 'groups_outlined'},
      {
        'rank': 6,
        'title': 'Public Speaking',
        'icon': 'campaign_outlined'
      },
    ];

    return Progress(
      readingPercentage: readingPercentage,
      speakerPercentage: speakerPercentage,
      writingPercentage: writingPercentage,
      rankedList: rankedList,
    );
  }
}
