import 'package:vn_travel_app/model/user_login.dart';
import 'package:mobx/mobx.dart';
import 'package:vn_travel_app/model/post_infor.dart';
import 'package:vn_travel_app/utils/rest_api/post_api.dart';
import 'package:vn_travel_app/stores/user_store/user_store.dart';
import 'package:vn_travel_app/model/post_infor.dart';
import 'package:vn_travel_app/model/news.dart';
import 'package:vn_travel_app/utils/rest_api/news_api.dart';
import 'package:vn_travel_app/utils/rest_api/user_api.dart';
part 'posts_store.g.dart';

class PostsStore = _PostsStore with _$PostsStore;

abstract class _PostsStore with Store {
  @observable
  List<Post> searchPostList=new List<Post>();
  @observable
  List<User> searchUserList=new List<User>();
  @observable
  List<Post> allPost = new List<Post>();
  @observable
  List<Post> allHomePost = new List<Post>();
  @observable
  List<Post> posted = new List<Post>();
  @observable
  List<Post> saved = new List<Post>();
  @observable
  List<NewsModal> news = new List<NewsModal>();
  @observable
  List<User> follows = new List<User>();
  @observable
  int postedCount = 0;
  @observable
  int pageFollow=1;

  @action
  void changePageFollow(int number){
    pageFollow=number;
  }
  @action
  void refreshStore(){
    searchPostList=new List<Post>();

    searchUserList=new List<User>();
    allPost = new List<Post>();
    allHomePost = new List<Post>();
    posted = new List<Post>();
    saved = new List<Post>();
    news = new List<NewsModal>();
    follows = new List<User>();
    postedCount = 0;
    pageFollow=1;
  }
  @action
  void setFollows(List<User> list){
    follows=list;
  }
//  @action
//  void updatePosted(Post post,int index) async {
//    allPost[index]=post;
//  }

  void addHomePost(Post value ) async {
    allHomePost.add(value);
  }

  @action
  getListFollow() async {
    if(user_store.currentUser.following.length>0){
      var childUsers = await getListUserFollow(user_store.currentUser.id,
          user_store.currentUser.following.join(","), user_store.token,1);
      if(childUsers!=null){
        var users = childUsers['rows'];
        if (users != null && users.length > 0) {
          List<User> newListUser = new List<User>();
          users.forEach((item) {
            User cmtRes = User.fromJson(item);
            if (cmtRes.id != null) {
              newListUser.add(cmtRes);
            }
          });
          follows=[]..addAll(newListUser);
//          posted.sort((a, b) =>
//              DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));
//          print("All Sub Comment: ${follows.length}");
        }
      }

    }

  }

  @action
  void getPosted() async {
    var postRespond = await getListPosted(user_store.currentUser.id, user_store.token,1);
    if(postRespond!=null){
      var childPosts = postRespond["rows"];
      postedCount = postRespond["count"];
      if (childPosts != null && childPosts.length > 0) {
        List<Post> newListPost = new List<Post>();
        childPosts.forEach((item) {
          Post cmtRes = Post.fromJson(item);
          if (cmtRes.id != null) {
            newListPost.add(cmtRes);
          }
        });
        posted=[]..addAll(newListPost) ;
      }
    }

  }


  @action
  void getNews() async {
    var childCmtRes = await getAllNews(user_store.token,1);
    if (childCmtRes != null && childCmtRes.length > 0) {
      List<NewsModal> newListCommet = new List<NewsModal>();
      childCmtRes.forEach((item) {
        NewsModal cmtRes = NewsModal.fromJson(item);
        if (cmtRes.id != null) {
          newListCommet.add(cmtRes);
        }
      });
      news=[]..addAll(newListCommet) ;
    }
  }

  @action
  void getSaveds() async {
    if (user_store.currentUser.saved.length > 0) {
      var posted = await getSaved(
          user_store.currentUser.saved.join(","), user_store.token,1);
      var childPosts = posted["rows"];
      if (childPosts != null && childPosts.length > 0) {
        List<Post> newListPost = new List<Post>();
        childPosts.forEach((item) {
          Post cmtRes = Post.fromJson(item);
          if (cmtRes.id != null) {
            newListPost.add(cmtRes);
          }
        });
        saved=[]..addAll(newListPost) ;
//        saved.sort((a, b) =>
//            DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));
//        print("All Sub Comment: ${posted.length}");
      }
    }
  }

  @action
  setPost(List<Post> allPost) {
    this.allPost = allPost;
  }

  @action
  setHomePost(List<Post> allPost) {
    this.allHomePost = allPost;
  }
  @action
  setNews(List<NewsModal> newspost ){

    this.news=newspost;
  }
  @action
  setPosted(List<Post> newspost ){

    this.posted=newspost;
  }
  @action
  setSaved(List<Post> newspost ){

    this.saved=newspost;
  }
  @action
  Future<Null> getPost(List<String> arrID) async {


    if(arrID.length>0 && arrID != null){
      var res = await getFollowFeed(arrID.join(","), 1, user_store.token);
      if(res==null){
        allPost=[];
      }else{
        var respond = res["rows"];
        if (respond != null && respond.length > 0) {
          List<Post> newPostAll = new List<Post>();
          respond.forEach((item) {
            Post postRes = Post.fromJson(item);
            if (postRes.id != null) {
              newPostAll.add(postRes);
            }
          });
          allPost =[]..addAll(newPostAll) ;
        }
      }
    }else{
      allPost=new List<Post>();
    }


  }

  @action
  Future<Null> getHomePost() async {
    var res = await getAllPost(1, user_store.token);
    if(res!=null){
      var respond = res["rows"];
      if (respond != null && respond.length > 0) {
        List<Post> newPostAll = new List<Post>();
        respond.forEach((item) {
          Post postRes = Post.fromJson(item);
          if (postRes.id != null) {
            newPostAll.add(postRes);
          }
        });
        allHomePost=[]..addAll(newPostAll) ;
      }
    }

  }

  @action
  Future<Null> getHomePostByTag(String tag) async {
    var res = await getAllPostByTag(1, user_store.token,tag);
    var respond = res["rows"];
    if (respond != null && respond.length > 0) {
      List<Post> newPostAll = new List<Post>();
      respond.forEach((item) {
        Post postRes = Post.fromJson(item);
        if (postRes.id != null) {
          newPostAll.add(postRes);
        }
      });
      allHomePost=[]..addAll(newPostAll) ;
    }
  }
}

final PostsStore post_store = new PostsStore();
