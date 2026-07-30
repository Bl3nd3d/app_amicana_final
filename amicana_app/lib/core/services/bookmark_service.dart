import 'package:cloud_firestore/cloud_firestore.dart';

/// Maneja el guardado ("bookmarks") de libros y capítulos, sincronizado
/// en el documento del usuario en Firestore (colección 'users').
///
/// Los capítulos guardados se identifican con un id compuesto
/// "bookId::chapterId" ya que un Chapter no tiene referencia a su libro.
class BookmarkService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String chapterCompositeId(String bookId, String chapterId) =>
      '$bookId::$chapterId';

  /// Escucha en tiempo real el documento del usuario, para reflejar
  /// al instante si algo está guardado o no (sin recargar la pantalla).
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUser(String userId) {
    return _db.collection('users').doc(userId).snapshots();
  }

  Future<void> setBookSaved(String userId, String bookId, bool saved) {
    return _db.collection('users').doc(userId).update({
      'savedBookIds': saved
          ? FieldValue.arrayUnion([bookId])
          : FieldValue.arrayRemove([bookId]),
    });
  }

  Future<void> setChapterSaved(
      String userId, String bookId, String chapterId, bool saved) {
    final compositeId = chapterCompositeId(bookId, chapterId);
    return _db.collection('users').doc(userId).update({
      'savedChapterIds': saved
          ? FieldValue.arrayUnion([compositeId])
          : FieldValue.arrayRemove([compositeId]),
    });
  }
}
