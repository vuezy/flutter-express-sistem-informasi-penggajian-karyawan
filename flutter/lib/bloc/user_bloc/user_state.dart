part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserError extends UserState {
  final String message;
  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}

class UserRegistered extends UserState {
  final String message;
  const UserRegistered({required this.message});

  @override
  List<Object> get props => [message];
}

class UserLoggedIn extends UserState {
  final Account account;
  const UserLoggedIn({required this.account});

  @override
  List<Object> get props => [account];
}

class UserLoggedOut extends UserState {}