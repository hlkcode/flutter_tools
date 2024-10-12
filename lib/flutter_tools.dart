
import 'flutter_tools_platform_interface.dart';

class FlutterTools {
  Future<String?> getPlatformVersion() {
    return FlutterToolsPlatform.instance.getPlatformVersion();
  }
}
