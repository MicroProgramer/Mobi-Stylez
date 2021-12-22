class RegisteredUser {
  String user_id,
      firstName,
      lastName,
      email,
      phone,
      password,
      image_url,
      country_code;
  String notification_token;
  int lastSeen;

  RegisteredUser({
    required this.user_id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.image_url,
    required this.country_code,
    required this.notification_token,
    required this.lastSeen
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': this.user_id,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'email': this.email,
      'phone': this.phone,
      'password': this.password,
      'image_url': this.image_url,
      'country_code': this.country_code,
      'notification_token': this.notification_token,
      'lastSeen': this.lastSeen,
    };
  }

  factory RegisteredUser.fromMap(Map<String, dynamic> map) {
    return RegisteredUser(
      user_id: map['userID'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String,
      image_url: map['image_url'] as String,
      country_code: map['country_code'] as String,
      notification_token: map['notification_token'] as String,
      lastSeen: map['lastSeen'] as int,
    );
  }
}