import 'package:dio/dio.dart';

abstract class ApiClient {
  final _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:5000/api'
  ));

  Dio get dio => _dio;
}