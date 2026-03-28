import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rickpedia/app.dart';
import 'features/characters/data/models/character.dart';
import 'features/characters/data/models/character_edit.dart';

void main() async {
  await Hive.initFlutter();
  try {
    await Hive.deleteBoxFromDisk('characters');
  } catch (e) {
    
  }
  
  Hive.registerAdapter(CharacterAdapter());
  Hive.registerAdapter(CharacterEditAdapter());
  runApp(
    const ProviderScope(
      child: RickPediaApp(),
    ),
  );
}

