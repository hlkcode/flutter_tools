/** todo install get package and uncomment code below **/
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get_connect/connect.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../utilities/extension_methods.dart';
import '../utilities/utils.dart';

class RequestManager extends GetConnect {
  dynamic _checkError(Response response, bool returnBodyOnError) {
    logInfo(response.statusText);
    logInfo('error body ${response.body ?? "no error body found ..."}');
    logInfo(response);

    final HttpStatus status = response.status;
    final String errorCode =
        'Code ${response.statusCode}: ${response.statusText}';

    if (returnBodyOnError) {
      return response.body ?? errorCode;
    } else if (response.statusText!.containsIgnoreCase('HandshakeException')) {
      throw const HandshakeException('Unable to reach server, retry shortly');
    } else if (status.connectionError ||
        response.statusText!.containsIgnoreCase('SocketException')) {
      throw const SocketException('Slow or no internet detected');
    } else if (status.isUnauthorized) {
      throw HttpException('Not authorized to make request.\n$errorCode');
    } else if (status.isForbidden) {
      throw HttpException('Not allowed to make request.\n$errorCode');
    } else if (status.isNotFound) {
      throw HttpException(
          'Unable to access requested resource, feature may not be available.\n$errorCode');
    } else if (status.isServerError) {
      throw HttpException('Unable to handle requested resource.\n$errorCode');
    } /*else {
      throw Exception('Sorry, something went wrong.\n$errorCode');
    }*/
  }

  Future<dynamic> sendGetRequest(String url,
      {Map<String, String>? headers,
      Map<String, dynamic>? query,
      bool returnBodyOnError = false}) async {
    logInfo('RequestManager url = $url');
    super.timeout = const Duration(minutes: 1);
    final response = await super.get(url, headers: headers, query: query);
    if (!response.isOk) _checkError(response, returnBodyOnError);
    return response.body;
  }

  Future<dynamic> sendPostRequest(String url, Object? body,
      {Map<String, String>? headers,
      Map<String, dynamic>? query,
      bool returnBodyOnError = false}) async {
    logInfo('RequestManager url = $url');
    super.timeout = const Duration(minutes: 1);
    final response =
        await super.post(url, body, headers: headers, query: query);
    if (!response.isOk) _checkError(response, returnBodyOnError);
    return response.body;
  }

  Future<dynamic> sendUpdateRequest(String url, Object body,
      {Map<String, String>? headers,
      Map<String, dynamic>? query,
      bool returnBodyOnError = false}) async {
    super.timeout = const Duration(minutes: 1);
    final response = await super.put(url, body, headers: headers, query: query);
    if (!response.isOk) _checkError(response, returnBodyOnError);
    return response.body;
  }

  Future<dynamic> sendDeleteRequest(String url, Object body,
      {Map<String, String>? headers,
      Map<String, dynamic>? query,
      bool returnBodyOnError = false}) async {
    logInfo('RequestManager url = $url');
    super.timeout = const Duration(minutes: 1);
    final response = await super.delete(url, headers: headers, query: query);
    if (!response.isOk) _checkError(response, returnBodyOnError);
    return response.body;
  }

  Future<dynamic> uploadFileWithData(
    String url,
    FormData formData, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    bool isInBackground = false,
    bool returnBodyOnError = false,
  }) async {
    logInfo('RequestManager url = $url');
    // FormData(
    //   {
    //     "type": record.type,
    //     "dateTaken": record.dateTaken?.toIso8601String(),
    //     "meetingId": record.meetingId,
    //     "sessionDate": record.sessionDate?.toIso8601String(),
    //     "sessionId": record.sessionId,
    //     "file": MultipartFile(file, filename: record.fileName.toString())
    //   },
    // ),
    if (headers != null) {
      headers.removeWhere(
          (key, value) => value.containsIgnoreCase('application/json'));
    }
    super.timeout =
        isInBackground ? const Duration(days: 1) : const Duration(hours: 1);
    final response =
        await super.post(url, formData, headers: headers, query: query);
    if (!response.isOk) _checkError(response, returnBodyOnError);
    return response.body;
  }

  Future<dynamic> uploadFile1(
    String url,
    String fileName,
    Uint8List byteArray, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    bool isInBackground = false,
    bool returnBodyOnError = false,
  }) async {
    logInfo('RequestManager url = $url');
    if (headers != null) {
      headers.removeWhere(
          (key, value) => value.containsIgnoreCase('application/json'));
    }
    super.timeout =
        isInBackground ? const Duration(days: 1) : const Duration(hours: 1);
    final form =
        FormData({'file': MultipartFile(byteArray, filename: fileName)});
    final response =
        await super.post(url, form, headers: headers, query: query);
    if (!response.isOk) _checkError(response, returnBodyOnError);
    return response.body;
  } // File

  Future<dynamic> uploadFile2(String url, String fileName, File file,
      {Map<String, String>? headers,
      Map<String, dynamic>? query,
      bool isInBackground = false,
      bool returnBodyOnError = false}) async {
    logInfo('RequestManager url = $url');
    if (headers != null) {
      headers.removeWhere(
          (key, value) => value.containsIgnoreCase('application/json'));
    }
    super.timeout =
        isInBackground ? const Duration(days: 1) : const Duration(hours: 1);
    final byteArray = await fileToByteArrayAsync(file.path);
    final form =
        FormData({'file': MultipartFile(byteArray, filename: fileName)});
    final response =
        await super.post(url, form, headers: headers, query: query);
    if (!response.isOk) _checkError(response, returnBodyOnError);
    return response.body;
  }

//SocketException: OS Error: Connection timed out, errno = 110, address = reqres.in, port = 44296
}
