import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<bool> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(_repository.isLoggedIn());

  Future<void> login(String email, String password) async {
    await _repository.login(email, password);
    state = true;
  }

  Future<void> logout() async {
    await _repository.logout();
    state = false;
  }
}