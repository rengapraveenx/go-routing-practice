import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Mock implementation of [AuthRepository] for learning purposes.
/// Simulates a delay and accepts any non-empty credentials.
class AuthRepositoryImpl implements AuthRepository {
  UserEntity? _currentUser;

  @override
  Future<UserEntity?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty');
    }
    if (password.length < 4) {
      throw Exception('Invalid credentials');
    }

    _currentUser = UserEntity(
      id: 'user_001',
      name: email.split('@').first,
      email: email,
    );

    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }
}
