import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Hive 相关
import 'models/qigua_record.dart'; // 如果你有自定义的数据类型，需要引入
import 'tabbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Hive
  await Hive.initFlutter();

  // 注册适配器（确保已生成 qigua_record.g.dart）
  Hive.registerAdapter(QiGuaRecordAdapter());

  // 以 QiGuaRecord 类型打开 Box，一次即可
  await Hive.openBox<QiGuaRecord>('qigua_records');

  // 设置只允许竖屏
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true, // 启用 Material 3 设计规范

        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color.fromRGBO(0, 125, 255, 1),
          selectionColor: Color.fromRGBO(0, 125, 255, 0.3),
          selectionHandleColor: Color.fromRGBO(0, 125, 255, 1),
        ),

        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.blue,
          onPrimary: Colors.black,
          secondary: Colors.blue,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          primaryContainer: Colors.grey[200]!,
          onPrimaryContainer: Colors.black,
          secondaryContainer: Colors.blue[200]!,
          onSecondaryContainer: Colors.white,
          tertiary: Colors.green,
          onTertiary: Colors.white,
          tertiaryContainer: Colors.green[200]!,
          onTertiaryContainer: Colors.white,
          errorContainer: Colors.red[200]!,
          onErrorContainer: Colors.white,
          surfaceContainerHighest: Colors.grey[300]!,
          onSurfaceVariant: Colors.grey[800]!,
          outline: Colors.grey[400]!,
          outlineVariant: Colors.grey[600]!,
          shadow: Colors.black,
          scrim: Colors.black54,
          inverseSurface: Colors.black,
          onInverseSurface: Colors.white,
          inversePrimary: Colors.blueGrey,
          surfaceTint: Colors.white,
        ),

        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
      ],

      home: PageViewWithController(),
    );
  }
}
