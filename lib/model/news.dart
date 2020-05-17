class NewsModal {
  String id;
  String title;
  String imgUrl;
  String link;
  String createdAt;
  String updatedAt;
  NewsModal(
      {this.id,
      this.title,
      this.imgUrl,
      this.link,
      this.createdAt,
      this.updatedAt});
  NewsModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imgUrl = json['imgUrl'];
    link = json['link'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['imgUrl'] = this.imgUrl;
    data['link'] = this.link;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
