import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amicana_app/core/data/seed_data.dart'; // Assuming this path is correct

class DatabaseSeeder {
  static Future<void> uploadSeedData() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final WriteBatch batch = db.batch();

    for (var bookData in seedBooksData) {
      // Create a mutable copy of the book map
      Map<String, dynamic> bookMap = Map.from(bookData);

      // Extract chapters and remove from the main book document
      List chapters = bookMap.remove('chapters') ?? [];

      // Prepare the book write operation
      batch.set(db.collection('books').doc(bookMap['id']), bookMap,
          SetOptions(merge: true));

      // Iterate over chapters and prepare their write operations in a subcollection
      for (var chapter in chapters) {
        batch.set(
            db
                .collection('books')
                .doc(bookMap['id'])
                .collection('chapters')
                .doc(chapter['id']),
            chapter,
            SetOptions(merge: true));
      }
    }

    // Commit the batch
    await batch.commit();
  }
}
