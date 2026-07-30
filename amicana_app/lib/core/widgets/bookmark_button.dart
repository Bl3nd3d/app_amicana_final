import 'package:flutter/material.dart';
import 'package:amicana_app/core/services/bookmark_service.dart';

enum BookmarkKind { book, chapter, quiz }

/// Botón de "guardar" reutilizable para libros, capítulos y trivias.
/// Escucha el documento del usuario en tiempo real para mostrar el
/// ícono lleno/vacío según corresponda.
///
/// Usar el constructor con nombre que corresponda:
/// BookmarkButton.book(...), BookmarkButton.chapter(...) o
/// BookmarkButton.quiz(...).
class BookmarkButton extends StatefulWidget {
  final String userId;
  final BookmarkKind kind;
  final String bookId;
  final String? chapterId;
  final String? quizId;

  const BookmarkButton._({
    super.key,
    required this.userId,
    required this.kind,
    this.bookId = '',
    this.chapterId,
    this.quizId,
  });

  factory BookmarkButton.book({
    Key? key,
    required String userId,
    required String bookId,
  }) {
    return BookmarkButton._(
        key: key, userId: userId, kind: BookmarkKind.book, bookId: bookId);
  }

  factory BookmarkButton.chapter({
    Key? key,
    required String userId,
    required String bookId,
    required String chapterId,
  }) {
    return BookmarkButton._(
        key: key,
        userId: userId,
        kind: BookmarkKind.chapter,
        bookId: bookId,
        chapterId: chapterId);
  }

  factory BookmarkButton.quiz({
    Key? key,
    required String userId,
    required String quizId,
  }) {
    return BookmarkButton._(
        key: key, userId: userId, kind: BookmarkKind.quiz, quizId: quizId);
  }

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  final _service = BookmarkService();
  bool _submitting = false;

  bool _isSaved(Map<String, dynamic>? data) {
    switch (widget.kind) {
      case BookmarkKind.chapter:
        final saved = List<String>.from(data?['savedChapterIds'] ?? []);
        return saved.contains(
            BookmarkService.chapterCompositeId(widget.bookId, widget.chapterId!));
      case BookmarkKind.quiz:
        final saved = List<String>.from(data?['savedQuizIds'] ?? []);
        return saved.contains(widget.quizId);
      case BookmarkKind.book:
        final saved = List<String>.from(data?['savedBookIds'] ?? []);
        return saved.contains(widget.bookId);
    }
  }

  Future<void> _toggle(bool currentlySaved) async {
    setState(() => _submitting = true);
    try {
      switch (widget.kind) {
        case BookmarkKind.chapter:
          await _service.setChapterSaved(
              widget.userId, widget.bookId, widget.chapterId!, !currentlySaved);
        case BookmarkKind.quiz:
          await _service.setQuizSaved(
              widget.userId, widget.quizId!, !currentlySaved);
        case BookmarkKind.book:
          await _service.setBookSaved(
              widget.userId, widget.bookId, !currentlySaved);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo actualizar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: _service.watchUser(widget.userId).map((doc) => doc.data()),
      builder: (context, snapshot) {
        final isSaved = _isSaved(snapshot.data);
        return IconButton(
          tooltip: isSaved ? 'Quitar de guardados' : 'Guardar',
          icon: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: isSaved ? Colors.amber : Colors.white,
          ),
          onPressed: _submitting ? null : () => _toggle(isSaved),
        );
      },
    );
  }
}
