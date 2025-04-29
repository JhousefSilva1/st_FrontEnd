
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smarttolls/api/response/st_brand_response.dart';

class BrandApi {
  static const String _baseUrl = 'http://192.168.0.7:8888/api/brands';

  static Future<List<StBrandResponse>> getBrands() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => StBrandResponse.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener marcas');
    }
  }
}