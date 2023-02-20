import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:si_penggajian/models/account_model.dart';
import 'package:si_penggajian/repositories/account_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AccountRepository accountRepository;

  UserBloc({required this.accountRepository}) : super(UserInitial()) {
    on<RegisterUser>(_register);
    on<LoginUser>(_login);
    on<LogoutUser>(_logout);
  }

  void _register(RegisterUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final message = await accountRepository.register(event.user);
      emit(UserRegistered(message: message));
    }
    catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  void _login(LoginUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final account = await accountRepository.login(event.account);
      emit(UserLoggedIn(account: account));
    }
    catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  void _logout(LogoutUser event, Emitter<UserState> emit) {
    emit(UserLoggedOut());
  }
}
