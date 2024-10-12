import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tools/flutter_tools.dart';
import 'package:flutter_tools/flutter_tools_platform_interface.dart';
import 'package:flutter_tools/flutter_tools_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterToolsPlatform
    with MockPlatformInterfaceMixin
    implements FlutterToolsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterToolsPlatform initialPlatform = FlutterToolsPlatform.instance;

  test('$MethodChannelFlutterTools is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterTools>());
  });

  test('getPlatformVersion', () async {
    FlutterTools flutterToolsPlugin = FlutterTools();
    MockFlutterToolsPlatform fakePlatform = MockFlutterToolsPlatform();
    FlutterToolsPlatform.instance = fakePlatform;

    expect(await flutterToolsPlugin.getPlatformVersion(), '42');
  });
}
