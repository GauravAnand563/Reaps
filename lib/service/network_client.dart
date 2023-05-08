import 'dart:convert';

import 'package:dio/dio.dart';
import '../configs/constants.dart';
import '../utils/logger.dart';

enum RequestType {
  ///Use for `GET` method in network calls
  get,

  ///Use for `POST` method in network calls
  post,
}

/// For http request using `Dio`
class NetworkClient {
  static const baseUrl = ApiConstants.baseUrl;

  static final Dio _dioClient = Dio();

  static _getHeaders(String? token) {
    DioErrorType.cancel;
    Map<String, String> headers = {
      ApiConstants.contentType: ApiConstants.applicationJson,
    };
    //add token
    if (token != null) {
      headers.addAll({
        ApiConstants.authorization: 'Bearer $token',
      });
    }
    return headers;
  }

  static _handleResponse(Response response) {
    if (response.statusCode == 200) {
      final jsonResponseData = response.data;
      return jsonResponseData;
    }
  }

  ///This function returns the `JSON Object`
  ///of the response body
  static Future request({
    required RequestType type,
    required String endPoint,
    Object? body,
    String? token,
    String? filePath,
  }) async {
    try {
      Map<String, String> headers = _getHeaders(token);
      Response response;

      switch (type) {
        case RequestType.get:
          response = await _dioClient.get(
            '$baseUrl$endPoint',
            options: Options(headers: headers),
          );
          break;
        case RequestType.post:
          if (body == null) {
            throw Exception("Body is missing");
          }
          response = await _dioClient.post(
            '$baseUrl$endPoint',
            data: jsonEncode(body),
            options: Options(headers: headers),
          );
          break;
      }
      logger.d("Success : (${response.statusCode})\n[$endPoint]");
      return _handleResponse(response);
    } on DioError catch (dioError) {
      logger.e('${dioError.type} : ${dioError.message}');
      return _handleResponse(dioError.response!);
    } catch (ex) {
      logger.e(ex.toString());
    }
  }
}
