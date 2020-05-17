import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vn_travel_app/constant/api_constant.dart';

Future getAllNews(String token,int page) async {
  try {
    var response = await http.get("$server_url/$news?sort=-createdAt&limit=20&page=$page", headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      print(page);
      return responseBody;
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}
