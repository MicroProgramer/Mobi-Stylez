import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class Like {
  String user_id;

  Like({
    required this.user_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': this.user_id,
    };
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      user_id: map['user_id'] as String,
    );
  }
}
