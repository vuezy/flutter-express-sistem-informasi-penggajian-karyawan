part of 'attendance_bloc.dart';

abstract class AttendanceEvent {
  final String token;
  const AttendanceEvent({required this.token});
}

class GetAttendanceList extends AttendanceEvent {
  const GetAttendanceList({required super.token});
}

class FillAttendance extends AttendanceEvent {
  final int id;
  const FillAttendance({required this.id, required super.token});
}

class SearchAttendance extends AttendanceEvent {
  final String query;
  const SearchAttendance({required this.query, required super.token});
}

class CreateAttendance extends AttendanceEvent {
  final Map<String, dynamic> attendance;
  const CreateAttendance({required this.attendance, required super.token});
}

class UpdateAttendance extends AttendanceEvent {
  final int id;
  final Map<String, dynamic> attendance;
  const UpdateAttendance({required this.id, required this.attendance, required super.token});
}

class DeleteAttendance extends AttendanceEvent {
  final int id;
  const DeleteAttendance({required this.id, required super.token});
}