import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import '../network/dio_client.dart';

abstract class BaseApiService {
  final DioClient dioClient;
  
  const BaseApiService({required this.dioClient});
  
  Future<T> handleApiCall<T>(Future<Response> apiCall) async {
    try {
      final response = await apiCall;
      
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      } else {
        throw ServerException(
          message: 'Server error: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          throw const NetworkException(message: 'Connection timeout');
        case DioExceptionType.connectionError:
          throw const NetworkException(message: 'No internet connection');
        case DioExceptionType.badResponse:
          final message = e.response?.data is Map && 
                         e.response?.data['message'] != null
              ? e.response!.data['message']
              : 'Server error';
          throw ServerException(message: message);
        case DioExceptionType.cancel:
          throw const NetworkException(message: 'Request cancelled');
        case DioExceptionType.unknown:
          throw const NetworkException(message: 'Unknown error occurred');
        default:
          throw const NetworkException(message: 'Network error');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'Unexpected error: $e');
    }
  }
}