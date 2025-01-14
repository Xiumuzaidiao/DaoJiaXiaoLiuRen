import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // 引入 Fluttertoast
import 'record_page.dart';
import 'study.dart';

class Setting extends StatefulWidget {
  @override
  _Setting createState() => _Setting();
}

class _Setting extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1), // 设置背景颜色
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(243, 244, 248, 1), // 设置背景颜色

        title: Text(
          "记录",
          style: TextStyle(fontSize: 20, fontFamily: "Alimama"),
        ),
        centerTitle: true,
        toolbarHeight: 60.0, // 增加 AppBar 的高度
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 点击后显示软件版本 Toast
            _buildRoundedContainer("软件版本：1.0.0_app-release定制", onTap: () {
              Fluttertoast.showToast(
                msg: "这是第一版app，估计也是最后一版了",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
              );
            }),
            SizedBox(height: 16), // 添加间距

            // 点击后显示软件作者 Toast
            _buildRoundedContainer("软件作者：匿名", onTap: () {
              Fluttertoast.showToast(
                msg: "作者貌似隐匿江湖了~以后随缘更新",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
              );
            }),
            SizedBox(height: 16), // 添加间距

            // 点击后跳转到 StudyPage
            _buildRoundedContainer("学习资料", onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(child: StudyPage()),
              );
            }),
            SizedBox(height: 16), // 添加间距

            // 点击后跳转到 RecordPage
            _buildRoundedContainer("排盘记录", onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(child: RecordPage()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedContainer(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap, // 点击事件
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // 圆角设置
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // 设置阴影方向
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

// 自定义 PageRoute 实现右侧滑入
class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({required this.child})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // 从右侧滑入
      const end = Offset.zero; // 最终位置
      const curve = Curves.easeInOut;

      var tween =
      Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
