class Todo {
  final String id;
  final String text;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  Todo copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
