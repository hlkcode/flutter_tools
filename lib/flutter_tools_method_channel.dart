import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_tools_platform_interface.dart';

/// An implementation of [FlutterToolsPlatform] that uses method channels.
class MethodChannelFlutterTools extends FlutterToolsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_tools');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
