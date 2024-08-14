import 'dart:convert';

import 'package:auth_with_shared/auth/user.dart';
import 'package:auth_with_shared/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<AppStartedEvent>(_onAppStarted);
    on<LoginEvent>(_onLogin);
    on<CheckLoginEvent>(_onCheckLogin);
    on<LogoutEvent>(_onLogout);
    on<ChangePasswordEvent>(_onChangePassword);
    add(AppStartedEvent());
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.register(event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_handleError(e)));
    }
  }

  Future<void> _onAppStarted(
      AppStartedEvent event, Emitter<AuthState> emit) async {
    final isLoggedIn = await authRepository.isLoggedIn();
    if (isLoggedIn) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userData = sharedPreferences.getString('userData');
      final user = User.fromMap(jsonDecode(userData!));
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(
        AuthError(
          _handleError(e),
        ),
      );
    }
  }

  Future<void> _onCheckLogin(
      CheckLoginEvent event, Emitter<AuthState> emit) async {
    final isLoggedIn = await authRepository.isLoggedIn();
    if (isLoggedIn) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userData = sharedPreferences.getString('userData');
      final user = User.fromMap(jsonDecode(userData!));
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onChangePassword(
      ChangePasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.changePassword(event.email);
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(_handleError(e)));
    }
  }

  String _handleError(Object e) {
    String message = e.toString();
    if (message.contains("EMAIL_EXISTS")) {
      return "Bu email mavjud";
    } else if (message.contains("WEAK_PASSWORD")) {
      return "Parol juda qisqa!";
    } else if (message.contains("INVALID_LOGIN_CREDENTIALS")) {
      return "Parol yokiy email hato!";
    } else {
      return "Xato ro'y berdi. Iltimos, qayta urinib ko'ring.";
    }
  }
}
