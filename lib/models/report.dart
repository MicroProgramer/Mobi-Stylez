class Report {
  String user_id, post_id, report_description;
  int timestamp;

  Report({
    required this.user_id,
    required this.post_id,
    required this.report_description,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': this.user_id,
      'post_id': this.post_id,
      'report_description': this.report_description,
      'timestamp': this.timestamp,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      user_id: map['user_id'] as String,
      post_id: map['post_id'] as String,
      report_description: map['report_description'] as String,
      timestamp: map['timestamp'] as int,
    );
  }
}
