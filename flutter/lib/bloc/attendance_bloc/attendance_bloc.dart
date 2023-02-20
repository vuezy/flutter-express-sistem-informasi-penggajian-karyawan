import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:si_penggajian/models/attendance_model.dart';
import 'package:si_penggajian/repositories/attendance_repository.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository attendanceRepository;

  AttendanceBloc({required this.attendanceRepository}) : super(AttendanceInitial()) {
    on<GetAttendanceList>(_getAttendanceList);
    on<FillAttendance>(_fillAttendance);
    on<SearchAttendance>(_searchAttendance);
    on<CreateAttendance>(_createAttendance);
    on<UpdateAttendance>(_updateAttendance);
    on<DeleteAttendance>(_deleteAttendance);
  }

  void _getAttendanceList(GetAttendanceList event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      final attendance = await attendanceRepository.getAttendanceList(event.token);
      emit(AttendanceLoaded(attendance: attendance));
    }
    catch (e) {
      emit(AttendanceError(message: e.toString()));
    }
  }

  void _fillAttendance(FillAttendance event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      final message = await attendanceRepository.fillAttendance(event.id, event.token);
      emit(AttendanceFilledOrCreated(message: message));
    }
    catch (e) {
      emit(AttendanceError(message: e.toString()));
    }
  }

  void _searchAttendance(SearchAttendance event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      final attendance = await attendanceRepository.searchAttendance(event.query, event.token);
      emit(AttendanceLoaded(attendance: attendance));
    }
    catch (e) {
      emit(AttendanceError(message: e.toString()));
    }
  }

  void _createAttendance(CreateAttendance event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      final message = await attendanceRepository.createAttendance(event.attendance, event.token);
      emit(AttendanceFilledOrCreated(message: message));
    }
    catch (e) {
      emit(AttendanceError(message: e.toString()));
    }
  }

  void _updateAttendance(UpdateAttendance event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      await attendanceRepository.updateAttendance(event.id, event.attendance, event.token);
      emit(AttendanceUpdated());
    }
    catch (e) {
      emit(AttendanceError(message: e.toString()));
    }
  }

  void _deleteAttendance(DeleteAttendance event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      await attendanceRepository.deleteAttendance(event.id, event.token);
      emit(AttendanceDeleted());
    }
    catch (e) {
      emit(AttendanceError(message: e.toString()));
    }
  }
}
