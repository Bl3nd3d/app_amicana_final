import 'package:cloud_firestore/cloud_firestore.dart';

/// Maneja el guardado ("bookmarks") de libros, capítulos y trivias,
/// sincronizado en el documento del usuario en Firestore (colección 'users').
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

  /// Operación genérica: agrega o quita [itemId] del array [field] en el
  /// documento del usuario. Los métodos de abajo son atajos con nombre
  /// para cada tipo de contenido guardable.
  Future<void> setSaved(
      String userId, String field, String itemId, bool saved) {
    return _db.collection('users').doc(userId).update({
      field: saved
          ? FieldValue.arrayUnion([itemId])
          : FieldValue.arrayRemove([itemId]),
    });
  }

  Future<void> setBookSaved(String userId, String bookId, bool saved) =>
      setSaved(userId, 'savedBookIds', bookId, saved);

  Future<void> setChapterSaved(
          String userId, String bookId, String chapterId, bool saved) =>
      setSaved(userId, 'savedChapterIds',
          chapterCompositeId(bookId, chapterId), saved);

  Future<void> setQuizSaved(String userId, String quizId, bool saved) =>
      setSaved(userId, 'savedQuizIds', quizId, saved);
}
