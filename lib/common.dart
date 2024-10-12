import 'package:flutter/material.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'utilities/utils.dart';

const Color kPrimaryColor = Colors.blue;
const Color kAccentColor = Colors.amber;

const Color kErrorColor = Color(0xCCDC3232);
const Color kSuccessColor = Color(0xFF78E000);

dynamic get user => GetStorage().read(Constants.USER);
int get timeZoneOffset => DateTime.now().toLocal().timeZoneOffset.inHours;

const numberPerPage = 10;

dynamic get userData => GetStorage().read(Constants.USER_DATA);
Map<String, String> get headers {
  final uData = GetStorage().read(Constants.USER_DATA);
  final token = uData[Constants.TOKEN_KEY];
  // logInfo('token = $token');
  return getHeaders(token ?? '');
}

bool isLoggedIn() {
  final String token =
      GetStorage().hasData('user') ? user[Constants.TOKEN_KEY] : '';
  return !GetUtils.isNullOrBlank(token)! && !JwtDecoder.isExpired(token);
}

class Constants {
  static const String TOKEN_KEY = 'token';
  static const String USER = 'user';
  static const String USER_DATA = 'userData';
}
