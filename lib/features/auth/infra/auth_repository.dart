import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_app/config/env.dart';
import 'package:flutter_app/features/auth/models/user.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  if (Env.useMock) {
    return MockAuthRepository();
  } else {
    return AuthRepositoryImpl();
  }
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    // TODO: Implement actual API call using Dio
    throw UnimplementedError('Real authentication is not implemented yet.');
  }
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    if (email == 'test@example.com' && password == 'password') {
      return const User(
        id: 1,
        name: 'Test User',
        email: 'test@example.com',
        token: 'fake_jwt_token',
      );
    }
    throw Exception('Invalid credentials');
  }
}
