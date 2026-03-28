import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'exceptions/api_exception.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }

  Future<dynamic> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  void _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      throw ConnectionTimeoutException();
    } else if (error.type == DioExceptionType.receiveTimeout) {
      throw ReceiveTimeoutException();
    } else if (error.response != null) {
      throw ServerException(
        message: 'Error: ${error.response?.statusCode} - ${error.response?.statusMessage}',
        statusCode: error.response?.statusCode,
      );
    } else {
      throw UnknownException('An error occurred: ${error.message}');
    }
  }
}
