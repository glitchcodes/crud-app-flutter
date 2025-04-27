import 'package:crud_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

class Authenticated extends AuthState {
  final UserEntity user;

  Authenticated({required this.user});
}

class Unauthenticated extends AuthState {}