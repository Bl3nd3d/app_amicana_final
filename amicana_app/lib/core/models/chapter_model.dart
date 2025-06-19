class Chapter {
  final String id;
  final String title;
  final int pageCount;
  final String synopsis;
  final String? audioUrl; // Puede ser nulo si no hay audio
  final String? pdfUrl; // Puede ser nulo si no hay PDF

  Chapter({
    required this.id,
    required this.title,
    required this.pageCount,
    required this.synopsis,
    this.audioUrl,
    this.pdfUrl,
  });
}
