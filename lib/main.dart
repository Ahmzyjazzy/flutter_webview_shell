import 'package:app_shell/ui/screens/screens.dart';
import 'package:app_shell/utils/utils.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

import 'utils/routes.dart';

bool isfirstLaunch;

Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtil.getInstance();

  //* Forcing only portrait orientation
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  isfirstLaunch = StorageUtil.getFromDisk('firstLaunch') ?? true;
  await StorageUtil.saveToDisk('firstLaunch', false);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Elotto.app_name,
      debugShowCheckedModeBanner: false,
      home: WebScreen(url: Elotto.app_url),
      routes: routes,
    );
  }
}
