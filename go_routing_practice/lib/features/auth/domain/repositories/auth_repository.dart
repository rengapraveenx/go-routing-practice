import '../entities/user_entity.dart';

/// Abstract contract for auth operations.
/// Data layer implements this; domain/presentation depend on this.
abstract class AuthRepository {
  /// Returns the logged-in [UserEntity] or null if not authenticated.
  Future<UserEntity?> getCurrentUser();

  /// Attempts login. Returns [UserEntity] on success, throws on failure.
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  /// Logs the user out.
  Future<void> logout();
}
