part of 'jabatan_bloc.dart';

abstract class JabatanState extends Equatable {
  const JabatanState();
  
  @override
  List<Object> get props => [];
}

class JabatanInitial extends JabatanState {}

class JabatanLoading extends JabatanState {}

class JabatanError extends JabatanState {
  final String message;
  const JabatanError({required this.message});

  @override
  List<Object> get props => [message];
}

class JabatanLoaded extends JabatanState {
  final List<Jabatan> jabatan;
  const JabatanLoaded({required this.jabatan});

  @override
  List<Object> get props => [jabatan];
}

class JabatanCreated extends JabatanState {
  final String message;
  const JabatanCreated({required this.message});

  @override
  List<Object> get props => [message];
}

class JabatanUpdated extends JabatanState {}

class JabatanDeleted extends JabatanState {}