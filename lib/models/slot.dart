

class Slot {
  String slot_id, barber_id, user_id, service_id;
  int timestamp;
  bool available;

  Slot({
    required this.slot_id,
    required this.barber_id,
    required this.user_id,
    required this.service_id,
    required this.timestamp,
    required this.available,
  });

  Map<String, dynamic> toMap() {
    return {
      'slot_id': this.slot_id,
      'barber_id': this.barber_id,
      'user_id': this.user_id,
      'service_id': this.service_id,
      'timestamp': this.timestamp,
      'available': this.available,
    };
  }

  factory Slot.fromMap(Map<String, dynamic> map) {
    return Slot(
      slot_id: map['slot_id'] as String,
      barber_id: map['barber_id'] as String,
      user_id: map['user_id'] as String,
      service_id: map['service_id'] as String,
      timestamp: map['timestamp'] as int,
      available: map['available'] as bool,
    );
  }
}
