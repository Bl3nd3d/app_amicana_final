import 'package:flutter/material.dart';
import 'package:amicana_app/core/services/bookmark_service.dart';

/// Botón de "guardar" reutilizable para usar en el AppBar de un libro
/// o de un capítulo. Escucha el documento del usuario en tiempo real
/// para mostrar el ícono lleno/vacío según corresponda.
class BookmarkButton extends StatefulWidget {
  final String userId;
  final String bookId;
  final String? chapterId; // null = está guardando el libro completo

  const BookmarkButton({
    super.key,
    required this.userId,
    required this.bookId,
    this.chapterId,
  });

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  final _service = BookmarkService();
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: _service.watchUser(widget.userId).map((doc) => doc.data()),
      builder: (context, snapshot) {
        final data = snapshot.data;
        final bool isSaved;
        if (widget.chapterId != null) {
          final saved = List<String>.from(data?['savedChapterIds'] ?? []);
          isSaved = saved.contains(
              BookmarkService.chapterCompositeId(widget.bookId, widget.chapterId!));
        } else {
          final saved = List<String>.from(data?['savedBookIds'] ?? []);
          isSaved = saved.contains(widget.bookId);
        }

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

  Future<void> _toggle(bool currentlySaved) async {
    setState(() => _submitting = true);
    try {
      if (widget.chapterId != null) {
        await _service.setChapterSaved(
            widget.userId, widget.bookId, widget.chapterId!, !currentlySaved);
      } else {
        await _service.setBookSaved(widget.userId, widget.bookId, !currentlySaved);
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
}
