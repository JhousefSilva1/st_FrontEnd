import 'dart:convert';
import 'dart:io';

abstract class StResponseService {
  String toJson();
  Map<String, dynamic> toMap();
  dynamic fromJson(String json);
  dynamic fromMap(Map<String, dynamic> json);
}

class StResponse<T extends StResponseService> {
  static const String errorDefault = 'Estamos teniendo problemas, intenta de nuevo más tarde';
  final int successCode = 200;
  final int undefinedErrorCode = -1;
  
  T? data;
  String? error;  List<T>? dataList;

  String? message;
  int? status;

  StResponse({
    this.data,
    this.dataList,
    this.error,
    this.message,
    this.status,
  });

  StResponse.createEmpty(){
    data;
    dataList;
    error;
    message = errorDefault;
    status = undefinedErrorCode;
  }

  factory StResponse.fromJson(String str) => StResponse.fromMap(jsonDecode(str));

  factory StResponse.fromJsonT(String str, T data) => StResponse.fromMapT(jsonDecode(str), data);

  factory StResponse.fromJsonList(String str, T data) => StResponse.fromMapList(jsonDecode(str), data);
  
  String toJson() => json.encode(toMap());

  factory StResponse.fromMap(Map<String, dynamic> json) => StResponse(
    data: null,
    error: json['error'],
    message: json['message'],
    status: json['status'],
  );

  factory StResponse.fromMapT(Map<String, dynamic> json, T data) => StResponse(
    data: json.containsKey("data")? (json["data"] != null ? data.fromMap(json["data"]) : null): null,
    error: json['error'],
    message: json['message'],
    status: json['status'],
  );

  factory StResponse.fromMapList(Map<String, dynamic> json, T dataTemplate) => StResponse(
    dataList: json.containsKey("data") && json["data"] != null
        ? (json["data"] as List).map((item) => dataTemplate.fromMap(item) as T).toList()
        : null,
    error: json['error'],
    message: json['message'],
    status: json['status'],
  );

  Map<String, dynamic> toMap() => {
    'data': data?.toMap(),
    'dataList': dataList?.map((item) => item.toMap()).toList(),
    'error': error,
    'message': message,
    'status': status,
  };

  static T? tryCast<T>(dynamic value) {
    try {
      return (value as T);
    } on TypeError catch (_) {
      return null;
    }
  }

  bool isSuccess() {
    return status == HttpStatus.ok;
  }

  bool isCreated() {
    return status == HttpStatus.created;
  }

  bool isBadRequest() {
    return status == HttpStatus.badRequest;
  }

  bool isNotFound() {
    return status == HttpStatus.notFound;
  }

}