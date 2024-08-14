import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class CheckLoginEvent extends AuthEvent {}
class AppStartedEvent extends AuthEvent{}

class LogoutEvent extends AuthEvent {}

class ChangePasswordEvent extends AuthEvent {
  final String email;

  ChangePasswordEvent(this.email);

  @override
  List<Object?> get props => [email];
}
