import 'package:crud_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password
  });

  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password
  });

  Future<UserEntity?> getCurrentUser();

  Future<void> signOut();
}