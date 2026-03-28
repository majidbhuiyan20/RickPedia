import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/routes/route_manager.dart';
import 'features/characters/presentation/screens/character_list_screen.dart';

class RickPediaApp extends StatelessWidget {
  const RickPediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_,context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'RickPedia',
            theme: ThemeData(primarySwatch: Colors.blue),
            onGenerateRoute: RouteGenerator.getRoute,
            initialRoute: Routes.splashRoute,
          );
        }
    );
  }
}
