class MessageDummy{
  String barber_id;
  String last_message;
  int timestamp;

  MessageDummy({
    required this.barber_id,
    required this.last_message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'barber_id': this.barber_id,
      'last_message': this.last_message,
      'timestamp': this.timestamp,
    };
  }

  factory MessageDummy.fromMap(Map<String, dynamic> map) {
    return MessageDummy(
      barber_id: map['barber_id'] as String,
      last_message: map['last_message'] as String,
      timestamp: map['timestamp'] as int,
    );
  }
}