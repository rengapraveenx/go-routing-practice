import 'package:equatable/equatable.dart';

/// Core user entity in domain layer.
/// No dependency on any framework or data models.
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  @override
  List<Object?> get props => [id, name, email];
}
