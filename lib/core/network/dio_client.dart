import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class DioClient {
  static Dio get instance{
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl, //Rest Api base Url
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.queryParameters['apiKey'] = ApiConstants.apiKey;
        handler.next(options);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ));

    return dio;
  }
}
