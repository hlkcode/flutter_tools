import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_tools_method_channel.dart';

abstract class FlutterToolsPlatform extends PlatformInterface {
  /// Constructs a FlutterToolsPlatform.
  FlutterToolsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterToolsPlatform _instance = MethodChannelFlutterTools();

  /// The default instance of [FlutterToolsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterTools].
  static FlutterToolsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterToolsPlatform] when
  /// they register themselves.
  static set instance(FlutterToolsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
