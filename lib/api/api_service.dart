// lib/api/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'http:192.168.0.7:8888/api'}); // Cambia por tu URL base

  Future<http.Response> get(String endpoint) async {
    return await http.get(Uri.parse('$baseUrl/$endpoint'));
  }

  Future<http.Response> post(String endpoint, dynamic data) async {
    return await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
  }

  Future<http.Response> put(String endpoint, dynamic data) async {
    return await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    return await http.delete(Uri.parse('$baseUrl/$endpoint'));
  }
}