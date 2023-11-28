// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scc_web/helper/app_exception.dart';
import 'package:scc_web/helper/constant.dart';


class NetworkUtil {
  static final NetworkUtil _instance = NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  Future<dynamic> post(String url, {Map<String, dynamic>? body, Map<String, String>? headers, Map<String, String>? param, encoding}) async {
    String jsonBody = jsonEncode(body);
    // print(url);
    // print(jsonBody);
    Map<String, String> headerJson = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      // "Access-Control-Allow-Credentials":
      //     "true", // Required for cookies, authorization headers with HTTPS
      // "Access-Control-Allow-Headers":
      //     "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      // "Access-Control-Allow-Methods": "POST, OPTIONS, GET, PUT, PATCH, DEL",
      dotenv.get('hubKey'): dotenv.get('hubValue'),
      dotenv.get('clientKey'): dotenv.get('clientValue'),
    };
    if (headers != null) {
      headerJson.addAll(headers);
    }
    return await http
        .post(_setParameter(url, param), headers: headerJson, body: jsonBody, encoding: encoding)
        .then((http.Response response) => _returnResponse(response));
  }

  Future<dynamic> put(String url, {Map<String, dynamic>? body, Map<String, String>? headers, Map<String, String>? param, encoding}) async {
    String jsonBody = jsonEncode(body);
    Map<String, String> headerJson = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      // "Access-Control-Allow-Credentials":
      //     "true", // Required for cookies, authorization headers with HTTPS
      // "Access-Control-Allow-Headers":
      //     "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      // "Access-Control-Allow-Methods": "POST, OPTIONS, GET, PUT, PATCH, DEL",
      dotenv.get('hubKey'): dotenv.get('hubValue'),
      dotenv.get('clientKey'): dotenv.get('clientValue'),
    };
    if (headers != null) {
      headerJson.addAll(headers);
    }
    return await http
        .put(_setParameter(url, param), headers: headerJson, body: jsonBody, encoding: encoding)
        .then((http.Response response) => _returnResponse(response));
  }

  Future<dynamic> postGetHeader(String url, {Map<String, String>? body, Map<String, String>? headers, Map<String, String>? param, encoding}) async {
    String jsonBody = jsonEncode(body);
    Map<String, String> headerJson = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      // "Access-Control-Allow-Credentials":
      //     "true", // Required for cookies, authorization headers with HTTPS
      // "Access-Control-Allow-Headers":
      //     "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      // "Access-Control-Allow-Methods": "POST, OPTIONS, GET, PUT, PATCH, DEL",
      dotenv.get('hubKey'): dotenv.get('hubValue'),
      dotenv.get('clientKey'): dotenv.get('clientValue'),
    };
    if (headers != null) {
      headerJson.addAll(headers);
    }
    return await http
        .post(_setParameter(url, param), headers: headerJson, body: jsonBody, encoding: encoding)
        .then((http.Response response) => _returnResponseWithHeader(response));
  }

  Future<dynamic> posts(String url, {Map? body, Map<String, String>? headers, Map<String, String>? param, encoding}) async {
    //// print(headers);
    String jsonBody = jsonEncode(body);
    Map<String, String> headerJson = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      // "Access-Control-Allow-Credentials":
      //     "true", // Required for cookies, authorization headers with HTTPS
      // "Access-Control-Allow-Headers":
      //     "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      // "Access-Control-Allow-Methods": "POST, OPTIONS, GET, PUT, PATCH, DEL",
      dotenv.get('hubKey'): dotenv.get('hubValue'),
      dotenv.get('clientKey'): dotenv.get('clientValue'),
    };
    if (headers != null) {
      headerJson.addAll(headers);
    }
    return await http
        .post(_setParameter(url, param), headers: headerJson, body: jsonBody, encoding: encoding)
        .then((http.Response response) => _returnResponse(response));
  }

  Future<dynamic> get(String url, {Map<String, String>? param, Map<String, String>? headers, encoding}) {
    Map<String, String> headerJson = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      // "Access-Control-Allow-Credentials":
      //     "true", // Required for cookies, authorization headers with HTTPS
      // "Access-Control-Allow-Headers":
      //     "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      // "Access-Control-Allow-Methods": "POST, OPTIONS, GET, PUT, PATCH, DEL",
      dotenv.get('hubKey'): dotenv.get('hubValue'),
      dotenv.get('clientKey'): dotenv.get('clientValue'),
    };
    if (headers != null) {
      headerJson.addAll(headers);
    }
    //// print(_setParameter(url, param));
    return http.get(_setParameter(url, param), headers: headerJson).then((http.Response response) => _returnResponse(response));
  }

  Future<dynamic> getImage(String url, {Map<String, String>? param, Map<String, String>? headers, encoding}) {
    Map<String, String> headerJson = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      // "Access-Control-Allow-Credentials":
      //     "true", // Required for cookies, authorization headers with HTTPS
      // "Access-Control-Allow-Headers":
      //     "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      // "Access-Control-Allow-Methods": "POST, OPTIONS, GET, PUT, PATCH, DEL",
      dotenv.get('hubKey'): dotenv.get('hubValue'),
      dotenv.get('clientKey'): dotenv.get('clientValue'),
    };
    if (headers != null) {
      headerJson.addAll(headers);
    }
    return http.get(_setParameter(url, param), headers: headerJson).then((http.Response response) => _returnResponseImage(response));
  }

  Future<dynamic> getWithHeader(String url, {Map<String, String>? param, Map<String, String>? headers, encoding}) {
    Map<String, String> headerJson = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      // "Access-Control-Allow-Credentials":
      //     "true", // Required for cookies, authorization headers with HTTPS
      // "Access-Control-Allow-Headers":
      //     "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      // "Access-Control-Allow-Methods": "POST, OPTIONS, GET, PUT, PATCH, DEL",
      dotenv.get('hubKey'): dotenv.get('hubValue'),
      dotenv.get('clientKey'): dotenv.get('clientValue'),
    };
    if (headers != null) {
      headerJson.addAll(headers);
    }
    return http.get(_setParameter(url, param), headers: headerJson).then((http.Response response) => _returnResponseWithHeader(response));
  }

  // http.Request("", Uri());

  Future<dynamic> freeReq(String method, String url,
      {Map<String, dynamic>? body, Map<String, String>? headers, Map<String, String>? param, encoding}) async {
    switch (method) {
      case Constant.get:
        return get(
          url,
          param: param,
          headers: headers,
        );
      case Constant.post:
        return post(
          url,
          param: param,
          body: body,
          headers: headers,
        );
      case Constant.put:
        return put(
          url,
          param: param,
          body: body,
          headers: headers,
        );
      case Constant.delete:
        return delete(
          url,
          param: param,
          headers: headers,
        );
      // case Constant.PATCH:
      //   return patch(
      //     url,
      //     body: body,
      //     param: param,
      //     headers: headers,
      //   );
      default:
        throw BadRequestException("Failed to recognise method");
    }
  }

  Future<dynamic> multipartOneFile(String req, String url,
      {Uint8List? bytes, String? fileName, Map<String, String>? headers, Map<String, String>? param, Map<String, String>? body, encoding}) async {
    Map<String, String> headerJson = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      // "Access-Control-Allow-Credentials":
      //     "true", // Required for cookies, authorization headers with HTTPS
      // "Access-Control-Allow-Headers":
      //     "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      // "Access-Control-Allow-Methods": "POST, OPTIONS, GET, PUT, PATCH, DEL",
      dotenv.get('hubKey'): dotenv.get('hubValue'),
      dotenv.get('clientKey'): dotenv.get('clientValue'),
    };
    if (headers != null) {
      headerJson.addAll(headers);
    }
    Uri uri = _setParameter(url, param);
    var request = http.MultipartRequest(req, uri);
    request.headers.addAll(headerJson);

    if (bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName ?? "",
        ),
      );
    }
    if (body != null && body.isNotEmpty) request.fields.addAll(body);
    // ? SENDING REQ
    http.StreamedResponse? response;
    String? responseGetter;
    await request.send().then((value) async {
      response = value;
      responseGetter = await response!.stream.bytesToString();
    });
    // final responseGetter = await response.stream.bytesToString();
    if (response != null) {
      switch (response!.statusCode) {
        case 200:
          Map responseJson = {};
          var responseHeader = response!.headers;
          responseJson.addAll(responseHeader);

          if (responseGetter != null) {
            var responseBody = jsonDecode(responseGetter!);
            if (responseBody is Map) responseJson.addAll(responseBody);
          }
          return responseJson;
        case 400:
          Map responseJson = {};
          responseJson.addAll(response!.headers);
          if (responseGetter != null) {
            var responseBody = jsonDecode(responseGetter!);
            responseJson.addAll(responseBody);
          }
          var message = responseJson['message'];
          throw BadRequestException('$message');
        case 401:
          throw RefreshTokenFailedException('Response 401');
        case 403:
          throw UnauthorisedException(response!.headers.toString());
        case 500:
          Map responseJson = {};
          responseJson.addAll(response!.headers);
          if (responseGetter != null) {
            var responseBody = jsonDecode(responseGetter!);
            responseJson.addAll(responseBody);
          }
          var message = responseJson['message'];
          throw FetchDataException('Error 500 : $message');
        default:
          throw FetchDataException('Error occured while Communication with Server with StatusCode : ${response!.statusCode}');
      }
    }
  }

  Future<dynamic> delete(String url, {Map<String, String>? headers, Map<String, String>? param, encoding}) async {
    Map<String, String> headerJson = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      // "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      // "Access-Control-Allow-Credentials":
      //     "true", // Required for cookies, authorization headers with HTTPS
      // "Access-Control-Allow-Headers":
      //     "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      // "Access-Control-Allow-Methods": "POST, OPTIONS, GET, PUT, PATCH, DEL",
      dotenv.get('hubKey'): dotenv.get('hubValue'),
      dotenv.get('clientKey'): dotenv.get('clientValue'),
    };
    if (headers != null) {
      headerJson.addAll(headers);
    }
    return await http.delete(_setParameter(url, param), headers: headerJson).then((http.Response response) => _returnResponse(response));
  }

  dynamic _returnResponseWithHeader(http.Response response) {
    switch (response.statusCode) {
      case 200:
        Map responseJson = {};
        var responseBody = jsonDecode(response.body.toString());
        var responseHeader = response.headers;
        if (responseBody is Map) {
          responseJson.addAll(responseBody);

          responseJson.addAll(responseHeader);
        }
        dynamic returnThis;
        if (responseJson == {}) {
          returnThis = responseBody;
        } else {
          returnThis = responseJson;
        }
        return returnThis;
      case 400:
        var responseJson = jsonDecode(response.body.toString());
        throw BadRequestException(responseJson['message']);
      case 401:
        throw RefreshTokenFailedException('Response 401');
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        var responseJson = jsonDecode(response.body.toString());
        throw FetchDataException(responseJson['message']);
      default:
        throw FetchDataException('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  dynamic _returnResponseImage(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson;

        responseJson = response.body;

        return responseJson;
      case 400:
        var responseJson = jsonDecode(response.body.toString());
        throw BadRequestException(responseJson['message']);
      case 401:
        throw RefreshTokenFailedException('Response 401');
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        var responseJson = jsonDecode(response.body.toString());
        throw FetchDataException(responseJson['message']);
      default:
        throw FetchDataException('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson;
        if (response.body.isNotEmpty) {
          responseJson = jsonDecode(response.body.toString());
        } else {
          responseJson = response.body;
        }
        return responseJson;
      case 400:
        var responseJson = jsonDecode(response.body.toString());
        throw BadRequestException(responseJson['message']);
      case 401:
        throw RefreshTokenFailedException('Response 401');
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        var responseJson = jsonDecode(response.body.toString());
        throw FetchDataException(responseJson['message']);
      default:
        throw FetchDataException('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Uri _setParameter(String url, Map<String, dynamic>? param) {
    int count = 0;
    if (param != null) {
      if (!url.endsWith('?')) {
        url = '$url?';
      }
      param.forEach((key, value) {
        if (count == 0) {
          url = '$url$key=$value';
          count++;
        } else {
          url = '$url&$key=$value';
        }
      });
    }
    return Uri.parse(url);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
