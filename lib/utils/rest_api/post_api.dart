import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vn_travel_app/constant/api_constant.dart';
import 'package:vn_travel_app/model/post_infor.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:vn_travel_app/stores/posts_store/posts_store.dart';
Future uploadFile(String token, File file, Function callback) async {
  var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
  var length = await file.length();
  var uri = Uri.parse("$server_url/$upload");
  var request = new http.MultipartRequest("POST", uri);
  var multipartFile = new http.MultipartFile('file[]', stream, length,
      filename: basename(file.path));
  request.files.add(multipartFile);
  request.headers['Authorization'] = 'Bearer $token';
  var response = await request.send();
  response.stream.transform(utf8.decoder).listen((res) {
    var decodeRes = jsonDecode(res);
    callback();
  });
}

Future uploadFileFull(String token, File file, Function callBack) async {
  var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
  var length = await file.length();
  var uri = Uri.parse("$server_url/$uploadfull");
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

Future uploadFileThumb(String token, File file, Function callBack) async {
  var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
  String re;
  var length = await file.length();
  var uri = Uri.parse("$server_url/$uploadthumb");
  var request = new http.MultipartRequest("POST", uri);
  var multipartFile = new http.MultipartFile('file[]', stream, length,
      filename: basename(file.path));
  request.files.add(multipartFile);
  request.headers['authorization'] = 'Bearer $token';
  var response = await request.send();
  await response.stream.transform(utf8.decoder).listen((res) {
    var decodeRes = jsonDecode(res);
    callBack(decodeRes['data'][0]);
  });
}

Future<Post> likePost(String postId, String token) async {
  try {
    var response =
    await http.put("$server_url/$posts_base/$postId/$like", headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      return Post.fromJson(responseBody);
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future<Post> commentPost(String cmtId, String postId, String token) async {
  var cmtData = {"comment": cmtId};

  try {
    var response = await http.put("$server_url/$posts_base/$postId/$comment",
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: cmtData);
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      return Post.fromJson(responseBody);
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future getAllPost(int quantity, String token) async {
  try {
    var response = await http.get(
        "$server_url/$posts_base?sort=-createdAt&limit=20&page=$quantity",
        headers: {
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
Future getAllPostByTag(int quantity, String token,String data) async {
  try {
    var response = await http.get(
        "$server_url/$posts_base?q=$data&sort=-createdAt&limit=20&page=$quantity",
        headers: {
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
Future
getUser(int quantity, String token,String data) async {
  try {
    var response = await http.get(
        "$server_url/$users_base?q=$data&sort=-createdAt&limit=20&page=$quantity",
        headers: {
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
Future getPostById(String id, String token) async {
  try {
    var response = await http.get("$server_url/$posts_base/${id}", headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
    }
  } catch (e) {
    print(e.toString());
  }
}

Future getFollowFeed(String arrId, int quantity, String token) async {
  try {
    var response = await http.get(
        "$server_url/$posts_base?author=$arrId&sort=-createdAt&limit=20&page=$quantity",
        headers: {
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

Future getFeed(String arrId, String token,int quantity) async {
  try {
    var response = await http
        .get("$server_url/$posts_base?author=$arrId&sort=-createdAt&limit=20&page=$quantity", headers: {
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
Future getListPosted(String arrId, String token,int quantity) async {
  try {
    var response = await http
        .get("$server_url/$posts_base?author=$arrId&sort=-createdAt&limit=20&page=$quantity", headers: {
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


Future getSaved(String arrId, String token,int quantity) async {
  try {
    var response = await http
        .get("$server_url/$posts_base?arrid=$arrId&limit=20&page=$quantity", headers: {
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

Future insertPost(Post post, String token) async {
  try {
    var data = {
      'client': post.client,
      'description': post.description,
      'full_url': post.fullUrl,
      'tag': post.tag,
      'thumb_url': post.thumbUrl,
      'title': post.title
    };
    var response = await http.post("$server_url/$posts_base",
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: data);
    if (response.statusCode == 201) {
      final responseBody = await json.decode(response.body);
      return responseBody;
    } else {
      return null;
    }
  } catch (e) {
    print("Error:" + e.toString());
    return null;
  }
}

Future updatePostById(Post post, String token) async {
  try {
    var response = await http.put("$server_url/$posts_base",
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: json.encode(post));
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
    }
  } catch (e) {
    print(e.toString());
  }
}

Future deletePostById(String id, String token) async {
  try {
    var response = await http.delete("$server_url/$posts_base/${id}", headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
    }
  } catch (e) {
    print(e.toString());
  }
}
