// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$PostsStore on _PostsStore, Store {
  final _$allPostAtom = Atom(name: '_PostsStore.allPost');

  @override
  List<Post> get allPost {
    _$allPostAtom.context.enforceReadPolicy(_$allPostAtom);
    _$allPostAtom.reportObserved();
    return super.allPost;
  }

  @override
  set allPost(List<Post> value) {
    _$allPostAtom.context.conditionallyRunInAction(() {
      super.allPost = value;
      _$allPostAtom.reportChanged();
    }, _$allPostAtom, name: '${_$allPostAtom.name}_set');
  }

  final _$allHomePostAtom = Atom(name: '_PostsStore.allHomePost');

  @override
  List<Post> get allHomePost {
    _$allHomePostAtom.context.enforceReadPolicy(_$allHomePostAtom);
    _$allHomePostAtom.reportObserved();
    return super.allHomePost;
  }

  @override
  set allHomePost(List<Post> value) {
    _$allHomePostAtom.context.conditionallyRunInAction(() {
      super.allHomePost = value;
      _$allHomePostAtom.reportChanged();
    }, _$allHomePostAtom, name: '${_$allHomePostAtom.name}_set');
  }

  final _$getPostAsyncAction = AsyncAction('getPost');

  @override
  Future<Null> getPost(List<String> arrID) {
    return _$getPostAsyncAction.run(() => super.getPost(arrID));
  }

  final _$getHomePostAsyncAction = AsyncAction('getHomePost');

  @override
  Future<Null> getHomePost() {
    return _$getHomePostAsyncAction.run(() => super.getHomePost());
  }

  final _$_PostsStoreActionController = ActionController(name: '_PostsStore');

  @override
  dynamic setPost(List<Post> allPost) {
    final _$actionInfo = _$_PostsStoreActionController.startAction();
    try {
      return super.setPost(allPost);
    } finally {
      _$_PostsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setHomePost(List<Post> allPost) {
    final _$actionInfo = _$_PostsStoreActionController.startAction();
    try {
      return super.setHomePost(allPost);
    } finally {
      _$_PostsStoreActionController.endAction(_$actionInfo);
    }
  }
}
