import 'package:dio/dio.dart';
import 'package:si_penggajian/models/karyawan_model.dart';
import 'package:si_penggajian/repositories/api_client.dart';

class KaryawanRepository extends ApiClient {
  Future<Karyawan> getProfile(int id, String token) async {
    try {
      final res = await dio.get('/karyawan/profile/$id', options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
      return Karyawan.fromJson(res.data['profile']);
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<void> updateProfile(int id, Map<String, dynamic> karyawan, String token) async {
    try {
      await dio.patch('/karyawan/profile/$id', data: karyawan, options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<List<Karyawan>> searchKaryawan(String query, String token) async {
    try {
      final res = await dio.get('/karyawan?nama=$query', options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
      final List<dynamic> karyawan = res.data['karyawan'];
      return karyawan.map((json) => Karyawan.fromJson(json)).toList();
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<void> deleteKaryawan(int id, String token) async {
    try {
      await dio.delete('/karyawan/$id', options: Options(
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