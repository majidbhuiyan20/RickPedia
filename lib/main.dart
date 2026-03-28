import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rickpedia/app.dart';
import 'features/characters/data/models/character.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CharacterAdapter());
  runApp(
    const ProviderScope(
      child: RickPediaApp(),
    ),
  );
}

