import 'dart:async';
import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import '/tools_models.dart';
import '../common.dart';
import '../ui/widgets.dart';

String? requiredValidator(String? text) =>
    (text == null || text.isEmpty) ? 'Field is required' : null;

String? phoneNumberValidator(String? text) =>
    GetUtils.isPhoneNumber(getString(text)) ? null : 'Invalid Phone Number';

String? emailValidator(String? text) =>
    GetUtils.isEmail(getString(text)) ? null : 'Invalid Email';

Future<Map> getDeviceInfo() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final map = deviceInfo.toMap();
  //logInfo(map);
  return map;
}

Future<String> getDeviceId() async {
  final deviceInfo = await DeviceInfoPlugin().deviceInfo;
  final map = deviceInfo.toMap();
  return '${map['brand']}...${map['device']}...${map['id']}...${map['androidId']}';
}

Future<void> validatePermission(
    Permission permission, Function actionToRun) async {
  var name =
      permission.toString().split('.').reversed.join(' ').capitalizeFirst!;
  if (await permission.request().isGranted) {
    actionToRun();
  } else {
    var status = await permission.status;
    if (status.isDenied) {
      HlkDialog.showHorizontalDialog(
        title: 'Permission Required',
        negativeAction: () => Get.back(),
        positiveAction: () async {
          Get.back();
          //await permission.request();
          await openAppSettings();
        },
        yesLabel: 'Allow',
        noLabel: 'Cancel',
        qMessage:
            '$name is not granted, so we cant proceed. Would you like to grant access ?',
      );
    }
  }
}

void closeKeyboard() {
  // Get.focusScope!.unfocus();
  // Get.focusScope!.requestFocus(FocusNode());

  FocusNode? currentFocus = Get.focusScope;

  if (!getBoolean(currentFocus?.hasPrimaryFocus)) {
    FocusManager.instance.primaryFocus?.unfocus();
    currentFocus?.unfocus();
  }
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

Map<String, String> getHeaders(String token) => <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

void byteArrayToFile(List<int> byteArray, File fileToWriteTo,
        {bool isAsync = false}) async =>
    isAsync
        ? await fileToWriteTo.writeAsBytes(byteArray, flush: true)
        : fileToWriteTo.writeAsBytesSync(byteArray, flush: true);

String sanitizeBase64String(String base64String) =>
    base64String.trim().contains('base64,')
        ? base64String.trim().substring(base64String.indexOf(',') + 1)
        : base64String.trim();

String sanitizeUrl(String url, {bool isSecure = true}) {
  String newUrl = '';
  if (isSecure) {
    newUrl = url.startsWith('https') ? url : url.replaceFirst('http', 'https');
  } else {
    newUrl = url.startsWith('https') ? url.replaceFirst('https', 'http') : url;
  }
  return newUrl;
}

Future<Uint8List> fileToByteArrayAsync(String filePath) async =>
    await Io.File(filePath).readAsBytes();

Uint8List fileToByteArray(String filePath) =>
    Io.File(filePath).readAsBytesSync();

String byteArrayToBase64(List<int> bytes) => base64.encode(bytes);

Uint8List base64ToByteArray(String base64String) => base64.decode(base64String);
List<int> base64ToByteArray2(String base64String) =>
    base64.decode(base64String);

void logInfo(dynamic info) {
  if (kDebugMode) {
    print(info);
  }
}

Widget verticalSpace(double space) {
  return SizedBox(
    height: getHeight(space),
  );
}

Widget horizontalSpace(double space) {
  return SizedBox(
    width: getWidth(space),
  );
}

double getDisplayHeight({PreferredSizeWidget? appBar}) => appBar == null
    ? Get.height - Get.mediaQuery.padding.top
    : Get.height - Get.mediaQuery.padding.top - appBar.preferredSize.height;

double getDisplayWidth() => Get.width;

double getWidth(double value) => getDisplayWidth() * value;

double getHeight(double value) => getDisplayHeight() * value;

String limitedWord(String word, int limit) => word.trim().length <= limit
    ? word.trim()
    : word.trim().substring(0, limit + 1).replaceRange(limit - 2, null, '..');

bool getBoolean(bool? data) => data ?? false;

num getNumber(num? data) => data ?? 0;

String getString(String? data) => data ?? '';

List getList(List? data) => data ?? List.empty();

Map getMap(Map? data) => data ?? {};

void handleException(dynamic e,
    [Function(dynamic e)? onError, bool showDialog = false]) {
  logInfo("hlk-error: ${e.toString()}");
  if (onError != null) {
    onError(e);
  } else if (showDialog) {
    if (e is SocketException || e is HttpException || e is HandshakeException) {
      //showErrorDialog(message: 'Kindly Check your internet connection');
      HlkDialog.showErrorSnackBar(e.message);
    } else {
      HlkDialog.showErrorSnackBar(e.toString());
    }
  }
}

void wrapFunctionToHandleException(Function toExecute,
    [Function(dynamic e)? onError, bool showDialog = false]) async {
  try {
    await toExecute();
  } catch (e) {
    handleException(e, onError, showDialog);
  }
}

class HlkDialog {
  static Future<void> showDialogBox({
    String title = '',
    required Widget content,
    String yesLabel = 'Yes',
    String noLabel = 'No',
    VoidCallback? yesVoidCallBack,
    VoidCallback? noVoidCallBack,
    bool canDismiss = true,
  }) async {
    await Get.defaultDialog(
      title: title,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          content,
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: LoadingButton(
                  onTapped: () =>
                      noVoidCallBack != null ? noVoidCallBack() : Get.back(),
                  text: noLabel,
                  isLoading: false,
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LoadingButton(
                  onTapped: () =>
                      yesVoidCallBack != null ? yesVoidCallBack() : Get.back(),
                  text: yesLabel,
                  isLoading: false,
                ),
              ),
            ],
          ),
        ],
      ),
      radius: 5,
      barrierDismissible: canDismiss,
      buttonColor: Get.isDarkMode ? kAccentColor : kPrimaryColor,
      backgroundColor: Get.theme.dialogBackgroundColor,
    );
  }

  static void showVerticalDialog({
    String title = 'Confirmation',
    String qMessage = 'Are you sure you want to perform this action',
    String positiveText = 'Yes',
    String negativeText = 'No',
    Function? positiveAction,
    Function? negativeAction,
    bool canDismiss = true,
  }) async =>
      await Get.defaultDialog(
        radius: 8,
        title: title,
        titlePadding: const EdgeInsets.only(top: 10),
        contentPadding: const EdgeInsets.all(16),
        backgroundColor: Get.theme.dialogBackgroundColor,
        barrierDismissible: canDismiss,
        content: Center(
          child: Text(
            qMessage,
            textAlign: TextAlign.center,
            //style: TextStyle(color: Colors.redAccent),
          ),
        ),
        confirm: LoadingButton(
          onTapped: () =>
              positiveAction != null ? positiveAction() : Get.back(),
          text: positiveText,
          isLoading: false,
          isOutlined: false,
        ),
        cancel: LoadingButton(
          onTapped: () =>
              negativeAction != null ? negativeAction() : Get.back(),
          text: negativeText,
          isLoading: false,
          isOutlined: true,
        ),
      );

  static Future<void> showHorizontalDialog({
    String title = 'Confirmation',
    String qMessage = 'Are you sure you want to perform this action',
    String yesLabel = 'Yes',
    String noLabel = 'No',
    Function? positiveAction,
    Function? negativeAction,
    bool canDismiss = true,
  }) async {
    await Get.defaultDialog(
      title: title,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(qMessage, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: LoadingButton(
                  onTapped: () =>
                      negativeAction != null ? negativeAction() : Get.back(),
                  text: noLabel,
                  isLoading: false,
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LoadingButton(
                  onTapped: () =>
                      positiveAction != null ? positiveAction() : Get.back(),
                  text: yesLabel,
                  isLoading: false,
                ),
              ),
            ],
          ),
        ],
      ),
      radius: 5,
      barrierDismissible: canDismiss,
      buttonColor: Get.isDarkMode ? kAccentColor : kPrimaryColor,
      backgroundColor: Get.theme.dialogBackgroundColor,
    );
  }

  static void showSnackBar(
          {String title = '', required String message, Color? color}) =>
      Get.snackbar(
        title,
        message,
        backgroundColor: color,
        duration: const Duration(seconds: 10),
        mainButton: TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Get.back();
          },
        ),
      );

  static void showErrorSnackBar(String error,
      {String title = 'Error', SnackPosition position = SnackPosition.TOP}) {
    Get.rawSnackbar(
      title: title,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: kErrorColor,
      borderRadius: 4,
      messageText: Text(
        error,
        maxLines: 30,
        textAlign: TextAlign.left,
        style: const TextStyle(
          //   color: Colors.white,
          fontSize: 16,
        ),
      ),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeInOut,
      barBlur: 16,
      snackPosition: position,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 10),
      mainButton: TextButton(
        child: const Text('OK'),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

  static void showSuccessSnackBar(String message,
      {String title = 'Success',
      Color? color,
      SnackPosition position = SnackPosition.BOTTOM}) {
    Get.rawSnackbar(
      title: title,
      snackStyle: SnackStyle.FLOATING,
      // backgroundColor: Get.theme.dialogBackgroundColor,
      borderRadius: 4,
      messageText: Text(
        message,
        maxLines: 30,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: color,
        ),
      ),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeInOut,
      barBlur: 16,
      snackPosition: position,
      margin: const EdgeInsets.all(16),
    );
  }

  /// this can be useful for 3 actions and/or more
  static Future<T?> showMessageInAlertDialog<T>(
          {String title = '',
          required String message,
          required List<AlertDialogContent> dialogContent}) =>
      showDialog(
        context: Get.context!,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: dialogContent
              .map(
                (cnt) => TextButton(
                  onPressed: () => cnt.action(ctx),
                  child: Text(cnt.text),
                ),
              )
              .toList(),
        ),
      );
}

class MediaManager {
  static final ImagePicker _picker = ImagePicker();

  // Pick an image
  static Future<XFile?> selectImageFromGallery({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) =>
      _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

  // Capture a photo
  static Future<XFile?> openCameraToTakePicture({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) =>
      _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
}

// todo install sqflite package and uncomment code below // u will may need path packages too
class DBHelper {
  final String _dbName;
  late Database _database;
  Database get database => _database;

  DBHelper._internal(this._dbName);
  static DBHelper getInstance(String dbName) => DBHelper._internal(dbName);

  Future<String> getFullDBPathPath() async {
    var databasesPath = await getDatabasesPath();
    return join(databasesPath, _dbName);
  }

  Future<void> deleteCurrentDatabase() async {
    var path = await getFullDBPathPath();
    await deleteDatabase(path);
  }

  Future<Database> getDatabase(
      {List<String>? sqlQueriesToCreateTables,
      bool deleteExistingDb = false,
      int dbVersion = 1}) async {
    _database = await openDatabase(_dbName, version: dbVersion,
        onCreate: (Database db, int version) async {
      if (deleteExistingDb) {
        await deleteCurrentDatabase();
      }

      if (sqlQueriesToCreateTables != null) {
        for (var sql in sqlQueriesToCreateTables) {
          await db.execute(sql);
        }
      }
    });
    return _database;
  }

  Future<int> insert(String tableName, Map<String, dynamic> map) async {
    return await _database.insert(tableName, map);
  }

  Future<List<Map<String, dynamic>>> getAllDataFromTable(
      String tableName) async {
    return await _database.query(tableName);
  }

  Future<Map<String, dynamic>?> getSingleDataFromTable(
      {required String tableName,
      required String whereColumnName,
      required Object whereValue}) async {
    List<Map<String, Object?>> maps = await _database.query(tableName,
        columns: null, where: '$whereColumnName = ?', whereArgs: [whereValue]);
    return maps.isNotEmpty ? maps.first : null;
  }

  Future<int> delete(
      {required String tableName,
      required String whereColumnName,
      required Object whereValue}) async {
    return await _database.delete(tableName,
        where: '$whereColumnName = ?', whereArgs: [whereValue]);
  }

  Future<int> deleteAllFromTable(String tableName) async {
    return await _database.delete(tableName, where: null);
  }

  Future<int> update(
      {required String tableName,
      required String whereColumnName,
      required Object whereValue,
      required Map<String, dynamic> map}) async {
    return await _database.update(tableName, map,
        where: '$whereColumnName = ?', whereArgs: [whereValue]);
  }

  Future<void> close() async {
    await _database.close();
  }

// todo check example below to see how to use this class
/**

    class DBManager {
    static const String DB_NAME = 'GreatPlace.db';
    static const String PLACES_TABLE_NAME = 'Places';
    static const String COLUMN_ID = 'id';
    static const String COLUMN_TITLE = 'title';
    static const String COLUMN_LONG = 'longitude';
    static const String COLUMN_LAT = 'latitude';
    static final String _sql_create_places_table =
    'CREATE TABLE $PLACES_TABLE_NAME ($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_TITLE TEXT, $COLUMN_LONG REAL, $COLUMN_LAT REAL)';

    // todo run this in app first widget build // in MyApp build
    static Future<void> initiate() async {
    try {
    await DBHelper.getInstance(DB_NAME)
    .getDatabase(sqlQueriesToCreateTables: [_sql_create_places_table]);
    } catch (ex) {
    print(ex);
    }
    }

    static Future<bool> insertPlace(PlaceTest placeTest) async {
    try {
    return await DBHelper.getInstance(DB_NAME)
    .insert(PLACES_TABLE_NAME, placeTest.toMap()) >
    0;
    } catch (ex) {
    print(ex);
    }
    return false;
    }

    static Future<PlaceTest?> findPlaceById(int placeTestId) async {
    try {
    var map = await DBHelper.getInstance(DB_NAME).getSingleDataFromTable(
    tableName: PLACES_TABLE_NAME,
    whereColumnName: COLUMN_ID,
    whereValue: placeTestId);
    return map == null ? null : PlaceTest.fromMap(map);
    } catch (ex) {
    print(ex);
    }
    }

    static Future<List<PlaceTest>?> getAllPlaces() async {
    try {
    var map = await DBHelper.getInstance(DB_NAME)
    .getAllDataFromTable(PLACES_TABLE_NAME);
    return PlaceTest.parseToGetList(json.encode(map));
    } catch (ex) {
    print(ex);
    }
    return List.empty();
    }

    static Future<bool> deletePlace(int placeTestId) async {
    try {
    return await DBHelper.getInstance(DB_NAME).delete(
    tableName: PLACES_TABLE_NAME,
    whereColumnName: COLUMN_ID,
    whereValue: placeTestId) >
    0;
    } catch (ex) {
    print(ex);
    }
    return false;
    }

    static Future<bool> updatePlace(
    int idToUpdate, PlaceTest newPlaceTest) async {
    try {
    var map = newPlaceTest.toMap();
    map.remove(COLUMN_ID);
    return await DBHelper.getInstance(DB_NAME).update(
    tableName: PLACES_TABLE_NAME,
    whereColumnName: COLUMN_ID,
    whereValue: idToUpdate,
    map: map) >
    0;
    } catch (ex) {
    print(ex);
    }
    return false;
    }
    }

 * */
}
