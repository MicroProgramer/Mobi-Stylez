
class Message {
  String id;
  int timestamp;
  String sender_id, receiver_id, text;

  Message({
    required this.id,
    required this.timestamp,
    required this.sender_id,
    required this.receiver_id,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'timestamp': this.timestamp,
      'sender_id': this.sender_id,
      'receiver_id': this.receiver_id,
      'text': this.text,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      timestamp: map['timestamp'] as int,
      sender_id: map['sender_id'] as String,
      receiver_id: map['receiver_id'] as String,
      text: map['text'] as String,
    );
  }
}
