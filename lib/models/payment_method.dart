import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class PaymentMethod {
  String card_id, card_number;
  String user_id, card_holder, exp_date, cvv, card_type;

  PaymentMethod({
    required this.card_id,
    required this.card_number,
    required this.user_id,
    required this.card_holder,
    required this.exp_date,
    required this.cvv,
    required this.card_type,
  });

  Map<String, dynamic> toMap() {
    return {
      'card_id': this.card_id,
      'card_number': this.card_number,
      'user_id': this.user_id,
      'card_holder': this.card_holder,
      'exp_date': this.exp_date,
      'cvv': this.cvv,
      'card_type': this.card_type,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      card_id: map['card_id'] as String,
      card_number: map['card_number'] as String,
      user_id: map['user_id'] as String,
      card_holder: map['card_holder'] as String,
      exp_date: map['exp_date'] as String,
      cvv: map['cvv'] as String,
      card_type: map['card_type'] as String,
    );
  }
}
