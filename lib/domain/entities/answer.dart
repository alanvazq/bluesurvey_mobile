class Answer {
  final String id;
  final String answer;
  final int count;

  Answer({required this.id, required this.answer, required this.count});

  Answer copyWith({String? id, String? answer, int? count}) {
    return Answer(
      id: id ?? this.id,
      answer: answer ?? this.answer,
      count: count ?? this.count,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Answer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          answer == other.answer &&
          count == other.count;

  @override
  int get hashCode => id.hashCode ^ answer.hashCode ^ count.hashCode;
}
