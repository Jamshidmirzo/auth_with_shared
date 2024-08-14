import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _apiKey = 'AIzaSyDDGJsVvy7szTGa8U1EhxZwY58zX9Y9wh4';

  Future<Map<String, dynamic>> authenticate(
      String email, String password, String action) async {
    Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$action?key=$_apiKey');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (data['error']['message']);
      }
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$_apiKey');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'requestType': 'PASSWORD_RESET',
          'email': email,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (data['error']['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
