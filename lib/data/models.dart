class NotesModel {
  int? id;
  String title;
  String content;
  DateTime date;
  bool isImportant;

  NotesModel({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.isImportant,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'isImportant': isImportant ? 1 : 0,
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['_id'] as int?,
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      date: DateTime.parse(map['date'] as String),
      isImportant: (map['isImportant'] as int?) == 1,
    );
  }

  NotesModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? date,
    bool? isImportant,
  }) {
    return NotesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      isImportant: isImportant ?? this.isImportant,
    );
  }
}
