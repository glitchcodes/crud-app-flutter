import 'package:crud_app/features/auth/domain/entities/user_entity.dart';
import 'package:crud_app/features/auth/domain/repositories/auth_repository.dart';

class LoginWithEmailAndPassword {
  final AuthRepository repository;

  LoginWithEmailAndPassword({required this.repository});

  Future<UserEntity> call({
    required String email,
    required String password
  }) async {
    return await repository.signInWithEmailAndPassword(
        email: email,
        password: password
    );
  }
}