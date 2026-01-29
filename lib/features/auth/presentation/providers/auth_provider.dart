import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_password_reset_email_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUsecase registerUseCase;
  final LogoutUsecase logoutUseCase;
  final GetCurrentUserUsecase getCurrentUserUseCase;
  final SendPasswordResetEmailUsecase sendPasswordResetEmailUseCase;

  AuthNotifier({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.sendPasswordResetEmailUseCase,
  }) : super(const AuthState.initial());

  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();

    final result = await getCurrentUserUseCase();

    result.fold((failure) => state = const AuthState.unauthenticated(), (user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  Future<void> login({required String email, required String password}) async {
    state = const AuthState.loading();

    final result = await loginUseCase(email: email, password: password);

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AuthState.loading();

    final result = await registerUseCase(
      email: email,
      password: password,
      displayName: displayName,
    );

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  Future<void> logout() async {
    state = const AuthState.loading();

    final result = await logoutUseCase();

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) => state = const AuthState.unauthenticated(),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final result = await sendPasswordResetEmailUseCase(email);

    result.fold((failure) => state = AuthState.error(failure.message), (_) {});
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  throw UnimplementedError(
    'authNotifierProvider must be overridden in main.dart',
  );
});
