import 'package:json_annotation/json_annotation.dart';


@JsonSerializable(explicitToJson: true)
class Service {
  String service_id, title, description;
  double minPrice, maxPrice;
  String image_url, barberID;

  Service({
    required this.service_id,
    required this.title,
    required this.description,
    required this.minPrice,
    required this.maxPrice,
    required this.image_url,
    required this.barberID,
  });

  Map<String, dynamic> toMap() {
    return {
      'service_id': this.service_id,
      'title': this.title,
      'description': this.description,
      'minPrice': this.minPrice,
      'maxPrice': this.maxPrice,
      'image_url': this.image_url,
      'barberID': this.barberID,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      service_id: map['service_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      minPrice: double.tryParse("${map['minPrice']}") ??
          (map['minPrice'] as int).toDouble(),
      maxPrice: double.tryParse("${map['maxPrice']}") ??
          (map['maxPrice'] as int).toDouble(),
      image_url: map['image_url'] as String,
      barberID: map['barberID'] as String,
    );
  }
}
