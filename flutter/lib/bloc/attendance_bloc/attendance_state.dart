part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();
  
  @override
  List<Object> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceError extends AttendanceState {
  final String message;
  const AttendanceError({required this.message});

  @override
  List<Object> get props => [message];
}

class AttendanceLoaded extends AttendanceState {
  final List<Attendance> attendance;
  const AttendanceLoaded({required this.attendance});

  @override
  List<Object> get props => [attendance];
}

class AttendanceFilledOrCreated extends AttendanceState {
  final String message;
  const AttendanceFilledOrCreated({required this.message});

  @override
  List<Object> get props => [message];
}

class AttendanceUpdated extends AttendanceState {}

class AttendanceDeleted extends AttendanceState {}