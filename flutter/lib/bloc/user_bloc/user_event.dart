part of 'user_bloc.dart';

abstract class UserEvent {
  const UserEvent();
}

class RegisterUser extends UserEvent {
  final Map<String, dynamic> user;
  const RegisterUser({required this.user});
}

class LoginUser extends UserEvent {
  final Map<String, String> account;
  const LoginUser({required this.account});
}

class LogoutUser extends UserEvent {}