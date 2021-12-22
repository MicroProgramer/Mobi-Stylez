class Follower {
  String user_id;

  Follower({
    required this.user_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': this.user_id,
    };
  }

  factory Follower.fromMap(Map<String, dynamic> map) {
    return Follower(
      user_id: map['user_id'] as String,
    );
  }
}
