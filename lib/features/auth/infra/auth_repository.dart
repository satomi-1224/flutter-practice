import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}

class AuthRepository {
  // Mock data
  User? _currentUser;

  Future<User> login({required String email, required String password}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (password == 'error') {
      throw Exception('Login failed');
    }

    // Mock login success
    _currentUser = const User(
      id: 'user_001',
      email: 'demo@example.com',
      name: 'Demo User',
      avatarUrl: 'https://via.placeholder.com/150',
    );

    return _currentUser!;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  User? getCurrentUser() {
    return _currentUser;
  }
}