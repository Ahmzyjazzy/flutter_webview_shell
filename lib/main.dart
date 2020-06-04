//import 'package:app_shell/blocs/blocs.dart';
//import 'package:app_shell/blocs/simple_bloc_delegate.dart';
import 'package:app_shell/ui/screens/screens.dart';
import 'package:app_shell/utils/utils.dart';

//import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

import 'utils/routes.dart';

bool isfirstLaunch;

Future<void> main() async {
//  BlocSupervisor.delegate = SimpleBlocDelegate();
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
      title: Setting.app_name,
      debugShowCheckedModeBanner: false,
      home: isfirstLaunch ? IntroScreen() : WebScreen(url: Setting.app_url),
      routes: routes,
    );
  }
}

