import 'package:crud_app/features/auth/domain/entities/user_entity.dart';
import 'package:crud_app/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser({required this.repository});

  Future<UserEntity?> call() async {
    return await repository.getCurrentUser();
  }
}