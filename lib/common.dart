import 'package:flutter/material.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'utilities/utils.dart';

const Color kPrimaryColor = Colors.blue;
const Color kAccentColor = Colors.amber;

const Color kErrorColor = Color(0xCCDC3232);
const Color kSuccessColor = Color(0xFF78E000);

Future<bool> initStorage([String container = 'GetStorage']) async =>
    await GetStorage.init(container);

GetStorage get storage => GetStorage();

dynamic get user => storage.read(Constants.USER);

dynamic get userData => storage.read(Constants.USER_DATA);

Map<String, String> get headers {
  final uData = storage.read(Constants.USER_DATA);
  final token = uData[Constants.TOKEN_KEY];
  // logInfo('token = $token');
  return getHeaders(token ?? '');
}

bool isLoggedIn({bool logToken = false}) {
  final uData = storage.read(Constants.USER_DATA);
  if (uData == null) return false;
  final token = uData[Constants.TOKEN_KEY] ?? '';
  if (logToken) logInfo('isLoggedIn: token => $token');
  return !GetUtils.isNullOrBlank(token)! && !JwtDecoder.isExpired(token);
}

class Constants {
  static const String TOKEN_KEY = 'token';
  static const String USER = 'user';
  static const String USER_DATA = 'userData';
}
