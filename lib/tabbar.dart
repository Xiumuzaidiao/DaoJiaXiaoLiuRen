import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// 1. 引入 flutter_svg
import 'package:flutter_svg/flutter_svg.dart';

import 'setting/setting.dart';
import 'XiaoLiuRen/xiaoLiuRen.dart';

class PageViewWithController extends StatefulWidget {
  @override
  _PageViewWithControllerState createState() => _PageViewWithControllerState();
}

class _PageViewWithControllerState extends State<PageViewWithController> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool isAnimating = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (isAnimating || _currentIndex == index) {
      HapticFeedback.lightImpact(); // 点击时震动
      return;
    }
    setState(() {
      HapticFeedback.lightImpact(); // 点击时震动
      isAnimating = true; // 开始动画，设置标志为true
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      ).then((_) {
        setState(() {
          isAnimating = false; // 动画完成，设置标志为false
        });
      });
    });
  }

  Widget _buildNavItem(IconData? icon, String label, bool isSelected,
      {Widget? customIcon}) {
    return AnimatedContainer(
      width: isSelected ? 110 : 60,
      height: 50,
      duration: Duration(milliseconds: 300),
      curve: Cubic(0.33, 1, 0.68, 1),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? Color.fromRGBO(29, 29, 29, 1).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRect(
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: customIcon != null
                  ? customIcon // 使用自定义图标
                  : Icon(
                icon,
                color: isSelected
                    ? Color.fromRGBO(29, 29, 29, 1)
                    : Color.fromRGBO(29, 29, 29, 1),
              ),
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: Color.fromRGBO(29, 29, 29, 1),
                        fontFamily: "Alimama",
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      _onItemTapped(0);
      return false; // 不退出应用
    } else {
      return true; // 退出应用
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            if (!isAnimating) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          children: <Widget>[
            KeepAlivePage(child: XiaoLiuRen()),
            KeepAlivePage(child: Setting()),

          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () => _onItemTapped(0),
                child: _buildNavItem(
                  null, // 将 icon 传递为空
                  "起卦",
                  _currentIndex == 0,
                  // 2. 使用 SvgPicture.asset
                  customIcon: SvgPicture.asset(
                    'assets/icons/taiji.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _onItemTapped(1),
                child: _buildNavItem(
                  null, // 将 icon 传递为空
                  "记录",
                  _currentIndex == 1,
                  customIcon: SvgPicture.asset(
                    'assets/icons/setting.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class KeepAlivePage extends StatefulWidget {
  final Widget child;

  KeepAlivePage({required this.child});

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context); // 保持页面状态
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true; // 保持页面状态
}
