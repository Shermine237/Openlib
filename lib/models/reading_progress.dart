class ReadingProgress {
  final String id;
  final String userId;
  final String bookId;
  final double progress;
  final DateTime? completedAt;
  final DateTime updatedAt;

  ReadingProgress({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.progress,
    this.completedAt,
    required this.updatedAt,
  });

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      id: json['id'],
      userId: json['userId'],
      bookId: json['bookId'],
      progress: json['progress'].toDouble(),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'progress': progress,
      'completedAt': completedAt?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
