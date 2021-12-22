class Barber {
  String barber_id,
      firstName,
      lastName,
      email,
      phone,
      password,
      image_url,
      country_code;
  double latitude, longitude;
  String notification_token;
  double avg_rating;
  bool verified;
  String license_image;
  int lastSeen;

  Barber({
    required this.barber_id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.image_url,
    required this.country_code,
    required this.latitude,
    required this.longitude,
    required this.notification_token,
    required this.avg_rating,
    required this.verified,
    required this.license_image,
    required this.lastSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'barberID': this.barber_id,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'email': this.email,
      'phone': this.phone,
      'password': this.password,
      'image_url': this.image_url,
      'country_code': this.country_code,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'notification_token': this.notification_token,
      'avg_rating': this.avg_rating,
      'verified': this.verified,
      'license_image': this.license_image,
      'lastSeen': this.lastSeen
    };
  }

  factory Barber.fromMap(Map<String, dynamic> map) {
    return Barber(
        barber_id: map['barberID'] as String,
        firstName: map['firstName'] as String,
        lastName: map['lastName'] as String,
        email: map['email'] as String,
        phone: map['phone'] as String,
        password: map['password'] as String,
        image_url: map['image_url'] as String,
        country_code: map['country_code'] as String,
        latitude: double.tryParse("${map['latitude']}") ??
            (map['latitude'] as int).toDouble(),
        longitude: double.tryParse("${map['longitude']}") ??
            (map['longitude'] as int).toDouble(),
        notification_token: map['notification_token'] as String,
        avg_rating: double.tryParse("${map['avg_rating']}") ??
            (map['avg_rating'] as int).toDouble(),
        verified: map['verified'] as bool,
        license_image: map['license_image'] as String,
        lastSeen: (map['lastSeen'] as int),
    );
  }
}
