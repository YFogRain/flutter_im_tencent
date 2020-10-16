import 'package:flutter/material.dart';
import 'package:tencent_im/im/IMManager.dart';
import 'package:tencent_im_example/ui/splash/SplashWidget.dart';
import 'package:tencent_im/im/enums/log_print_level.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    IMManager().init(1400330071,LogPrintLevel.debug);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashWidget(),
    );
  }
}
