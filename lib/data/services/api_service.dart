import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ovowpp/core/utils/util_exporter.dart';
import 'package:ovowpp/data/middleware/auth_middleware.dart';
import 'package:ovowpp/data/middleware/kyc_middle_ware.dart';
import 'package:ovowpp/data/middleware/middleware_group.dart';
import 'package:ovowpp/data/middleware/profile_status_middleware.dart';
import 'package:ovowpp/data/model/global/response_model/response_model.dart';
import 'package:ovowpp/data/services/shared_pref_service.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: UrlContainer.baseUrl,
      connectTimeout: Duration(seconds: 120), // 5 seconds
      receiveTimeout: Duration(seconds: 120), // 3 seconds
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Future<void> _attachAuthorizationToken() async {
    String? token = await SharedPreferenceService.getAccessTokenSecure();
    token ??= SharedPreferenceService.getAccessToken();

    if (token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      print('Authorization token: $token');
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  /// Add interceptors to handle request logging and authentication tokens
  static void init() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Log the request details
          printX("""
            *** API Request ***
            URL: ${options.uri}
            
            Method: ${options.method}
            
            Headers: ${options.headers}
            
            Request Body: ${options.data}
            
            Query Parameters: ${options.queryParameters}
          """);

          // Add Authorization token if available
          String? token = await SharedPreferenceService.getAccessTokenSecure();
          token ??= SharedPreferenceService.getAccessToken();
          if (token != "" && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options); // Continue the request
        },
        onResponse: (response, handler) {
          // Log the response details

          printX("""
            *** API Response ***
            Status Code: ${response.statusCode}
            
            Response Data: ${response.data}
           """);
          if (response.statusCode == 200) {
            try {
              // Initialize middlewares
              final middlewares = [
                KycMiddleware(),
                ProfileStatusMiddleware(),
                // Add other middlewares here if needed
              ];

              MiddlewareGroup(middlewares).handleResponse(response);
            } catch (e) {
              e.toString();
            }
          }

          return handler.next(response); // Continue the response
        },
        onError: (DioException error, handler) {
          // Log the error details
          printE("""
          *** API Error ***
          Error Message: ${error.message}
          Error Message: ${error.error}
          Error Message: ${error.type}
          Status Code: ${error.response?.statusCode}
          Error Data: ${error.response?.data}
          """);

          // Handle specific error cases, e.g., unauthorized
          if (error.response?.statusCode == 401) {
            printE('Unauthorized, redirecting to login...');
            AuthMiddleware().handleResponse(null);
          }

          return handler.next(error); // Continue the error handling
        },
      ),
    );
  }

  /// GET request
  static Future<ResponseModel> getRequest(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      await _attachAuthorizationToken();
      Response response = await _dio.get(endpoint, queryParameters: params);
      return ResponseModel(
        isSuccess: true,
        message: response.data.toString(),
        statusCode: response.statusCode ?? 200,
        responseJson: response.data,
      );
    } on DioException catch (e) {
      printE('GET request error: ${e.response?.statusCode}, ${e.message}');
      return ResponseModel(
        isSuccess: false,
        message: e.message ?? 'Error occurred',
        statusCode: e.response?.statusCode ?? 500,
        responseJson: e.response?.data.toString() ?? '',
      );
    }
  }

  /// POST request
  static Future<ResponseModel> postRequest(String endpoint, Map<String, dynamic>? data) async {
    try {
      await _attachAuthorizationToken();
      Response response = await _dio.post(endpoint, data: data);
      return ResponseModel(
        isSuccess: true,
        message: response.data.toString(),
        statusCode: response.statusCode ?? 200,
        responseJson: response.data,
      );
    } on DioException catch (e) {
      printE('POST request error: ${e.response?.statusCode}, ${e.message}');
      return ResponseModel(
        isSuccess: false,
        message: e.message ?? 'Error occurred',
        statusCode: e.response?.statusCode ?? 500,
        responseJson: e.response?.data.toString() ?? '',
      );
    }
  }

  /// PUT request
  static Future<ResponseModel> putRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      await _attachAuthorizationToken();
      Response response = await _dio.put(endpoint, data: data);
      return ResponseModel(
        isSuccess: true,
        message: response.data.toString(),
        statusCode: response.statusCode ?? 200,
        responseJson: response.data,
      );
    } on DioException catch (e) {
      printE('PUT request error: ${e.response?.statusCode}, ${e.message}');
      return ResponseModel(
        isSuccess: false,
        message: e.message ?? 'Error occurred',
        statusCode: e.response?.statusCode ?? 500,
        responseJson: e.response?.data.toString() ?? '',
      );
    }
  }

  /// DELETE request
  static Future<ResponseModel> deleteRequest(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      await _attachAuthorizationToken();
      Response response = await _dio.delete(endpoint, data: data);
      return ResponseModel(
        isSuccess: true,
        message: response.data.toString(),
        statusCode: response.statusCode ?? 200,
        responseJson: response.data,
      );
    } on DioException catch (e) {
      printE('DELETE request error: ${e.response?.statusCode}, ${e.message}');
      return ResponseModel(
        isSuccess: false,
        message: e.message ?? 'Error occurred',
        statusCode: e.response?.statusCode ?? 500,
        responseJson: e.response?.data.toString() ?? '',
      );
    }
  }

  /// Multipart POST request with dynamic keys for files
  static Future<ResponseModel> postMultiPartRequest(
    String endpoint,
    Map<String, dynamic> data,
    Map<String, File> files,
  ) async {
    try {
      await _attachAuthorizationToken();
      // Create a FormData object
      FormData formData = FormData();

      // Add the text fields to the FormData
      data.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      // Add files to the FormData with dynamic keys
      files.forEach((key, file) async {
        formData.files.add(
          MapEntry(
            key, // Dynamic key for each file
            await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
          ),
        );
      });

      // Make the POST request
      Response response = await _dio.post(endpoint, data: formData);
      return ResponseModel(
        isSuccess: true,
        message: response.data.toString(),
        statusCode: response.statusCode ?? 200,
        responseJson: response.data,
      );
    } on DioException catch (e) {
      printE('Multipart POST request error: ${e.response?.statusCode}, ${e.message}');
      return ResponseModel(
        isSuccess: false,
        message: e.message ?? 'Error occurred',
        statusCode: e.response?.statusCode ?? 500,
        responseJson: e.response?.data.toString() ?? '',
      );
    }
  }

  /// Download file from an endpoint
  static Future<ResponseModel> downloadFile(String url, String savePath) async {
    try {
      await _attachAuthorizationToken();
      printX("Downloading file from $url");

      // Start the download
      Response response = await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            printX("Download progress: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      return ResponseModel(
        isSuccess: true,
        message: "File downloaded successfully",
        statusCode: response.statusCode ?? 200,
        responseJson: response.data,
      );
    } on DioException catch (e) {
      printE('Download error: ${e.message}');
      return ResponseModel(
        isSuccess: false,
        message: e.message ?? 'Error occurred during file download',
        statusCode: e.response?.statusCode ?? 500,
        responseJson: e.response?.data.toString() ?? '',
      );
    }
  }
}
