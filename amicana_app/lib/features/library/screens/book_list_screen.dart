import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amicana_app/features/library/bloc/library_bloc.dart';
import 'package:amicana_app/features/library/widgets/book_card.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LibraryBloc()..add(FetchBooks()),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A183C),
        appBar: AppBar(
          title: const Text('Biblioteca'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/images/fondo_app.png',
                    fit: BoxFit.cover),
              ),
            ),
            BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                if (state is LibraryLoading || state is LibraryInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LibraryLoaded) {
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
                          style: TextStyle(color: Colors.white)));
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
