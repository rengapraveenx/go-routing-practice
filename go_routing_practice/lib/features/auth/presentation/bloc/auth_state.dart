import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

/// Base class for all auth states.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state — not yet checked if user is logged in.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Currently checking auth status (e.g., on app launch).
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated.
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user});

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

/// User is not authenticated.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Auth operation failed.
class AuthFailure extends AuthState {
  const AuthFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
