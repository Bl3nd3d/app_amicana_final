import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amicana_app/features/library/models/book_model.dart';
import 'package:amicana_app/core/models/chapter_model.dart';
import 'package:amicana_app/core/data/seed_data.dart';

class LibraryService {
  final _db = FirebaseFirestore.instance;

  Future<List<Book>> getBooks() async {
    try {
      final snapshot = await _db.collection('books').get();

      final books = await Future.wait(snapshot.docs.map((doc) async {
        final chaptersSnapshot =
            await doc.reference.collection('chapters').orderBy('title').get();
        final chapters = chaptersSnapshot.docs.map((chapterDoc) {
          final data = chapterDoc.data();
          return Chapter(
            id: chapterDoc.id,
            title: data['title'] ?? '',
            pageCount: data['pageCount'] ?? 0,
            synopsis: data['synopsis'] ?? '',
            audioUrl: data['audioUrl'],
            pdfUrl: data['pdfUrl'],
          );
        }).toList();

        final data = doc.data();
        return Book(
          id: doc.id,
          author: data['author'] ?? '',
          coverUrl: data['coverUrl'] ?? '',
          description: data['description'] ?? '',
          title: data['title'] ?? '',
          chapters: chapters,
        );
      }).toList());

      return books;
    } catch (e) {
      print('Error al obtener los libros: $e');
      throw Exception('No se pudieron cargar los libros desde Firestore.');
    }
  }

  Future<Book> getBookById(String bookId) async {
    try {
      final doc = await _db.collection('books').doc(bookId).get();
      if (!doc.exists) {
        throw Exception('El libro no fue encontrado.');
      }

      final chaptersSnapshot =
          await doc.reference.collection('chapters').orderBy('title').get();
      final chapters = chaptersSnapshot.docs.map((chapterDoc) {
        final data = chapterDoc.data();
        return Chapter(
            id: chapterDoc.id,
            title: data['title'] ?? '',
            pageCount: data['pageCount'] ?? 0,
            synopsis: data['synopsis'] ?? '',
            audioUrl: data['audioUrl'],
            pdfUrl: data['pdfUrl']);
      }).toList();

      final data = doc.data()!;
      return Book(
          id: doc.id,
          author: data['author'] ?? '',
          coverUrl: data['coverUrl'] ?? '',
          description: data['description'] ?? '',
          title: data['title'] ?? '',
          chapters: chapters);
    } catch (e) {
      print('Error al obtener el libro por ID: $e');
      throw Exception('No se pudo cargar el libro.');
    }
  }

  Future<void> seedDatabase() async {
    print('Iniciando proceso de sembrado de la base de datos...');

    final bookCollectionRef = _db.collection('books');
    var snapshot = await bookCollectionRef.get();
    for (var doc in snapshot.docs) {
      var chaptersSnapshot = await doc.reference.collection('chapters').get();
      for (var chapterDoc in chaptersSnapshot.docs) {
        await chapterDoc.reference.delete();
      }
      await doc.reference.delete();
    }
    print('Datos antiguos eliminados.');

    print('Iniciando carga de nuevos datos...');
    for (final bookData in seedBooksData) {
      final bookDataForFirestore = Map<String, dynamic>.from(bookData);
      final chaptersData =
          bookDataForFirestore.remove('chapters') as List<Map<String, dynamic>>;

      await bookCollectionRef
          .doc(bookDataForFirestore['id'])
          .set(bookDataForFirestore);

      final chapterCollectionRef = bookCollectionRef
          .doc(bookDataForFirestore['id'])
          .collection('chapters');
      for (final chapterData in chaptersData) {
        final chapterDataForFirestore = Map<String, dynamic>.from(chapterData);
        await chapterCollectionRef
            .doc(chapterDataForFirestore['id'])
            .set(chapterDataForFirestore);
      }
    }
    print('¡Carga de datos de libros completa!');
  }
}
