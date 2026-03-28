import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/character.dart';
import '../../data/repositories/character_edit_repository.dart';
import '../../data/repositories/character_repository.dart';
import './character_provider.dart';
import './edit_provider.dart';

final characterEditRepositoryProvider = Provider((ref) {
  return CharacterEditRepository();
});

// Provider that merges character data with edits for a specific character
final mergedCharacterProvider =
    FutureProvider.family<Character, Character>((ref, character) async {
  final editRepository = ref.watch(characterEditRepositoryProvider);
  return editRepository.getMergedCharacter(character);
});

// Provider that merges all characters in the list with their edits
final mergedCharacterListProvider =
    FutureProvider<List<Character>>((ref) async {
  final characterState = ref.watch(characterListProvider);
  final editRepository = ref.watch(characterEditRepositoryProvider);

  if (characterState.characters.isEmpty) {
    return [];
  }

  final mergedCharacters = <Character>[];
  for (final character in characterState.characters) {
    final merged = await editRepository.getMergedCharacter(character);
    mergedCharacters.add(merged);
  }

  return mergedCharacters;
});

// Provider that gets ALL cached characters merged with edits
final allMergedCachedCharactersProvider =
    FutureProvider<List<Character>>((ref) async {
  final characterRepository = ref.watch(characterRepositoryProvider);
  final editRepository = ref.watch(characterEditRepositoryProvider);

  // Get all cached characters
  final cachedCharacters = await characterRepository.getAllCachedCharacters();

  if (cachedCharacters.isEmpty) {
    return [];
  }

  // Merge each with edits
  final mergedCharacters = <Character>[];
  for (final character in cachedCharacters) {
    final merged = await editRepository.getMergedCharacter(character);
    mergedCharacters.add(merged);
  }

  return mergedCharacters;
});
