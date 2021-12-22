
class Post {
  String post_id, media_url, address;
  bool isImage;
  String description, barber_id;
  int timestamp;

  Post({
    required this.post_id,
    required this.media_url,
    required this.address,
    required this.isImage,
    required this.description,
    required this.barber_id,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'postID': this.post_id,
      'media_url': this.media_url,
      'address': this.address,
      'isImage': this.isImage,
      'description': this.description,
      'barberID': this.barber_id,
      'timestamp': this.timestamp,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      post_id: map['postID'] as String,
      media_url: map['media_url'] as String,
      address: map['address'] as String,
      isImage: map['isImage'] as bool,
      description: map['description'] as String,
      barber_id: map['barberID'] as String,
      timestamp: map['timestamp'] as int,
    );
  }
}
