import 'package:friend_circle/models/user_model.dart';

abstract class AuthBase {
  Future<UserModel?> getCurrentUser();
  Future<bool> logOut();
  Future<UserModel?> loginWithGoogle();
  Future<UserModel?> login(String? email, String? password);
  Future<UserModel?> register(String? email, String? password);
}
