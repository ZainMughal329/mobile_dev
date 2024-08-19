import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lesedi/network/app_exceptions.dart';

class NetworkApi {
  static NetworkApi? _instance;
  static final Dio _dio = Dio();

  NetworkApi._();

  static NetworkApi get instance {
    _instance ??= NetworkApi._();
    return _instance!;
  }

  Future get(
      {required String url,
      Map<String, dynamic>? params,
      required Map<String, dynamic> customHeader}) async {
    printFunc(methodType: "GET", url: url, apiHeader: customHeader);
    try {
      final response = await _dio.get(
        url,
        queryParameters: params,
        options: Options(
          headers: customHeader,
          sendTimeout: const Duration(milliseconds: 22000), //_defaultTimeout,
          receiveTimeout:
              const Duration(milliseconds: 22000), //_defaultTimeout,
        ),
      );

      return returnResponse(response);
    } on DioException catch (e) {
      throw DioExceptionError(_getDioExceptionErrorMessage(e));
    }
  }

  Future post({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, dynamic> customHeader,
    MapEntry<String, List<File>>? files,
  }) async {
    printFunc(
        methodType: "POST", url: url, apiHeader: customHeader, body: body);
    Response<dynamic> response;

    try {
      dynamic data;
      if (files != null) {
        FormData formData = FormData();
        body.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });

        for (var fileEntry in files.value) {
          String fileName = fileEntry.path.split('/').last;

          formData.files.add(
            MapEntry(
              files.key,
              await MultipartFile.fromFile(fileEntry.path, filename: fileName),
            ),
          );
        }
        data = formData;
        print("form data =${formData.files}");
      } else {
        data = body;
      }

      response = await _dio.post(
        url,
        data: data,
        options: Options(
          sendTimeout: const Duration(milliseconds: 220000),
          receiveTimeout: const Duration(milliseconds: 220000),
          headers: customHeader,
        ),
      );

      return returnResponse(response);
    } on DioException catch (e) {
      throw DioExceptionError(_getDioExceptionErrorMessage(e));
    }
  }

  Future postFormData({
    required String url,
    required FormData formData,
    required Map<String, dynamic> customHeader,
  }) async {
    try {
      Response<dynamic> response = await _dio.post(
        url,
        data: formData,
        options: Options(
          sendTimeout: const Duration(milliseconds: 22000),
          receiveTimeout: const Duration(milliseconds: 22000),
          headers: customHeader,
        ),
      );
      return returnResponse(response);
    } on DioException catch (e) {
      throw DioExceptionError(_getDioExceptionErrorMessage(e));
    }
  }

  Future patch({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, dynamic> customHeader,
    List<MapEntry<String, File>>? files,
  }) async {
    printFunc(
        methodType: "PATCH", url: url, apiHeader: customHeader, body: body);
    Response<dynamic> response;

    try {
      dynamic data;
      if (files != null && files.isNotEmpty) {
        FormData formData = FormData();
        body.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });

        for (var fileEntry in files) {
          String fileName = fileEntry.value.path.split('/').last;
          log("fileEntry key : ${fileEntry.key}       fileEntry value:${fileEntry.value.path}");
          formData.files.add(
            MapEntry(
              fileEntry.key,
              await MultipartFile.fromFile(fileEntry.value.path,
                  filename: fileName),
            ),
          );
        }
        data = formData;
      } else {
        data = body;
      }

      response = await _dio.patch(
        url,
        data: data,
        options: Options(
          sendTimeout: const Duration(milliseconds: 22000),
          receiveTimeout: const Duration(milliseconds: 22000),
          headers: customHeader,
        ),
      );

      return returnResponse(response);
    } on DioException catch (e) {
      throw DioExceptionError(_getDioExceptionErrorMessage(e));
    }
  }

  Future put({
    required String url,
    required Map<String, dynamic> body,
    required Map<String, dynamic> customHeader,
    List<MapEntry<String, File>>? files,
  }) async {
    printFunc(methodType: "PUT", url: url, apiHeader: customHeader, body: body);
    if (customHeader != null) {
      log("customHeader = $customHeader");
    }
    Response<dynamic> response;

    try {
      dynamic data;
      if (files != null && files.isNotEmpty) {
        FormData formData = FormData();
        body.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });

        for (var fileEntry in files) {
          String fileName = fileEntry.value.path.split('/').last;
          log("fileEntry key : ${fileEntry.key}       fileEntry value:${fileEntry.value.path}");
          formData.files.add(
            MapEntry(
              fileEntry.key,
              await MultipartFile.fromFile(fileEntry.value.path,
                  filename: fileName),
            ),
          );
        }
        data = formData;
      } else {
        data = body;
      }

      response = await _dio.put(
        url,
        data: data,
        options: Options(
          sendTimeout: const Duration(milliseconds: 22000),
          receiveTimeout: const Duration(milliseconds: 22000),
          headers: customHeader,
        ),
      );

      return returnResponse(response);
    } on DioException catch (e) {
      log(e.toString());
      throw DioExceptionError(_getDioExceptionErrorMessage(e));
    }
  }

  String _getDioExceptionErrorMessage(DioException exception) {
    if (kDebugMode) {
      log(
        "Exception type : ${exception.type}, Response: ${exception.response?.data}",
      );
    }
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timed out";
      case DioExceptionType.receiveTimeout:
        return "Receive timed out";
      case DioExceptionType.sendTimeout:
        return "Send timed out";
      case DioExceptionType.cancel:
        return "Request cancelled";
      case DioExceptionType.badCertificate:
        return "Invalid certificate";
      case DioExceptionType.badResponse:
        return exception.response?.data['message'] ?? "Bad response";
      case DioExceptionType.connectionError:
        return "Connection error";
      case DioExceptionType.unknown:
        return "Unknown error";
      default:
        return "Unknown error";
    }
  }

  dynamic returnResponse(Response<dynamic> response) {
    if (kDebugMode) {
      log("Status Code: ${response.statusCode}, Response: ${response.data}");
    }
    switch (response.statusCode) {
      case 200:
      case 201:
        dynamic jsonResponse = response.data;
        return jsonResponse;
      case 404:
        throw BadRequestException(response.statusMessage);
      case 401:
        throw BadRequestException(response.statusMessage);
      case 443:
      case 500:
        throw InternalServerError(jsonDecode(response.data)['message']);
      case 400:
        {
          dynamic jsonResponse = jsonDecode(response.data);
          throw InvalidInputException(jsonResponse['message']);
        }
      default:
        throw FetchDataException(response.statusMessage);
    }
  }

  void printFunc(
      {required String methodType,
      required String url,
      Map<String, dynamic>? body,
      required Map<String, dynamic> apiHeader}) {
    debugPrint(
        "------------------------- $methodType ---------------------------");
    debugPrint(" url = $url");
    if (body != null) debugPrint("body = $body");
    debugPrint("header = $apiHeader");

    debugPrint(
        "-------------------------------------------------------------------");
  }
}
