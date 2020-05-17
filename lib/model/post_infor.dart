class Post {
  String id;
  Author author;
  String client;
  String description;
  String fullStorageUri;
  String fullUrl;
  String tag;
  String thumbStorageUri;
  String thumbUrl;
  String title;
  List<String> like;
  List<String> comment;
  String createdAt;
  String updatedAt;

  Post(
      {this.id,
        this.author,
        this.client,
        this.description,
        this.fullStorageUri,
        this.fullUrl,
        this.tag,
        this.thumbStorageUri,
        this.thumbUrl,
        this.title,
        this.createdAt,
        this.updatedAt});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;
    client = json['client'];
    description = json['description'];
    fullStorageUri = json['full_storage_uri'];
    fullUrl = json['full_url'];
    tag = json['tag'];
    thumbStorageUri = json['thumb_storage_uri'];
    thumbUrl = json['thumb_url'];
    title = json['title'];
    like = json['like'].cast<String>();
    comment = json['comment'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    data['client'] = this.client;
    data['description'] = this.description;
    data['full_storage_uri'] = this.fullStorageUri;
    data['full_url'] = this.fullUrl;
    data['tag'] = this.tag;
    data['thumb_storage_uri'] = this.thumbStorageUri;
    data['thumb_url'] = this.thumbUrl;
    data['title'] = this.title;
    data['like'] = this.like;
    data['comment'] = this.comment;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}


class AvatarItems {
  String name;
  String image;

  AvatarItems({this.name, this.image});

  AvatarItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class Comment {
  String id;
  List<String> subComment;
  String text;
  String refer;
  Author author;
  String createdAt;
  String updatedAt;

  Comment(
      {this.id,
        this.subComment,
        this.text,
        this.refer,
        this.author,
        this.createdAt,
        this.updatedAt});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subComment = json['subComment'].cast<String>();
//      if(json['subComment'] != null && json['subComment'].length > 0){
//        subComment = new List<Comment>();
//      json['subComment'].forEach((item){
//        Comment cmtChild = Comment.fromJson(item);
//        subComment.add(cmtChild);
//      });
//    }
    text = json['text'];
    refer = json['refer'];
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subComment'] = this.subComment;
    data['text'] = this.text;
    data['refer'] = this.refer;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Author {
  String id;
  String name;
  String picture;

  Author({this.id, this.name, this.picture});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['picture'] = this.picture;
    return data;
  }
}