import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vn_travel_app/constant/api_constant.dart';

Future addComment(String text, String refer, String token) async {
  try {
    var comments = {"text": text, "refer": refer};

    var response = await http.post("$server_url/$comment",
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: comments);
    if (response.statusCode == 201) {
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

Future addSubComment(String id, String refer, String token) async {
  try {
    var comments = {"subComment": refer};

    var response = await http.put("$server_url/$comment/${id}/sub",
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: comments);
    if (response.statusCode == 201) {
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

// Future getCommentById(String id, String token) async {
//   try {
//     var response = await http.get(
//       "$server_url/$comment/${id}",
//       headers: {
//         'Authorization': 'Bearer $token',
//       },
//     );
//     if (response.statusCode == 200) {
//       final responseBody = await json.decode(response.body);
//       print("Comment Response: ${responseBody}");
//       return responseBody;
//     } else {
//       return null;
//     }
//   } catch (e) {
//     print(e.toString());
//     return null;
//   }
// }

Future getCommentByRefer(String refer, int page, String token) async {
  try {
    var response = await http.get(
      "$server_url/$comment?referent=$refer&sort=-createdAt&page=$page&limit=10",
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
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

Future getSubCommentByRefer(String refer, String token) async {
  try {
    var response = await http.get(
      "$server_url/$comment?referent=$refer&sort=-createdAt&page=1&limit=3",
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
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

Future getSubCommentByRefer2(String refer, int page, String token) async {
  try {
    var response = await http.get(
      "$server_url/$comment?referent=$refer&sort=-createdAt&page=$page&limit=10",
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
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
