import 'dart:convert';
import 'package:auth_with_shared/auth/auth_service.dart';
import 'package:auth_with_shared/auth/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  Future<User> register(String email, String password) async {
    final response = await authService.authenticate(email, password, 'signUp');
    final user = User(
      email: email,
      id: response['localId'],
      expiryDate: DateTime.now().add(Duration(seconds: int.parse(response['expiresIn']))),
      password: password,
      token: response['idToken'],
    );
    await _saveUserToLocalStorage(user);
    return user;
  }

  Future<User> login(String email, String password) async {
    final response = await authService.authenticate(email, password, 'signInWithPassword');
    final user = User(
      email: email,
      id: response['localId'],
      expiryDate: DateTime.now().add(Duration(seconds: int.parse(response['expiresIn']))),
      password: password,
      token: response['idToken'],
    );
    await _saveUserToLocalStorage(user);
    return user;
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('userData');
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString('userData');
    if (userData == null) return false;

    final user = User.fromMap(jsonDecode(userData));
    return DateTime.now().isBefore(user.expiryDate);
  }

  Future<void> changePassword(String email) async {
    await authService.sendPasswordResetEmail(email);
  }

  Future<void> _saveUserToLocalStorage(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('userData', jsonEncode(user.toMap()));
  }
}
