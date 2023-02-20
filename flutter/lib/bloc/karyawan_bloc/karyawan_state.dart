part of 'karyawan_bloc.dart';

abstract class KaryawanState extends Equatable {
  const KaryawanState();
  
  @override
  List<Object> get props => [];
}

class KaryawanInitial extends KaryawanState {}

class KaryawanLoading extends KaryawanState {}

class KaryawanError extends KaryawanState {
  final String message;
  const KaryawanError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileKaryawanLoaded extends KaryawanState {
  final Karyawan karyawan;
  const ProfileKaryawanLoaded({required this.karyawan});

  @override
  List<Object> get props => [karyawan];
}

class ProfileKaryawanUpdated extends KaryawanState {}

class KaryawanLoaded extends KaryawanState {
  final List<Karyawan> karyawan;
  const KaryawanLoaded({required this.karyawan});

  @override
  List<Object> get props => [karyawan];
}

class KaryawanDeleted extends KaryawanState {}