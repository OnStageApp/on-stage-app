import 'package:flutter/material.dart';
import 'package:on_stage_app/app/app.dart';
import 'package:on_stage_app/bootstrap.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();

  // void initState() {
  //   // super.initState();
  //   // Add code after super
  // }

  bootstrap(() => const App());
}
