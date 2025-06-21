import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/library/models/book_model.dart';

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // --- ESTA ES LA NAVEGACIÓN CORREGIDA Y ROBUSTA ---
        // Usamos PUSH y la nueva ruta anidada que definimos en el router.
        // La pantalla de detalle recibirá el ID y buscará los datos por su cuenta.
        context.push('/books/${book.id}');
      },
      child: Card(
        elevation: 4,
        clipBehavior: Clip
            .antiAlias, // Asegura que la imagen no se salga de los bordes redondeados
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'book-cover-${book.id}', // Tag para la animación
                child: Image.network(
                  book.coverUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  // Muestra un indicador de carga mientras la imagen se descarga
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  // Muestra un icono de error si la imagen no se puede cargar
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.book, size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
