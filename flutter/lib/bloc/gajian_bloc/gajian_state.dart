part of 'gajian_bloc.dart';

abstract class GajianState extends Equatable {
  const GajianState();
  
  @override
  List<Object> get props => [];
}

class GajianInitial extends GajianState {}

class GajianLoading extends GajianState {}

class GajianError extends GajianState {
  final String message;
  const GajianError({required this.message});

  @override
  List<Object> get props => [message];
}

class GajianLoaded extends GajianState {
  final List<Gajian> gajian;
  const GajianLoaded({required this.gajian});

  @override
  List<Object> get props => [gajian];
}

class GajianReceivedOrCreated extends GajianState {
  final String message;
  const GajianReceivedOrCreated({required this.message});

  @override
  List<Object> get props => [message];
}

class GajianUpdated extends GajianState {}

class GajianDeleted extends GajianState {}