import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/library/bloc/library_bloc.dart';
import 'package:amicana_app/features/library/widgets/book_card.dart';

class BookListScreen extends StatelessWidget {
  final String? category;
  const BookListScreen({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final hasCategory = category != null && category!.trim().isNotEmpty;

    return BlocProvider(
      create: (context) => LibraryBloc()
        ..add(hasCategory
            ? FetchBooksByCategory(category: category!)
            : FetchBooks()),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A183C),
        appBar: AppBar(
          title: Text(hasCategory ? category! : 'Biblioteca Digital'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/library'),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/images/fondo_app.webp',
                    fit: BoxFit.cover),
              ),
            ),
            BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                if (state is LibraryLoading || state is LibraryInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LibraryLoaded) {
                  if (state.books.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          hasCategory
                              ? 'Todavía no hay libros en la categoría "$category".'
                              : 'No hay libros disponibles.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: state.books.length,
                    itemBuilder: (context, index) {
                      final book = state.books[index];
                      return BookCard(book: book);
                    },
                  );
                }
                if (state is LibraryError) {
                  return Center(
                      child: Text(state.message,
                          style: const TextStyle(color: Colors.white)));
                }
                return const Center(
                    child: Text('Algo salió mal.',
                        style: TextStyle(color: Colors.white)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
