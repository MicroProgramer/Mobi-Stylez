import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  int comment_id;
  String user_id;
  int timestamp;
  String text;
  bool isBarber;

  Comment({
    required this.comment_id,
    required this.user_id,
    required this.timestamp,
    required this.text,
    required this.isBarber,
  });

  Map<String, dynamic> toMap() {
    return {
      'comment_id': this.comment_id,
      'user_id': this.user_id,
      'timestamp': this.timestamp,
      'text': this.text,
      'isBarber': this.isBarber,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      comment_id: map['comment_id'] as int,
      user_id: map['user_id'] as String,
      timestamp: map['timestamp'] as int,
      text: map['text'] as String,
      isBarber: map['isBarber'] as bool,
    );
  }
}
