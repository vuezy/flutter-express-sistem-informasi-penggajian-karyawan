import 'package:dio/dio.dart';
import 'package:si_penggajian/models/jabatan_model.dart';
import 'package:si_penggajian/repositories/api_client.dart';

class JabatanRepository extends ApiClient {
  Future<List<Jabatan>> searchJabatan(String query) async {
    try {
      final res = await dio.get('/jabatan?nama=$query');
      final List<dynamic> jabatan = res.data['jabatan'];
      return jabatan.map((json) => Jabatan.fromJson(json)).toList();
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<String> createJabatan(Map<String, String> jabatan, String token) async {
    try {
      final res = await dio.post('/jabatan', data: jabatan, options: Options(
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

  Future<void> updateJabatan(int id, Map<String, String> jabatan, String token) async {
    try {
      await dio.patch('/jabatan/$id', data: jabatan, options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<void> deleteJabatan(int id, String token) async {
    try {
      await dio.delete('/jabatan/$id', options: Options(
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