import 'package:dio/dio.dart';
import 'package:si_penggajian/models/gajian_detail_model.dart';
import 'package:si_penggajian/models/gajian_model.dart';
import 'package:si_penggajian/repositories/api_client.dart';

class GajianRepository extends ApiClient {
  Future<List<Gajian>> getGajianList(String token) async {
    try {
      final res = await dio.get('/gajian', options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
      final List<dynamic> gajian = res.data['gajian'];
      return gajian.map((json) => Gajian.fromJson(json)).toList();
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<GajianDetail> getGajianDetail(int id, String token) async {
    try {
      final res = await dio.get('/gajian/detail/$id', options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
      return GajianDetail.fromJson(res.data['gajian']);
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<String> receiveGajian(int id, String token) async {
    try {
      final res = await dio.patch('/gajian/receive/$id', options: Options(
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

  Future<List<Gajian>> searchGajian(String query, String token) async {
    try {
      final res = await dio.get('/gajian/all?nama=$query', options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
      final List<dynamic> gajian = res.data['gajian'];
      return gajian.map((json) => Gajian.fromJson(json)).toList();
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<GajianDetail> previewGajian(Map<String, int> gajian, String token) async {
    try {
      final res = await dio.get('/gajian/preview', queryParameters: gajian, options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
      return GajianDetail.fromJson(res.data['gajian']);
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<String> createGajian(Map<String, int> gajian, String token) async {
    try {
      final res = await dio.post('/gajian', data: gajian, options: Options(
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

  Future<void> updateGajian(int id, Map<String, int> gajian, String token) async {
    try {
      await dio.patch('/gajian/$id', data: gajian, options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<void> deleteGajian(int id, String token) async {
    try {
      await dio.delete('/gajian/$id', options: Options(
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