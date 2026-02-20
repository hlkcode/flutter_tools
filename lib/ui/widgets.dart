import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tools/utilities/extension_methods.dart';
import 'package:get/get.dart';

import '../common.dart';
import '../tools_models.dart';
import '../utilities/utils.dart';

/// PAGE SESSION
class SimpleTopTabsPage extends StatefulWidget {
  static const String routeName = '/SimpleTopTabsPage';
  final String tabsPageTile;
  final List<TopTabItem> tabItems;
  final Widget? drawer;
  final Widget? floatingActionButton;

  final String? backgroundImageAssetPath;
  final Color backgroundColor;
  final Color selectedColor;
  final Color deselectedColor;
  final List<Widget>? appBarActionIcons;
  final AppBar? appBar;
  final Function(int)? onPageChanged;

  const SimpleTopTabsPage.noDrawer(
      {super.key,
      this.tabsPageTile = '',
      required this.tabItems,
      this.drawer,
      this.backgroundColor = Colors.white,
      this.selectedColor = Colors.blueAccent,
      this.deselectedColor = Colors.black38,
      this.appBarActionIcons,
      this.appBar,
      this.onPageChanged,
      this.backgroundImageAssetPath,
      this.floatingActionButton});

  const SimpleTopTabsPage.withDrawer(
      {super.key,
      this.tabsPageTile = '',
      required this.tabItems,
      required this.drawer,
      this.backgroundColor = Colors.white,
      this.selectedColor = Colors.blueAccent,
      this.deselectedColor = Colors.black38,
      this.appBarActionIcons,
      this.appBar,
      this.onPageChanged,
      this.backgroundImageAssetPath,
      this.floatingActionButton});

  @override
  _SimpleTopTabsPageState createState() => _SimpleTopTabsPageState();
}

class _SimpleTopTabsPageState extends State<SimpleTopTabsPage>
    with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: widget.tabItems.length, vsync: this);
    _controller.addListener(() {
      refreshIndex(_controller.index);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: widget.appBar ??
          AppBar(
            elevation: 0.5,
            title: Text(
              GetUtils.isNullOrBlank(widget.tabsPageTile)!
                  ? widget.tabItems[_currentTabIndex].tabTitle
                  : widget.tabsPageTile,
            ),
            bottom: TabBar(
                controller: _controller,
                onTap: refreshIndex,
                tabs: widget.tabItems
                    .map(
                      (tabHeader) => Tab(
                        icon: tabHeader.icon,
                        text: tabHeader.tabTitle,
                      ),
                    )
                    .toList()),
            actions: widget.appBarActionIcons,
          ),
      backgroundColor: widget.backgroundImageAssetPath != null
          ? Colors.transparent
          : widget.backgroundColor,
      body: TabBarView(
        controller: _controller,
        children: widget.tabItems.map((item) => item.widget).toList(),
      ),
      floatingActionButton: widget.floatingActionButton,
      drawer: widget.drawer,
    );

    return DefaultTabController(
      length: widget.tabItems.length,
      child: widget.backgroundImageAssetPath == null
          ? scaffold
          : PageWithBackground(
              child: scaffold,
              assetImagePath: getString(widget.backgroundImageAssetPath),
            ),
    );
  }

  void refreshIndex(int index) {
    if (widget.onPageChanged != null) {
      widget.onPageChanged!(index);
    }
    setState(() {
      _currentTabIndex = index;
    });
  }
}

class SimpleBottomTabsPage extends StatefulWidget {
  static const String routeName = 'SimpleBottomTabsPage';
  final String tabsPageTile;
  final List<BottomTabItem> tabItems;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Color backgroundColor;
  final Color selectedColor;
  final Color deselectedColor;
  final SimpleBottomTabsType bottomTabsType;
  final List<Widget>? appBarActionIcons;
  final AppBar? appBar;
  final double iconSize;
  final double notchMargin;
  final Clip clipBehavior;
  final Function(int)? onPageChanged;
  final bool showDefaultAppBar;

  const SimpleBottomTabsPage.noDrawer(
      {super.key,
      this.tabsPageTile = '',
      this.clipBehavior = Clip.antiAlias,
      required this.tabItems,
      this.notchMargin = 10,
      this.drawer,
      this.showDefaultAppBar = false,
      this.backgroundColor = Colors.white,
      this.selectedColor = Colors.blueAccent,
      this.deselectedColor = Colors.black38,
      this.bottomTabsType = SimpleBottomTabsType.rawOrDefault,
      this.appBarActionIcons,
      this.appBar,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.onPageChanged,
      this.iconSize = 24.0});

  const SimpleBottomTabsPage.withDrawer(
      {super.key,
      this.tabsPageTile = '',
      this.notchMargin = 10,
      this.clipBehavior = Clip.antiAlias,
      this.showDefaultAppBar = false,
      required this.tabItems,
      required this.drawer,
      this.backgroundColor = Colors.white,
      this.selectedColor = Colors.blueAccent,
      this.deselectedColor = Colors.black38,
      this.bottomTabsType = SimpleBottomTabsType.rawOrDefault,
      this.appBarActionIcons,
      this.appBar,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.iconSize = 24.0,
      this.onPageChanged});

  @override
  _SimpleBottomTabsPageState createState() => _SimpleBottomTabsPageState();
}

class _SimpleBottomTabsPageState extends State<SimpleBottomTabsPage> {
  int _currentTabIndex = 0;
  bool hasMiddleButton = false;

  late final int mid;
  // final List<Widget> widgetList = [];

  @override
  void initState() {
    super.initState();
    final length = widget.tabItems.length;
    mid = (length / 2).toInt();

    hasMiddleButton =
        widget.bottomTabsType == SimpleBottomTabsType.rawOrDefault &&
            widget.floatingActionButtonLocation
                .toString()
                .containsIgnoreCase('centerDocked');

    if (hasMiddleButton) {
      assert(length == 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar ??
          (widget.showDefaultAppBar
              ? AppBar(
                  title: Text(
                    GetUtils.isNullOrBlank(widget.tabsPageTile)!
                        ? widget.tabItems[_currentTabIndex].tabTitle
                        : widget.tabsPageTile,
                  ),
                  actions: widget.appBarActionIcons,
                )
              : null),
      body: widget.tabItems[_currentTabIndex].widget,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      bottomNavigationBar: hasMiddleButton
          ? BottomAppBar(
              // color: Colors.white,
              shape: CircularNotchedRectangle(),
              clipBehavior: widget.clipBehavior,
              notchMargin: widget.notchMargin,
              padding: EdgeInsets.zero,
              child: _getBottomNavigationBar(widget.bottomTabsType),
            )
          : _getBottomNavigationBar(widget.bottomTabsType),
      drawer: widget.drawer,
    );
  }

  void refreshIndex(int index) {
    if (widget.onPageChanged != null) {
      widget.onPageChanged!(index);
    }
    setState(() {
      _currentTabIndex = index;
    });
  }

  Widget? _getBottomNavigationBar(SimpleBottomTabsType tabsType) {
    Widget? mBottomBar; // animatedIcon
    if (tabsType == SimpleBottomTabsType.topSelection) {
      mBottomBar = _TopBottomNavBar(
          isForTop: true,
          backgroundColor: widget.backgroundColor,
          deselectedColor: widget.deselectedColor,
          selectedColor: widget.selectedColor,
          currentTabIndex: _currentTabIndex,
          onItemTap: refreshIndex,
          iconDataList: widget.tabItems.map((e) => e.icon.icon!).toList());
    } else if (tabsType == SimpleBottomTabsType.bottomSelection) {
      mBottomBar = _TopBottomNavBar(
          isForTop: false,
          backgroundColor: widget.backgroundColor,
          deselectedColor: widget.deselectedColor,
          selectedColor: widget.selectedColor,
          currentTabIndex: _currentTabIndex,
          onItemTap: refreshIndex,
          iconDataList: widget.tabItems.map((e) => e.icon.icon!).toList());
    } else if (tabsType == SimpleBottomTabsType.roundedIcon) {
      mBottomBar = _RoundNavBar(
          isWithText: false,
          backgroundColor: widget.backgroundColor,
          deselectedColor: widget.deselectedColor,
          selectedColor: widget.selectedColor,
          currentTabIndex: _currentTabIndex,
          onItemTap: refreshIndex,
          iconDataList: widget.tabItems.map((e) => e.icon.icon!).toList());
    } else if (tabsType == SimpleBottomTabsType.roundedIconAndText) {
      mBottomBar = _RoundNavBar(
          isWithText: true,
          titleList: widget.tabItems.map((e) => e.tabTitle).toList(),
          backgroundColor: widget.backgroundColor,
          deselectedColor: widget.deselectedColor,
          selectedColor: widget.selectedColor,
          currentTabIndex: _currentTabIndex,
          onItemTap: refreshIndex,
          iconDataList: widget.tabItems.map((e) => e.icon.icon!).toList());
    } else {
      mBottomBar = BottomNavigationBar(
        // backgroundColor: widget.backgroundColor,
        onTap: (selectedTabIndex) => refreshIndex(selectedTabIndex),
        unselectedItemColor: widget.deselectedColor,
        selectedItemColor: widget.selectedColor,
        currentIndex: _currentTabIndex,
        iconSize: widget.iconSize,
        // type: BottomNavigationBarType.shifting,
        items: widget.tabItems
            .map((item) => BottomNavigationBarItem(
                  icon: item.icon,
                  label: item.tabTitle,
                  backgroundColor: widget.backgroundColor,
                ))
            .toList(),
      );

      if (hasMiddleButton) {
        final List<Widget> widgetList = [];
        for (int index = 0; index < widget.tabItems.length; index++) {
          var item = widget.tabItems[index];
          var isSelected = index == _currentTabIndex;
          var color =
              isSelected ? widget.selectedColor : widget.deselectedColor;
          // null to use default
          var textSize = isSelected ? 15.0 : null;
          var iconSize = isSelected ? widget.iconSize : null;
          var clickable = InkWell(
            onTap: () => refreshIndex(index),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon.icon,
                  size: iconSize,
                  color: color,
                ),
                // verticalSpace(0.01),
                Text(
                  limitedWord(item.tabTitle, 8),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: textSize,
                  ),
                ),
              ],
            ),
          );

          widgetList.add(clickable);

          if (index == (mid - 1)) widgetList.add(horizontalSpace(0.04));
        }
        mBottomBar = AnimatedContainer(
          duration: const Duration(milliseconds: 1500),
          curve: Curves.fastLinearToSlowEaseIn,
          color: widget.backgroundColor,
          alignment: Alignment.center,
          // padding: EdgeInsets.symmetric(vertical: 6),
          // margin: EdgeInsets.all(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widgetList,
          ),
        );
      }
    }
    return mBottomBar;
  }
}

class _TopBottomNavBar extends StatelessWidget {
  const _TopBottomNavBar(
      {required this.backgroundColor,
      required this.selectedColor,
      required this.deselectedColor,
      required this.currentTabIndex,
      required this.isForTop,
      required this.onItemTap,
      required this.iconDataList});

  final Color backgroundColor;
  final Color selectedColor;
  final Color deselectedColor;
  final int currentTabIndex;
  final bool isForTop;
  final Function(int position) onItemTap;
  final List<IconData> iconDataList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(isForTop ? 20 : 0),
      height: getWidth(.155),
      decoration: isForTop
          ? BoxDecoration(
              color: backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
              borderRadius: BorderRadius.circular(50),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: iconDataList.mapIndexed((index, element) {
          var clickable = InkWell(
            onTap: () => onItemTap(index),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isForTop) SizedBox(height: getWidth(.014)),
                if (!isForTop)
                  Icon(
                    iconDataList[index],
                    size: getWidth(.076),
                    color: index == currentTabIndex
                        ? selectedColor
                        : deselectedColor,
                  ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(
                    bottom: isForTop
                        ? index == currentTabIndex
                            ? 0
                            : getWidth(.029)
                        : 0,
                    right: getWidth(.0422),
                    left: getWidth(.0422),
                    top: !isForTop
                        ? index == currentTabIndex
                            ? 0
                            : getWidth(.029)
                        : 0,
                  ),
                  width: isForTop ? getWidth(.128) : getWidth(.153),
                  height: index == currentTabIndex ? getWidth(.014) : 0,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(isForTop ? 10 : 0),
                      top: Radius.circular(!isForTop ? 20 : 0),
                    ),
                  ),
                ),
                if (isForTop)
                  Icon(
                    iconDataList[index],
                    size: getWidth(.076),
                    color: index == currentTabIndex
                        ? selectedColor
                        : deselectedColor,
                  ),
                if (isForTop) SizedBox(height: getWidth(.03)),
              ],
            ),
          );

          return clickable;
        }).toList(),
      ),
    );
  }

  // ListView.builder(
  // itemCount: iconDataList.length,
  // scrollDirection: Axis.horizontal,
  // padding: EdgeInsets.symmetric(horizontal: getWidth(.024)),
  // itemBuilder: (context, index) {
  // var clickable = InkWell(
  // onTap: () => onItemTap(index),
  // splashColor: Colors.transparent,
  // highlightColor: Colors.transparent,
  // child: Column(
  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  // children: [
  // if (!isForTop) SizedBox(height: getWidth(.014)),
  // if (!isForTop)
  // Icon(
  // iconDataList[index],
  // size: getWidth(.076),
  // color: index == currentTabIndex
  // ? selectedColor
  //     : deselectedColor,
  // ),
  // AnimatedContainer(
  // duration: const Duration(milliseconds: 1500),
  // curve: Curves.fastLinearToSlowEaseIn,
  // margin: EdgeInsets.only(
  // bottom: isForTop
  // ? index == currentTabIndex
  // ? 0
  //     : getWidth(.029)
  //     : 0,
  // right: getWidth(.0422),
  // left: getWidth(.0422),
  // top: !isForTop
  // ? index == currentTabIndex
  // ? 0
  //     : getWidth(.029)
  //     : 0,
  // ),
  // width: isForTop ? getWidth(.128) : getWidth(.153),
  // height: index == currentTabIndex ? getWidth(.014) : 0,
  // decoration: BoxDecoration(
  // color: selectedColor,
  // borderRadius: BorderRadius.vertical(
  // bottom: Radius.circular(isForTop ? 10 : 0),
  // top: Radius.circular(!isForTop ? 20 : 0),
  // ),
  // ),
  // ),
  // if (isForTop)
  // Icon(
  // iconDataList[index],
  // size: getWidth(.076),
  // color: index == currentTabIndex
  // ? selectedColor
  //     : deselectedColor,
  // ),
  // if (isForTop) SizedBox(height: getWidth(.03)),
  // ],
  // ),
  // );
  // return clickable;
  // },
  // )
  //
}

class _RoundNavBar extends StatelessWidget {
  const _RoundNavBar(
      {required this.backgroundColor,
      required this.selectedColor,
      required this.deselectedColor,
      required this.currentTabIndex,
      required this.isWithText,
      required this.onItemTap,
      required this.iconDataList,
      this.titleList});

  final Color backgroundColor;
  final Color selectedColor;
  final Color deselectedColor;
  final int currentTabIndex;
  final bool isWithText;
  final Function(int position) onItemTap;
  final List<IconData> iconDataList;
  final List<String>? titleList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          isWithText ? const EdgeInsets.all(20) : EdgeInsets.all(getWidth(.05)),
      height: getWidth(.155),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isWithText ? .15 : .1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        borderRadius: BorderRadius.circular(50),
      ),
      child: ListView.builder(
        itemCount: iconDataList.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: getWidth(.024)),
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            onItemTap(index);
            HapticFeedback.lightImpact();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: isWithText
              ? Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: index == currentTabIndex
                          ? getWidth(.32)
                          : getWidth(.18),
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: index == currentTabIndex ? getWidth(.12) : 0,
                        width: index == currentTabIndex ? getWidth(.32) : 0,
                        decoration: BoxDecoration(
                          color: index == currentTabIndex
                              ? selectedColor.withOpacity(.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: index == currentTabIndex
                          ? getWidth(.31)
                          : getWidth(.18),
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: index == currentTabIndex
                                    ? getWidth(.13)
                                    : 0,
                              ),
                              AnimatedOpacity(
                                opacity: index == currentTabIndex ? 1 : 0,
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: Text(
                                  index == currentTabIndex
                                      ? limitedWord(titleList![index], 8)
                                      : '',
                                  style: TextStyle(
                                    color: selectedColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: index == currentTabIndex
                                    ? getWidth(.03)
                                    : 20,
                              ),
                              Icon(
                                iconDataList[index],
                                size: getWidth(.076),
                                color: index == currentTabIndex
                                    ? selectedColor
                                    : deselectedColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    SizedBox(
                      width: getWidth(.2125),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          height: index == currentTabIndex ? getWidth(.12) : 0,
                          width: index == currentTabIndex ? getWidth(.2125) : 0,
                          decoration: BoxDecoration(
                            color: index == currentTabIndex
                                ? selectedColor.withOpacity(.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: getWidth(.2125),
                      alignment: Alignment.center,
                      child: Icon(
                        iconDataList[index],
                        size: getWidth(.076),
                        color: index == currentTabIndex
                            ? selectedColor
                            : deselectedColor,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class PageWithBackground extends StatelessWidget {
  // todo wrap scaffold with this widget, and make sure to set the background color of the scaffold to backgroundColor = Colors.transparent;
  final Scaffold child;
  final String assetImagePath;
  const PageWithBackground(
      {Key? key, required this.child, required this.assetImagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(assetImagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}

///:::::::::::::::::::::::::::::::::::::::::::::::::::
/// SEPARATOR
///:::::::::::::::::::::::::::::::::::::::::::::::::::

class Badge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;

  //Badge({Color? color = null, required this.value, required this.child});

  const Badge({
    required this.child,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child, // more likely to be an icon, like cart icon
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color ?? Theme.of(context).colorScheme.secondary,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class SimpleDrawer extends StatelessWidget {
  final Widget menuHeader;
  final TextStyle? textStyle;
  final List<DrawerContent> contentList;

  const SimpleDrawer(
      {Key? key,
      required this.menuHeader,
      required this.contentList,
      this.textStyle})
      : super(key: key);

  ListTile _buildListTile(
      IconData? iconData, String text, Function()? onTapHandler) {
    return ListTile(
      leading: Icon(
        iconData,
        size: 26,
      ),
      title: Text(
        text,
        style: textStyle,
      ),
      onTap: onTapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          /* Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Text(
              'Main-Menu',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor),
            ),
          ),*/
          menuHeader,
          const SizedBox(height: 20),
          ...contentList
              .map((cnt) =>
                  _buildListTile(cnt.iconData, cnt.text, cnt.onTapHandler))
              .toList(),
          /* buildListTile(Icons.restaurant, 'Meals', () {
            Navigator.pushNamed(context, SettingsPage.routeName);
          }),
          buildListTile(Icons.settings, 'Filters', () {
            Navigator.pushReplacementNamed(context, FilterPage.routeName);
          }),*/
        ],
      ),
    );
  }
}

class DrawerHeaderText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const DrawerHeaderText({Key? key, required this.text, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}

// todo this will be useful in stateful widget so content can be updated using setState
// todo or u can wrap it with Obx(()=>LoadingButton()) having a private observable isLoading variable
class LoadingButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final bool isOutlined;
  final Color? buttonColor;
  final Color? loadingColor;
  final TextStyle? style;
  final LoadingWidgetType? type;
  final double? buttonRadius;
  final double? buttonHeight;
  final void Function()? onTapped;
  final Icon? leadingIcon;
  final EdgeInsetsGeometry btnMargin;

  const LoadingButton(
      {Key? key,
      required this.text,
      required this.isLoading,
      this.buttonColor,
      this.loadingColor,
      this.style,
      this.type,
      this.leadingIcon,
      this.buttonRadius,
      this.buttonHeight,
      this.onTapped,
      this.btnMargin = const EdgeInsets.symmetric(horizontal: 8),
      this.isOutlined = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? _style = style ?? Get.theme.textTheme.labelLarge;

    final Color _loadingColor = loadingColor ??
        (isOutlined ? Get.theme.colorScheme.secondary : Colors.white);

    final Color _buttonColor = buttonColor ?? Get.theme.colorScheme.primary;

    Widget _loadingWidget;

    if (type == LoadingWidgetType.wave) {
      _loadingWidget = SpinKitWave(
        color: _loadingColor,
        size: getDisplayWidth() * 0.08,
      );
    } else if (type == LoadingWidgetType.sandTimer) {
      _loadingWidget = SpinKitPouringHourGlassRefined(
        color: _loadingColor,
        size: getDisplayWidth() * 0.1,
      );
    } else {
      //_loadingWidget = const CircularProgressIndicator(color: Colors.white);
      _loadingWidget = SpinKitFadingCircle(
        color: _loadingColor,
        size: getDisplayWidth() * 0.1,
      );
    }

    return GestureDetector(
      onTap: isLoading ? null : onTapped,
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        margin: btnMargin,
        width: double.infinity,
        height: buttonHeight ?? 46,
        alignment: Alignment.center,
        //color: buttonColor ?? Get.theme.buttonTheme.colorScheme!.primary,
        curve: Curves.fastOutSlowIn,
        decoration: isOutlined
            ? BoxDecoration(
                color: _buttonColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(buttonRadius ?? 4),
                border: Border.all(
                  color: onTapped == null ? Colors.grey.shade300 : _buttonColor,
                  width: 2,
                ),
              )
            : BoxDecoration(
                color: onTapped == null ? Colors.grey.shade300 : _buttonColor,
                borderRadius: BorderRadius.circular(buttonRadius ?? 4),
              ),
        child: isLoading
            ? _loadingWidget
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) leadingIcon!,
                  if (leadingIcon != null) const SizedBox(width: 4),
                  Text(
                    text,
                    style: _style?.copyWith(overflow: TextOverflow.ellipsis),
                  )
                ],
              ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key, this.loadingColor = kPrimaryColor})
      : super(key: key);
  final Color loadingColor;
  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      color: loadingColor,
      size: getWidth(0.06),
    );
  }
}

class RoundedText extends StatelessWidget {
  final String text;
  final double radius;
  final double borderThickness;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color borderColor;

  const RoundedText({
    Key? key,
    required this.text,
    this.radius = 25,
    this.textStyle,
    this.backgroundColor,
    this.borderColor = Colors.black,
    this.borderThickness = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius / 2 + borderThickness,
      backgroundColor: borderColor,
      foregroundColor: Colors.transparent,
      child: CircleAvatar(
        radius: radius / 2,
        backgroundColor: backgroundColor,
        foregroundColor: Colors.transparent,
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
      ),
    );
  }
}

// class RoundedText extends StatelessWidget {
//   final String text;
//   final double radius;
//   final TextStyle? textStyle;
//   final Color? backgroundColor;
//   final Color borderColor;
//   final double? height;
//   final double? width;
//   final double padding;
//
//   const RoundedText({
//     Key? key,
//     required this.text,
//     this.radius = 10,
//     this.height,
//     this.width,
//     this.textStyle,
//     this.backgroundColor,
//     this.borderColor = Colors.black,
//     this.padding = 10,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       width: width,
//       alignment: Alignment.center,
//       padding: EdgeInsets.all(padding),
//       constraints: const BoxConstraints(
//         minWidth: 16,
//         minHeight: 16,
//       ),
//       decoration: BoxDecoration(
//           color: backgroundColor,
//           border: Border.all(
//             color: borderColor,
//           ),
//           borderRadius: BorderRadius.all(Radius.circular(radius))),
//       child: Text(
//         text,
//         textAlign: TextAlign.center,
//         style: textStyle,
//       ),
//     );
//   }
// }

class RoundIconButton extends StatelessWidget {
  final Function()? onPressed;
  final Color? btnColor;
  final double size;
  final Icon icon;
  const RoundIconButton({
    Key? key,
    this.onPressed,
    this.btnColor,
    this.size = 56,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 6,
      constraints: BoxConstraints.tightFor(width: size, height: size),
      onPressed: onPressed,
      fillColor: btnColor,
      shape: const CircleBorder(),
      child: icon,
    );
  }
}

class SimplePopUpMenu extends StatelessWidget {
  final Widget childWidget;
  final List<AlertDialogContent> contentList;

  const SimplePopUpMenu({
    Key? key,
    required this.childWidget,
    required this.contentList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      // initialValue: 0,
      onSelected: (index) {
        logInfo('index is $index');
        contentList[index].action(context);
      },
      itemBuilder: (context) => contentList
          .map((AlertDialogContent e) => PopupMenuItem<int>(
                value: contentList.indexOf(e),
                child: Text(e.text),
              ))
          .toList(),
      child: childWidget,
    );
  }
}

class NoItemLoader extends StatelessWidget {
  final String message;
  final Function()? onTapHandler;
  const NoItemLoader({
    Key? key,
    this.onTapHandler,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapHandler,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.unarchive_outlined,
            size: 50,
          ),
          verticalSpace(0.02),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

///
class DropDownSelector extends StatelessWidget {
  DropDownSelector({
    super.key,
    required this.list,
    required this.onSelectionChange,
    required this.instruction,
    this.inputDecoration,
    this.selectedIndex = -1,
  });

  final List<String> list;
  final Function(String? newValue) onSelectionChange;
  final String instruction;
  final int selectedIndex;
  final RxString _selected = ''.obs;
  final InputDecoration? inputDecoration;

  @override
  Widget build(BuildContext context) {
    _selected.value = selectedIndex == -1 ? '' : list[selectedIndex];
    return Obx(() => DropdownButtonFormField<String>(
          decoration: inputDecoration ?? InputDecoration(border: purpleBorder),
          isExpanded: true,
          hint: Align(
            child: Text(
              getString(GetUtils.capitalize(instruction)),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          validator: requiredValidator,
          items: list.map((String value) {
            return DropdownMenuItem<String>(
              alignment: AlignmentDirectional.center,
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newVal) {
            _selected.value = getString(newVal);
            onSelectionChange(newVal);
          },
          value: _selected.isEmpty ? null : _selected.value,
        ));
  }
}

class RowPair extends StatelessWidget {
  final String title;
  final String value;
  const RowPair({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value),
      ],
    );
  }
}

class SelectableCard extends StatelessWidget {
  final bool showSelection;
  final bool isSelected;
  final Function(bool?)? onSelectionChanged;
  final Function()? onSelected;
  final String cardTitle;
  final String actionText;
  final Map<String, String> rows;
  const SelectableCard({
    super.key,
    required this.showSelection,
    this.onSelectionChanged,
    required this.isSelected,
    required this.cardTitle,
    required this.rows,
    this.actionText = '',
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    var showAction = actionText.isNotEmpty;
    var mainContent = Card(
      elevation: 0.0,
      color: Colors.white54,
      child: Column(
        // spacing: getHeight(0.01),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cardTitle,
            style: kBlackTextStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          ...rows.entries
              .map((entry) => RowPair(title: entry.key, value: entry.value)),
          verticalSpace(0.01),
          if (showAction)
            LoadingButton(
              btnMargin: EdgeInsets.zero,
              // buttonHeight: getHeight(0.04),
              buttonHeight: 36,
              text: actionText,
              isOutlined: true,
              isLoading: false,
              buttonColor: kPurpleColor,
              style: kPurpleTextStyle,
              buttonRadius: 12,
              onTapped: onSelected,
            ),
        ],
      ).paddingAll(12),
    );
    return showSelection
        ? Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: onSelectionChanged,
              ),
              Expanded(child: mainContent),
            ],
          )
        : mainContent;
  }
}

class LabeledSwitch extends StatelessWidget {
  final String title;
  final String? switchTitle;
  final String? switchSubTitle;
  final RxBool currentValue;

  final Function(bool newValue)? onChange;

  const LabeledSwitch({
    super.key,
    required this.title,
    this.switchSubTitle,
    this.switchTitle,
    this.onChange,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    return LabeledWidget(
      title: title,
      widget: Obx(
        () => SwitchListTile(
          // tileColor: Colors.red,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: kPurpleColor),
              borderRadius: BorderRadius.circular(8)),
          activeColor: kPurpleColor,
          title: switchTitle != null ? Text(switchTitle!) : null,
          subtitle: switchSubTitle != null ? Text(switchSubTitle!) : null,
          // const Text('Is Property managed'),
          // subtitle:
          //     const Text('Are you managing this property for a third party ?'),
          value: currentValue.value,
          onChanged: (bool? value) {
            currentValue.value = value ?? false;
            if (onChange != null) onChange!(value ?? false);
          },
        ),
      ),
    );
  }
}

class LabeledSelector extends StatelessWidget {
  final String title;
  final List<String> options;
  final String instruction;
  final Function(String? newValue) onSelectionChange;
  final InputDecoration? decoration;
  final int? selectedIndex;
  const LabeledSelector({
    super.key,
    required this.title,
    required this.options,
    required this.instruction,
    required this.onSelectionChange,
    this.decoration,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return LabeledWidget(
      title: title,
      widget: DropDownSelector(
        selectedIndex: selectedIndex ?? -1,
        list: options,
        onSelectionChange: onSelectionChange,
        instruction: instruction,
        inputDecoration: decoration,
      ),
    );
  }
}

class LabeledTextField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final bool readOnly;
  final String? Function(String? value)? validator;
  const LabeledTextField(
      {super.key,
      required this.title,
      this.validator,
      this.controller,
      this.inputType,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return LabeledWidget(
      title: title,
      widget: TextFormField(
        readOnly: readOnly,
        decoration: InputDecoration(
          enabledBorder: purpleBorder,
          focusedBorder: purpleBorder,
          border: purpleBorder,
        ),
        validator: validator,
        controller: controller,
        keyboardType: inputType,
      ),
    );
  }
}

class LabeledWidget extends StatelessWidget {
  final String title;
  final Widget widget;
  final bool isVertical;
  const LabeledWidget({
    super.key,
    required this.title,
    required this.widget,
    this.isVertical = true,
  });

  @override
  Widget build(BuildContext context) {
    return isVertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: kPurpleTextStyle),
              widget,
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget,
              Text(title, style: kPurpleTextStyle),
            ],
          );
  }
}

class SelectableListPage extends StatelessWidget {
  final String cardFor;
  final String cardActionText;
  final String submitText;
  final List<Map<String, String>> rowsList;
  final List dataList;
  final RxBool loading;
  final bool reversed;
  final Function(bool?)? onSelectionChanged;
  final Function(RxList<int> selectedIndexes)? onSelectedSubmit;
  final Function()? onSelected;

  SelectableListPage({
    super.key,
    required this.cardFor,
    required this.cardActionText,
    required this.rowsList,
    required this.dataList,
    required this.submitText,
    required this.loading,
    this.onSelectedSubmit,
    this.onSelected,
    this.onSelectionChanged,
    this.reversed = false,
  });

  final RxList<int> _selectedIndexes = <int>[].obs;

  @override
  Widget build(BuildContext context) {
    var list = ListView.separated(
      itemCount: dataList.length,
      itemBuilder: (ctx, index) {
        var rowData = rowsList[index];
        var title = reversed
            ? '$cardFor #${dataList.length - index}'
            : '$cardFor #${index + 1}';
        return Obx(() => SelectableCard(
              actionText: cardActionText,
              showSelection: _selectedIndexes.isNotEmpty,
              isSelected: _selectedIndexes.contains(index),
              cardTitle: title,
              rows: rowData,
              onSelected: onSelected,
              onSelectionChanged: onSelectionChanged,
            ));
      },
      separatorBuilder: (BuildContext context, int index) =>
          verticalSpace(0.008),
    );
    return Container(
      color: kPurpleLightColor.withOpacity(.2),
      child: Obx(
        () => _selectedIndexes.isEmpty
            ? list
            : Column(
                // spacing: getHeight(0.008),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // verticalSpace(0.002),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => _selectedIndexes.clear(),
                        icon: Icon(Icons.cancel_outlined, size: 32),
                      ),
                      Text(
                        '${_selectedIndexes.length} Selected',
                        style: kPurpleTextStyle,
                        // style: kBlackTextStyle,
                      ),
                      SizedBox(
                        width: 110,
                        child: Obx(() => LoadingButton(
                              // btnMargin: EdgeInsets.zero,
                              // buttonHeight: getHeight(0.04),
                              buttonHeight: 36,
                              text: submitText,
                              // isOutlined: true,
                              style: kWhiteTextStyle,
                              isLoading: loading.value,
                              buttonColor: kPurpleColor,
                              buttonRadius: 12,
                              onTapped: () {
                                // if (onSubmit != null) onSubmit!();
                                if (onSelectedSubmit != null) {
                                  onSelectedSubmit!(_selectedIndexes);
                                }
                              },
                            )),
                      ),
                    ],
                  ),
                  LabeledWidget(
                    title: 'Select All',
                    isVertical: false,
                    widget: Checkbox(
                      value: _selectedIndexes.length == dataList.length,
                      onChanged: (sel) {
                        var limit = dataList.length;
                        _selectedIndexes.value =
                            List<int>.generate(limit, (i) => i);
                      },
                    ),
                  ),
                  Expanded(child: list)
                ],
              ),
      ).marginAll(10),
    );
  }
}
