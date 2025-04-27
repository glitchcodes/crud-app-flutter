import 'package:crud_app/features/auth/data/data_sources/auth_data_source.dart';
import 'package:crud_app/features/auth/domain/entities/user_entity.dart';
import 'package:crud_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl({required this.authDataSource});

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await authDataSource.getCurrentUser();
  }

  @override
  Future<UserEntity> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password
  }) async {
    return await authDataSource.registerWithEmailAndPassword(
      name: name,
      email: email,
      password: password
    );
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    return await authDataSource.signInWithEmailAndPassword(
      email: email,
      password: password
    );
  }

  @override
  Future<void> signOut() async {
    await authDataSource.signOut();
  }
  
}