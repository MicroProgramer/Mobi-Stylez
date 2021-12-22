

class Appointment {
  String id,
      user_id,
      barber_id,
      name,
      email,
      contact,
      country,
      state,
      city,
      address;
  int timestamp;
  double drop_lat, drop_lng;
  bool paid, completed;
  String paid_card_id;
  double rating, paid_amount;
  String slot_id, service_id;

  Appointment({
    required this.id,
    required this.user_id,
    required this.barber_id,
    required this.name,
    required this.email,
    required this.contact,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
    required this.timestamp,
    required this.drop_lat,
    required this.drop_lng,
    required this.paid,
    required this.completed,
    required this.paid_card_id,
    required this.rating,
    required this.paid_amount,
    required this.slot_id,
    required this.service_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'user_id': this.user_id,
      'barber_id': this.barber_id,
      'name': this.name,
      'email': this.email,
      'contact': this.contact,
      'country': this.country,
      'state': this.state,
      'city': this.city,
      'address': this.address,
      'timestamp': this.timestamp,
      'drop_lat': this.drop_lat,
      'drop_lng': this.drop_lng,
      'paid': this.paid,
      'completed': this.completed,
      'paid_card_id': this.paid_card_id,
      'rating': this.rating,
      'paid_amount': this.paid_amount,
      'slot_id': this.slot_id,
      'service_id': this.service_id,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] as String,
      user_id: map['user_id'] as String,
      barber_id: map['barber_id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      contact: map['contact'] as String,
      country: map['country'] as String,
      state: map['state'] as String,
      city: map['city'] as String,
      address: map['address'] as String,
      timestamp: map['timestamp'] as int,
      drop_lat: map['drop_lat'] as double,
      drop_lng: map['drop_lng'] as double,
      paid: map['paid'] as bool,
      completed: map['completed'] as bool,
      paid_card_id: map['paid_card_id'] as String,
      rating: map['rating'] as double,
      paid_amount: map['paid_amount'] as double,
      slot_id: map['slot_id'] as String,
      service_id: map['service_id'] as String,
    );
  }
}
