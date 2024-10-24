import 'package:uuid/uuid.dart';

class MemoModel {
  final String id;
  final String title;
  final String memo;
  final DateTime createdAt;

  MemoModel({
    String? id,
    required this.title,
    required this.memo,
    DateTime? createdAt,
  })  : id = id ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  factory MemoModel.fromJson(Map<String, dynamic> json) {
    return MemoModel(
      id: json['id'],
      title: json['title'],
      memo: json['memo'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'memo': memo,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
