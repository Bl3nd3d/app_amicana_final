import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amicana_app/features/library/bloc/library_bloc.dart';
import 'package:amicana_app/features/library/widgets/book_card.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos el BlocProvider para tener acceso al LibraryBloc
    return BlocProvider(
      create: (context) => LibraryBloc()..add(FetchBooks()),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A183C),
        appBar: AppBar(
          title: const Text('Biblioteca Digital'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          // --- BOTÓN PARA VOLVER A HOME AÑADIDO ---
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
            // El BlocBuilder reacciona a los estados del LibraryBloc
            BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                if (state is LibraryLoading || state is LibraryInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LibraryLoaded) {
                  // Si los libros se cargaron, muestra la cuadrícula
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
                      // Reutilizamos el BookCard que ya teníamos
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
