import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_practical/API/custom_exception.dart';
import 'package:weather_app_practical/weather/Model/error_model.dart';

/// Manages API calls and responses.
class APIManager {
  /// Makes an ASYNC GET API call to the provided URL.
  Future<dynamic> getAPICall(String url) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url));
      responseJson = _response(response);
    } on SocketException catch (e) {
      print("exception ::::: $e");
    } on TimeoutException catch (_) {
      throw FetchDataException('Server Error');
    } finally {}
    return responseJson;
  }

  /// Handles API response based on HTTP status codes and throws exceptions for various cases.
  static _response(http.Response response) {
    switch (response.statusCode) {
      /// Successfully get api response
      case 200:
        if (json.decode(response.body)['status'] == 0) {
          throw BadRequestException(ErrorModel.fromJson(json.decode(response.body.toString())).message);
        } else {
          var responseJson = json.decode(response.body.toString());
          return responseJson;
        }

      /// Successfully post api response
      case 201:
        if (json.decode(response.body)['status'] == 0) {
          throw BadRequestException(ErrorModel.fromJson(json.decode(response.body.toString())).message);
        } else {
          var responseJson = json.decode(response.body.toString());
          return responseJson;
        }

      /// Bad request
      case 400:
        throw BadRequestException(ErrorModel.fromJson(json.decode(response.body.toString())).message);

      case 404:
        throw BadRequestException(ErrorModel.fromJson(json.decode(response.body.toString())).message);

      /// Bad request
      case 401:
        throw BadRequestException(ErrorModel.fromJson(json.decode(response.body.toString())).message);

      /// Authorisation token invalid
      case 403:
        throw UnauthorisedException(ErrorModel.fromJson(json.decode(response.body.toString())).message);

      /// Authorisation token invalid
      case 417:
        throw UnauthorisedException(ErrorModel.fromJson(json.decode(response.body.toString())).message);

      /// Error occurred while Communication with Server
      case 500:
      default:
        throw FetchDataException('Error occurred while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
