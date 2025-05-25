import 'dart:convert';

import 'package:smarttolls/models/st_response.dart';

class TransactionResponse implements StResponseService {
  final int? transactionId;
  final int? vehicleId;
  final int? tollId;
  final double? amount;
  final DateTime? transactionDate;

  TransactionResponse({
    this.transactionId,
    this.vehicleId,
    this.tollId,
    this.amount,
    this.transactionDate,
  });

  factory TransactionResponse.createEmpty() => TransactionResponse(
        transactionId: 0,
        vehicleId: 0,
        tollId: 0,
        amount: 0.0,
        transactionDate: DateTime.now(),
      );

  @override
  String toJson() => json.encode(toMap());
  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      TransactionResponse(
        transactionId: json["transactionId"],
        vehicleId: json["vehicleId"],
        tollId: json["tollId"],
        amount: json["amount"]?.toDouble(),
        transactionDate: DateTime.parse(json["transactionDate"]),
      );
  @override
  Map<String, dynamic> toMap() => {
        "transactionId": transactionId,
        "vehicleId": vehicleId,
        "tollId": tollId,
        "amount": amount,
        "transactionDate": transactionDate?.toIso8601String(),
      };
  @override
  TransactionResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }
  @override
  TransactionResponse fromMap(Map<String, dynamic> json) => TransactionResponse(
        transactionId: json["transactionId"],
        vehicleId: json["vehicleId"],
        tollId: json["tollId"],
        amount: json["amount"]?.toDouble(),
        transactionDate: DateTime.parse(json["transactionDate"]),
      );
}