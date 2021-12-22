class CustomerSupportTicket{
  String user_id, complaint;
  int timestamp;

  CustomerSupportTicket({
    required this.user_id,
    required this.complaint,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': this.user_id,
      'complaint': this.complaint,
      'timestamp': this.timestamp,
    };
  }

  factory CustomerSupportTicket.fromMap(Map<String, dynamic> map) {
    return CustomerSupportTicket(
      user_id: map['user_id'] as String,
      complaint: map['complaint'] as String,
      timestamp: map['timestamp'] as int,
    );
  }
}