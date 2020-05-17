import 'package:mobx/mobx.dart';
import 'package:vn_travel_app/model/user_login.dart';
import 'package:vn_travel_app/utils/rest_api/user_api.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {

  @observable
  String token;

  @observable
  User currentUser = new User();


  @action
  void setToken(String tk){
    token = tk;
  }

  @action
  void setCurrentUser(User user){
    currentUser = user;
  }

  @action
  void refreshUser(){
    token=null;
    currentUser=new User();
  }

}

final UserStore user_store = new UserStore();