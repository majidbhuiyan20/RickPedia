import 'package:flutter/material.dart';
import 'package:rickpedia/core/constants/app_strings.dart';

import '../../features/characters/data/models/character.dart';
import '../../features/characters/presentation/screens/character_list_screen.dart';
import '../../features/characters/presentation/screens/character_edit_screen.dart';
import '../../features/character_detail/presentation/screens/character_detail_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/splash/screens/splash_screen.dart';

class Routes{
  static const String splashRoute="/";
  static const String characterListRoute="/characterListScreen";
  static const String characterDetailRoute="/characterDetailScreen";
  static const String characterEditRoute="/characterEditScreen";
  static const String favoritesRoute="/favoritesScreen";
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
      case Routes.characterDetailRoute:
        final character = routeSettings.arguments as Character;
        return MaterialPageRoute(
          builder: (_)=> CharacterDetailScreen(character: character),
        );
      case Routes.characterEditRoute:
        final character = routeSettings.arguments as Character;
        return MaterialPageRoute(
          builder: (_)=> CharacterEditScreen(character: character),
        );
      case Routes.favoritesRoute:
        return MaterialPageRoute(builder: (_)=> FavoritesScreen());

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