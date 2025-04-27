import 'package:crud_app/features/auth/domain/entities/user_entity.dart';
import 'package:crud_app/features/auth/domain/repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository repository;

  LogoutUser ({required this.repository});

  Future<void> call() async {
    return await repository.signOut();
  }
}