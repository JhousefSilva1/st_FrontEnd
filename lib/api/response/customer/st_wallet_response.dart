import 'dart:convert';

import 'package:smarttolls/api/api.dart';
import 'package:smarttolls/models/models.dart';

class StWalletResponse implements StResponseService{
  int idWallet;
  double? balance;
  String? walletNumber;
  String? walletCVS;
  String? walletName;
  String? walletBusiness;
  StVehicleResponse vehicle;
  StAuditResponse audit;

  StWalletResponse({
    required this.idWallet,
    this.balance,
    this.walletNumber,
    this.walletCVS,
    this.walletName,
    this.walletBusiness,
    required this.vehicle,
    required this.audit,
  });

  factory StWalletResponse.createEmpty() => StWalletResponse(
    idWallet: 0,
    balance: 0.0,
    walletNumber: '',
    walletCVS: '',
    walletName: '',
    walletBusiness: '',
    vehicle: StVehicleResponse.create(),
    audit: StAuditResponse.createEmpty(),
  );

  @override
  String toJson() => json.encode(toMap());

  factory StWalletResponse.fromJson(Map<String, dynamic> json) => StWalletResponse(
    idWallet: json["idWallet"],
    balance: json["balance"]?.toDouble(),
    walletNumber: json["walletNumber"],
    walletCVS: json["walletCVS"],
    walletName: json["walletName"],
    walletBusiness: json["walletBusiness"],
    vehicle: StVehicleResponse.fromJson(json["vehicle"]),
    audit: StAuditResponse.fromJson(json["audit"]),
  );

  @override
  Map<String, dynamic> toMap() => {
    "idWallet": idWallet,
    "balance": balance,
    "walletNumber": walletNumber,
    "walletCVS": walletCVS,
    "walletName": walletName,
    "walletBusiness": walletBusiness,
    "vehicle": vehicle.toJson(),
    "audit": audit.toJson(),
  };

  @override
  StWalletResponse fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  @override
  StWalletResponse fromMap(Map<String, dynamic> json) => StWalletResponse(
    idWallet: json["idWallet"],
    balance: json["balance"]?.toDouble(),
    walletNumber: json["walletNumber"],
    walletCVS: json["walletCVS"],
    walletName: json["walletName"],
    walletBusiness: json["walletBusiness"],
    vehicle: StVehicleResponse.fromJson(json["vehicle"]),
    audit: StAuditResponse.fromJson(json["audit"]),
  );

}