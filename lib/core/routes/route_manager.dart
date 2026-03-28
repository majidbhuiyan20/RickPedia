import 'package:flutter/material.dart';
import 'package:rickpedia/core/constants/app_strings.dart';

import '../../features/characters/presentation/screens/character_list_screen.dart';
import '../../features/splash/screens/splash_screen.dart';

class Routes{
  static const String splashRoute="/";
  static const String characterListRoute="/characterListScreen";
  static const String bottomNavBarRoute="/bottomNavbarRoute";
  static const String loginRoute="/loginScreen";

}
class RouteGenerator{
  static Route<dynamic>getRoute(RouteSettings routeSettings){
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_)=> SplashScreen());
      case Routes.characterListRoute:
        return MaterialPageRoute(builder: (_)=> CharacterListScreen());

      default:
        return unDefineRoute();
    }

  }
  static Route<dynamic>unDefineRoute(){
    return MaterialPageRoute(builder: (_)=>Scaffold(
      appBar: AppBar(title: Text(AppStrings.noRoute),),
      body: Center(child: Text(AppStrings.noRoute),),
    ));
  }
}