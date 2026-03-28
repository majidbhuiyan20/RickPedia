import 'package:hive/hive.dart';
import '../models/character.dart';

class FavoritesRepository {
  static const String _boxName = 'favorites';

  Future<Box<Character>> _getFavoritesBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<Character>(_boxName);
    }
    return await Hive.openBox<Character>(_boxName);
  }

  Future<void> toggleFavorite(Character character) async {
    final box = await _getFavoritesBox();
    
    if (box.containsKey(character.id)) {
      // If already favorited, remove it
      await box.delete(character.id);
    } else {
      // If not favorited, add it
      final updatedCharacter = Character(
        id: character.id,
        name: character.name,
        status: character.status,
        species: character.species,
        image: character.image,
        location: character.location,
        type: character.type,
        gender: character.gender,
        origin: character.origin,
        isFavorite: true,
      );
      await box.put(character.id, updatedCharacter);
    }
  }

  Future<void> addFavorite(Character character) async {
    final box = await _getFavoritesBox();
    final updatedCharacter = Character(
      id: character.id,
      name: character.name,
      status: character.status,
      species: character.species,
      image: character.image,
      location: character.location,
      type: character.type,
      gender: character.gender,
      origin: character.origin,
      isFavorite: true,
    );

    await box.put(character.id, updatedCharacter);
  }

  Future<void> removeFavorite(Character character) async {
    final box = await _getFavoritesBox();
    await box.delete(character.id);
  }

  Future<List<Character>> getFavorites() async {
    final box = await _getFavoritesBox();
    return box.values.toList();
  }

  Future<bool> isFavorite(int characterId) async {
    final box = await _getFavoritesBox();
    return box.containsKey(characterId);
  }
}
