import 'package:contact_art/models/User.dart';
import 'package:flutter/foundation.dart';


class UserProvider with ChangeNotifier{
  User? _user;
  String? _userId;

  User get user => _user!;
  String get userId => _userId!;

  void setUser(User user){
    _user = user;
    notifyListeners();
  }

  void setUserId(String userId){
    _userId = userId;
    notifyListeners();
  }

  Stream<User?> get userStream async* {
    yield _user;
  }
}