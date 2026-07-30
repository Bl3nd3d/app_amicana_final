import 'package:amicana_app/core/models/chapter_model.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final String description;
  final List<String> categories;
  final List<Chapter> chapters;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.description,
    this.categories = const [],
    required this.chapters,
  });
}
