import 'package:dio/dio.dart';
import 'package:si_penggajian/models/account_model.dart';
import 'package:si_penggajian/repositories/api_client.dart';

class AccountRepository extends ApiClient {
  Future<String> register(Map<String, dynamic> user) async {
    try {
      final res = await dio.post('/register', data: user);
      return res.data['message'];
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }

  Future<Account> login(Map<String, String> account) async {
    try {
      final res = await dio.post('/login', data: account);
      return Account.fromJson(res.data['account']);
    }
    on DioError catch (e) {
      throw e.response?.data['message'] ?? 'ERROR! Please try again!';
    }
  }
}