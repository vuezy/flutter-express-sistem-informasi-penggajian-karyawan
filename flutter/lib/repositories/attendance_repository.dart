import 'package:dio/dio.dart';
import 'package:si_penggajian/models/attendance_model.dart';
import 'package:si_penggajian/repositories/api_client.dart';

class AttendanceRepository extends ApiClient {
  Future<List<Attendance>> getAttendanceList(String token) async {
    try {
      final res = await dio.get('/attendance', options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
      final List<dynamic> attendance = res.data['attendance'];
      return attendance.map((json) => Attendance.fromJson(json)).toList();
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<String> fillAttendance(int id, String token) async {
    try {
      final res = await dio.patch('/attendance/fill/$id', options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
      return res.data['message'];
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<List<Attendance>> searchAttendance(String query, String token) async {
    try {
      final res = await dio.get('/attendance/all?nama=$query', options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
      final List<dynamic> attendance = res.data['attendance'];
      return attendance.map((json) => Attendance.fromJson(json)).toList();
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<String> createAttendance(Map<String, dynamic> attendance, String token) async {
    try {
      final res = await dio.post('/attendance', data: attendance, options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
      return res.data['message'];
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<void> updateAttendance(int id, Map<String, dynamic> attendance, String token) async {
    try {
      await dio.patch('/attendance/$id', data: attendance, options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<void> deleteAttendance(int id, String token) async {
    try {
      await dio.delete('/attendance/$id', options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }
}