import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crud_app/features/auth/domain/usecases/email_password/login_usecase.dart';
import 'package:crud_app/features/auth/domain/usecases/email_password/register_usecase.dart';
import 'package:crud_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:crud_app/features/auth/domain/usecases/logout_user.dart';
import 'package:crud_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:crud_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final RegisterWithEmailAndPassword registerWithEmailAndPassword;
  late final LoginWithEmailAndPassword loginWithEmailAndPassword;
  late final GetCurrentUser getCurrentUser;
  final LogoutUser logoutUser;

  AuthBloc({
    required this.registerWithEmailAndPassword,
    required this.loginWithEmailAndPassword,
    required this.getCurrentUser,
    required this.logoutUser
  }): super(AuthInitial()) {
    on<RegisterEvent>(_onRegisterEvent);
    on<LoginEvent>(_onLoginEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
    on<GetCurrentUserEvent>(_onGetCurrentUserEvent);
    on<LogoutEvent>(_onLogoutEvent);
  }

  Future<void> _onCheckAuthStatusEvent(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit
  ) async {
    emit(AuthLoading());

    try {
      final user = await getCurrentUser.call();

      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(Unauthenticated());
    }
  }

  void _onRegisterEvent(RegisterEvent event, Emitter<AuthState> emit) async {
    // Validate passwords first
    if (event.password != event.confirmPassword) {
      emit(AuthError(message: 'Passwords do not match'));
      return;
    }

    emit(AuthLoading());

    try {
      final user = await registerWithEmailAndPassword.call(
        name: event.name,
        email: event.email,
        password: event.password
      );

      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(Unauthenticated());
    }
  }

  void _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final user = await loginWithEmailAndPassword.call(
        email: event.email,
        password: event.password
      );

      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(Unauthenticated());
    }
  }

  void _onGetCurrentUserEvent(GetCurrentUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final user = await getCurrentUser.call();

      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(Unauthenticated());
    }
  }

  void _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await logoutUser.call();

      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}