// @dart=2.9
import 'package:flutter_application_1/api/erp.glomed.service.dart';
import 'package:flutter_application_1/pages/auth/splashscreen.dart';
import 'package:flutter_application_1/provider/provider.login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  // RenderErrorBox.backgroundColor = Colors.transparent;
  // RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProviderLogin(devService: DevService()),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SpeedERP For Employee',
        home: SplashScreen(),
      ),
    );
  }
}
