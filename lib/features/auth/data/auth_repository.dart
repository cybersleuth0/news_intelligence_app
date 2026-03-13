import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/utils/hive_helper.dart';

class AuthRepository {
  final Box _authBox = Hive.box(HiveHelper.authBox);

  bool isLoggedIn() {
    return _authBox.get('isLoggedIn', defaultValue: false);
  }

  Future<void> login(String email, String password) async {
    // Simple mock login for assignment
    await _authBox.put('isLoggedIn', true);
    await _authBox.put('email', email);
  }

  Future<void> logout() async {
    await _authBox.put('isLoggedIn', false);
    await _authBox.delete('email');
  }
}