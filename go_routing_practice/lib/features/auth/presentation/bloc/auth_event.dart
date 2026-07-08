import 'package:equatable/equatable.dart';

/// Base class for all auth events.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Fired on app start to check if user is already logged in.
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Fired when the user submits the login form.
class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Fired when the user taps logout.
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
