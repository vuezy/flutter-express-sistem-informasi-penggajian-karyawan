part of 'gajian_detail_bloc.dart';

abstract class GajianDetailState extends Equatable {
  const GajianDetailState();
  
  @override
  List<Object> get props => [];
}

class GajianDetailInitial extends GajianDetailState {}

class GajianDetailLoading extends GajianDetailState {}

class GajianDetailError extends GajianDetailState {
  final String message;
  const GajianDetailError({required this.message});

  @override
  List<Object> get props => [message];
}

class GajianDetailLoaded extends GajianDetailState {
  final GajianDetail gajian;
  const GajianDetailLoaded({required this.gajian});

  @override
  List<Object> get props => [gajian];
}