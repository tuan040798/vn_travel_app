import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:vn_travel_app/constant/api_constant.dart' as prefix0;
import 'package:http/http.dart' as http;
import 'package:vn_travel_app/constant/api_constant.dart';
import 'package:vn_travel_app/model/user_login.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';

Future<User> getCurrentUser(String token) async {
  try {
    var response = await http.get("$server_url/$users_base/me", headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      return User.fromJson(responseBody);
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future getUserById(String id, String token) async {
  try {
    var response = await http.get("$server_url/$users_base/${id}", headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      return responseBody;
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future getListUserFollow(String id, String listId, String token,int quantity) async {
  try {
    var response =
    await http.get("$server_url/$users_base?usersid=${listId}&limit=20&page=$quantity", headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      return responseBody;
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future updateUserById(User user, String token, String id) async {
  try {
    var data = {
      'name': user.name,
      'picture': user.picture  ,
      'aboutMe': user.aboutMe  == null ? "" : user.aboutMe ,
    };
    var response = await http.put("$server_url/$users_base/$id",
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data);
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
    }
  } catch (e) {
    print(e.toString());
  }
}

Future savedPost(String userId, String postId, String token) async {
  try {
    var response =
    await http.put("$server_url/$users_base/$userId/$saved", headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      "saved": postId
    });
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      return responseBody;
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future followed(String userId, String ortherId, String token) async {
  try {
    var response =
    await http.put("$server_url/$users_base/$userId/$follow", headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      "following": ortherId
    });
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      return responseBody;
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future followerUser(String userId, String ortherId, String token) async {
  try {
    var response =
    await http.put("$server_url/$users_base/$ortherId/$follower", headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      "follower": userId
    });
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      return responseBody;
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future uploadAvatar(String token, File file, Function callBack) async {
  var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
  var length = await file.length();
  var uri = Uri.parse("$server_url/$upload/$avatar");
  var request = new http.MultipartRequest("POST", uri);
  var multipartFile = new http.MultipartFile('file[]', stream, length,
      filename: basename(file.path));
  request.files.add(multipartFile);
  request.headers['authorization'] = 'Bearer $token';
  var response = await request.send();
  response.stream.transform(utf8.decoder).listen((res) {
    var decodeRes = jsonDecode(res);
    callBack(decodeRes['data'][0]);
  });
}
