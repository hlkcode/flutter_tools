import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tools/flutter_tools.dart';
import 'package:flutter_tools/tools_models.dart';
import 'package:flutter_tools/ui/widgets.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterToolsPlugin = FlutterTools();
  final kPurpleTextStyle = const TextStyle(color: Colors.purple, fontSize: 16);
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterToolsPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SafeArea(
        child: SimpleBottomTabsPage.noDrawer(
          appBar: AppBar(),
          // middleSpace: 0.06,
          iconSize: 36,
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            shape: const CircleBorder(),
            backgroundColor: Colors.purple,
            onPressed: () {},
            child: const Icon(size: 36, Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          // bottomTabsType: SimpleBottomTabsType.roundedIconAndText,
          selectedColor: Colors.purple,
          // backgroundColor: kPurpleLightColor,
          tabItems: [
            BottomTabItem(
              tabTitle: 'Home',
              icon: const Icon(Icons.home_outlined),
              widget: Center(child: Text('HOME', style: kPurpleTextStyle)),
            ),
            BottomTabItem(
              tabTitle: 'Riders',
              icon: const Icon(Icons.compare_arrows_outlined),
              widget: Center(child: Text('RIDERS', style: kPurpleTextStyle)),
            ),
            BottomTabItem(
              tabTitle: 'Settings',
              icon: const Icon(Icons.settings),
              widget: Center(child: Text('SETTINGS', style: kPurpleTextStyle)),
            ),
            BottomTabItem(
              tabTitle: 'Account',
              icon: const Icon(Icons.account_circle),
              widget: Center(child: Text('ACCOUNT', style: kPurpleTextStyle)),
            ),
          ],
        ),
      ),
    );
    // return MaterialApp(
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Plugin example app'),
    //     ),
    //     body: Center(
    //       child: Text('Running on: $_platformVersion\n'),
    //     ),
    //   ),
    // );
  }
}
