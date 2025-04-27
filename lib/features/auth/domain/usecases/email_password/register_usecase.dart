import 'package:crud_app/features/auth/domain/entities/user_entity.dart';
import 'package:crud_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterWithEmailAndPassword {
  final AuthRepository repository;

  RegisterWithEmailAndPassword(this.repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password
  }) async {
    return await repository.registerWithEmailAndPassword(
      name: name,
      email: email,
      password: password
    );
  }
}