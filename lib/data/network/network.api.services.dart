import 'dart:convert';

import 'package:attendance_system_app/data/exception/app.excepton.dart';
import 'package:attendance_system_app/data/network/base.api.services.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkApiClass extends BaseNetworkApi {
  @override
  Future<dynamic> postApi(String url, Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(url), body: body);

      if (kDebugMode) {
        print("Request URL: $url");
        print("Request Body: $body");
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }

      return handleApiResponse(response);
    } catch (e) {
      if (kDebugMode) {
        print("Network Exception: ${e.toString()}");
      }
      rethrow;
    }
  }

  dynamic handleApiResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body;

    try {
      final json = jsonDecode(responseBody);

      switch (statusCode) {
        case 200:
          return json;

        case 404:
          throw BadRequestException(json['message'] ?? 'Bad Request');

        case 401:
          throw AppException(
            message: json['message'] ?? "Unauthorized",
          );

        case 500:
          throw ServerException(json['message'] ?? 'Internal Server Error');

        default:
          throw AppException(
            message: json['message'] ?? 'Unexpected error: $statusCode',
          );
      }
    } catch (e) {
      throw AppException(message: responseBody, prefix: 'Parse Error: ');
    }
  }
}
