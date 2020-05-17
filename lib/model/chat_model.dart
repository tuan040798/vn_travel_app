//var a = {
//  "id_chat": "",
//  "name_chat": "",
//  "members": { // single or multiple member
//    "id_member" : {
//      "profile_picture": "",
//      "full_name": ""
//    }
//  },
//  "background_chat": "",
//  "seen": "", // timestamp seen chat
//  "descrition": "",
//  "chat_picture": "", // avatar chat: chat single-profile_pictuce user,  chat multiple picture users upload
//  "content": {
//    "timestamp_chat": { // id messages
//      "idFrom": "",
//      "idTo": "",
//      "content": "",
//      "type": "", // send image or text,...
//      "timestamp": ""
//    }
//  }
//};

class ChatData {
  String idChat;
  String nameChat;
  Members members;
  String backgroundChat;
  String seen;
  String descrition;
  String chatPicture;
  Content content;

  ChatData(
      {this.idChat,
        this.nameChat,
        this.members,
        this.backgroundChat,
        this.seen,
        this.descrition,
        this.chatPicture,
        this.content});

  ChatData.fromJson(Map<String, dynamic> json) {
    idChat = json['id_chat'];
    nameChat = json['name_chat'];
    members =
    json['members'] != null ? new Members.fromJson(json['members']) : null;
    backgroundChat = json['background_chat'];
    seen = json['seen'];
    descrition = json['descrition'];
    chatPicture = json['chat_picture'];
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_chat'] = this.idChat;
    data['name_chat'] = this.nameChat;
    if (this.members != null) {
      data['members'] = this.members.toJson();
    }
    data['background_chat'] = this.backgroundChat;
    data['seen'] = this.seen;
    data['descrition'] = this.descrition;
    data['chat_picture'] = this.chatPicture;
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    return data;
  }
}

class Members {
  IdMember idMember;

  Members({this.idMember});

  Members.fromJson(Map<String, dynamic> json) {
    idMember = json['id_member'] != null
        ? new IdMember.fromJson(json['id_member'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.idMember != null) {
      data['id_member'] = this.idMember.toJson();
    }
    return data;
  }
}

class IdMember {
  String profilePicture;
  String fullName;

  IdMember({this.profilePicture, this.fullName});

  IdMember.fromJson(Map<String, dynamic> json) {
    profilePicture = json['profile_picture'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_picture'] = this.profilePicture;
    data['full_name'] = this.fullName;
    return data;
  }
}

class Content {
  TimestampChat timestampChat;

  Content({this.timestampChat});

  Content.fromJson(Map<String, dynamic> json) {
    timestampChat = json['timestamp_chat'] != null
        ? new TimestampChat.fromJson(json['timestamp_chat'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.timestampChat != null) {
      data['timestamp_chat'] = this.timestampChat.toJson();
    }
    return data;
  }
}

class TimestampChat {
  String idFrom;
  String idTo;
  String content;
  String type;
  String timestamp;

  TimestampChat(
      {this.idFrom, this.idTo, this.content, this.type, this.timestamp});

  TimestampChat.fromJson(Map<String, dynamic> json) {
    idFrom = json['idFrom'];
    idTo = json['idTo'];
    content = json['content'];
    type = json['type'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idFrom'] = this.idFrom;
    data['idTo'] = this.idTo;
    data['content'] = this.content;
    data['type'] = this.type;
    data['timestamp'] = this.timestamp;
    return data;
  }
}