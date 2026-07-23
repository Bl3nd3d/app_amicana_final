class Progress {
  final double readingPercentage;
  final double speakerPercentage;
  final double writingPercentage;
  // TODO: Replace with a real ranked list
  final List<Map<String, dynamic>> rankedList;

  Progress({
    required this.readingPercentage,
    required this.speakerPercentage,
    required this.writingPercentage,
    required this.rankedList,
  });
}
