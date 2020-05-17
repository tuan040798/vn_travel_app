import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vn_travel_app/constant/api_constant.dart';
import 'package:vn_travel_app/stores/user_store/user_store.dart';
import 'package:vn_travel_app/model/user_login.dart';


Future postAuthFB( String params) async {
  try {
    var data = {
      "access_token": params
    };
    var response = await http.post("$server_url/$auth_facebook", body: data);
    if(response.statusCode == 201){
      final responseBody = await json.decode(response.body);
      user_store.setToken(responseBody['token']);
      user_store.setCurrentUser(User.fromJson(responseBody['user']));
      return true;
    } else {
      return false;
    }
  } catch(e) {
    print(e.toString());
    return false;
  }
}

Future postAuthGG( String params) async {
  try {
    var data = {
      "access_token": params
    };
    var response = await http.post("$server_url/$auth_google", body: data);
    print("Status code: ${response.statusCode}");
    if(response.statusCode == 201){
      final responseBody = await json.decode(response.body);
      user_store.setToken(responseBody['token']);
      user_store.setCurrentUser(User.fromJson(responseBody['user']));
      return true;
    } else {
      return false;
    }
  } catch(e) {
    print(e.toString());
    return false;
  }
}

Future autoLogin(String type, String access_token) async {
  var data = {
    "access_token": access_token
  };
  if(type == "Google"){
    var response = await http.post("$server_url/$auth_google", body: data);
    if(response.statusCode == 201){
      final responseBody = await json.decode(response.body);
      user_store.setToken(responseBody['token']);
      user_store.setCurrentUser(User.fromJson(responseBody['user']));
    }
  } else if(type == "Facebook"){
    var response = await http.post("$server_url/$auth_facebook", body: data);
    if(response.statusCode == 201){
      final responseBody = await json.decode(response.body);
      user_store.setToken(responseBody['token']);
      user_store.setCurrentUser(User.fromJson(responseBody['user']));
    }
  }
}