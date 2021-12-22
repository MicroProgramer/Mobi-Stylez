import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class PushNotification {
  String notification_id, sender_id, receiver_id, text;
  bool read;
  int timestamp;

  PushNotification({
    required this.notification_id,
    required this.sender_id,
    required this.receiver_id,
    required this.text,
    required this.read,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'notification_id': this.notification_id,
      'sender_id': this.sender_id,
      'receiver_id': this.receiver_id,
      'text': this.text,
      'read': this.read,
      'timestamp': this.timestamp,
    };
  }

  factory PushNotification.fromMap(Map<String, dynamic> map) {
    return PushNotification(
      notification_id: map['notification_id'] as String,
      sender_id: map['sender_id'] as String,
      receiver_id: map['receiver_id'] as String,
      text: map['text'] as String,
      read: map['read'] as bool,
      timestamp: map['timestamp'] as int,
    );
  }
}
