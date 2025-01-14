import 'package:flutter/material.dart';
// 使用 webview_flutter
import 'package:webview_flutter/webview_flutter.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
    // 允许 JS
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
    // 加载指定 URL
      ..loadRequest(Uri.parse("https://www.wolai.com/bDdGZNY4A5PKGzs8Q3ySdM"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("学习资料"),
        centerTitle: true,
      ),
      // 使用 WebView
      body: WebViewWidget(controller: _controller),
    );
  }
}
