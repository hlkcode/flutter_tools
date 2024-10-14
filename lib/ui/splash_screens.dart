import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../tools_models.dart';
import '../utilities/utils.dart';

Widget _getLoadingWidget(
    LoadingWidgetType? loadingWidgetType, Color? _loadingColor) {
  Widget _loadingWidget;
  final Color color =
      _loadingColor ?? Get.theme.bottomAppBarTheme.color ?? Colors.blueAccent;
  if (loadingWidgetType == LoadingWidgetType.wave) {
    _loadingWidget = SpinKitWave(
      color: color,
      //type: SpinKitWaveType.center,
      size: getDisplayWidth() * 0.08,
    );
  } else if (loadingWidgetType == LoadingWidgetType.sandTimer) {
    _loadingWidget = SpinKitPouringHourGlassRefined(
      color: color,
      size: getDisplayWidth() * 0.12,
    );
  } else {
    //_loadingWidget = const CircularProgressIndicator(color: Colors.white);
    _loadingWidget = SpinKitFadingCircle(
      color: color,
      size: getDisplayWidth() * 0.12,
    );
  }
  return _loadingWidget;
}

Future<void> _pageToGoToWhenDone(Widget page,
    [int splashDuration = 5, Function? toExecute]) async {
  if (toExecute != null) {
    await toExecute();
    Get.off(() => page);
  } else {
    await Future.delayed(
        Duration(seconds: splashDuration), () => Get.off(() => page));
  }
}

class SimpleLogoTextSplashscreen extends StatelessWidget {
  const SimpleLogoTextSplashscreen({
    Key? key,
    this.logoSize,
    required this.imageUrl,
    this.appName,
    this.loadingWidgetType,
    this.loadingColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.titleColor,
    this.splashDuration = 6,
    required this.nextPage,
    this.toRunWhilstLoading,
  }) : super(key: key);

  final int splashDuration;
  final double? logoSize;
  final String imageUrl;
  final String? appName;
  final LoadingWidgetType? loadingWidgetType;
  final Color loadingColor;
  final Color backgroundColor;
  final Color? titleColor;
  final Function? toRunWhilstLoading;
  final Widget nextPage;

  @override
  Widget build(BuildContext context) {
    final _titleColor = titleColor ?? Get.textTheme.headlineLarge!.color;

    _pageToGoToWhenDone(nextPage, splashDuration, toRunWhilstLoading);

    var showText = !GetUtils.isNullOrBlank(appName)!;

    return Container(
      constraints: const BoxConstraints.expand(),
      color: backgroundColor,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (!showText) SizedBox(height: getDisplayHeight() * 0.01),
                Image.asset(
                  imageUrl,
                  width: logoSize ?? getDisplayWidth() * 0.32,
                  height: logoSize ?? getDisplayHeight() * 0.2,
                  fit: BoxFit.contain,
                ),
                if (showText) SizedBox(height: getDisplayHeight() * 0.01),
                if (showText)
                  Text(
                    appName!,
                    style: Get.textTheme.headlineLarge!.copyWith(
                      fontSize: 20,
                      color: _titleColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: getDisplayHeight() * 0.1),
          Expanded(
            flex: 1,
            child: Container(
              constraints: BoxConstraints(maxHeight: getDisplayHeight() * 0.04),
              child: _getLoadingWidget(loadingWidgetType, loadingColor),
            ),
          ),
        ],
      ),
    );
  }
}

class SlowMotionAppNameSplashscreen extends StatefulWidget {
  final int eachLaterDuration;
  final String appName;
  final Color backgroundColor;
  final Color? titleColor;
  final Widget nextPage;
  final SlowMotionAppNameType motionAppNameType;
  final Function? toRunWhilstLoading;
  final int splashDuration;

  const SlowMotionAppNameSplashscreen(
      {Key? key,
      this.eachLaterDuration = 300,
      this.splashDuration = 6,
      required this.appName,
      this.backgroundColor = Colors.blueAccent,
      this.titleColor,
      required this.nextPage,
      this.motionAppNameType = SlowMotionAppNameType.letterSlideHorizontally,
      this.toRunWhilstLoading})
      : super(key: key);

  @override
  _SlowMotionAppNameSplashscreenState createState() =>
      _SlowMotionAppNameSplashscreenState();
}

enum SlowMotionAppNameType {
  letterSlideHorizontally,
  letterWavingAndBouncing,
  fadeFirstThenScale,
  scaleContinuously,
  letterBlinkHorizontally
}

class _SlowMotionAppNameSplashscreenState
    extends State<SlowMotionAppNameSplashscreen> with TickerProviderStateMixin {
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    scaleController = AnimationController(
      vsync: this,
      duration:
          Duration(milliseconds: _getAnimationTime(widget.motionAppNameType)),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _pageToGoToWhenDone(widget.nextPage, widget.splashDuration,
                widget.toRunWhilstLoading);

            Timer(
                // const Duration(milliseconds: 300),
                Duration(milliseconds: widget.eachLaterDuration), () {
              if (!scaleController.isCompleted) scaleController.reset();
            });
          }
        },
      );

    scaleAnimation =
        Tween<double>(begin: 0.0, end: 12).animate(scaleController);

    Timer(const Duration(seconds: 2), () {
      setState(() {
        scaleController.forward();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scaleController.stop();
    scaleController.dispose();
    super.dispose();
  }

  int _getAnimationTime(SlowMotionAppNameType motionAppNameType) {
    if (motionAppNameType == SlowMotionAppNameType.letterWavingAndBouncing) {
      return widget.appName.length * widget.eachLaterDuration * 2;
    } else if (motionAppNameType == SlowMotionAppNameType.fadeFirstThenScale) {
      return widget.appName.length * widget.eachLaterDuration * 2;
    } else if (motionAppNameType ==
        SlowMotionAppNameType.letterBlinkHorizontally) {
      return widget.appName.length * widget.eachLaterDuration * 2;
    } else if (motionAppNameType == SlowMotionAppNameType.scaleContinuously) {
      return widget.appName.length * widget.eachLaterDuration * 2;
    } else {
      return widget.appName.length * widget.eachLaterDuration;
    }
  }

  AnimatedTextKit _getAnimatedTextKit(SlowMotionAppNameType motionAppNameType) {
    if (motionAppNameType == SlowMotionAppNameType.fadeFirstThenScale) {
      return AnimatedTextKit(
        animatedTexts: [
          FadeAnimatedText(
            'Welcome',
            // speed: Duration(milliseconds: widget.eachLaterDuration),
          ),
          FadeAnimatedText(
            'to',
            // speed: Duration(milliseconds: widget.eachLaterDuration),
          ),
          ScaleAnimatedText(widget.appName,
              textAlign: TextAlign.center,
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 50)
              // speed: Duration(milliseconds: widget.eachLaterDuration),
              ),
        ],
        isRepeatingAnimation: false,
        displayFullTextOnTap: false,
      );
    } else if (motionAppNameType ==
        SlowMotionAppNameType.letterBlinkHorizontally) {
      return AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            '${widget.appName}...',
            speed: Duration(milliseconds: widget.eachLaterDuration),
          ),
        ],
        isRepeatingAnimation: false,
        repeatForever: false,
        displayFullTextOnTap: false,
      );
    } else if (motionAppNameType ==
        SlowMotionAppNameType.letterWavingAndBouncing) {
      return AnimatedTextKit(
        animatedTexts: [
          WavyAnimatedText(
            widget.appName,
            speed: Duration(milliseconds: widget.eachLaterDuration),
          ),
        ],
        isRepeatingAnimation: true,
        repeatForever: false,
        totalRepeatCount: 2,
        displayFullTextOnTap: false,
      );
    } else if (motionAppNameType == SlowMotionAppNameType.scaleContinuously) {
      return AnimatedTextKit(
        animatedTexts: [
          ScaleAnimatedText('Welcome'),
          ScaleAnimatedText('to'),
          ScaleAnimatedText(widget.appName),
        ],
        isRepeatingAnimation: false,
        repeatForever: false,
        totalRepeatCount: 3,
        displayFullTextOnTap: false,
      );
    } else {
      return AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(
            widget.appName,
            //speed: Duration(milliseconds: 150),
            speed: Duration(milliseconds: widget.eachLaterDuration),
          ),
        ],
        isRepeatingAnimation: false,
        repeatForever: false,
        displayFullTextOnTap: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      color: widget.backgroundColor, //Color(0xff412EEF),
      child: Center(
        child: DefaultTextStyle(
          style: TextStyle(
              fontSize: 30.0,
              color: widget.titleColor ??
                  Colors.white /*Get.textTheme.headline1!.color*/),
          child: _getAnimatedTextKit(widget.motionAppNameType),
        ),
      ),
    );
  }
}
