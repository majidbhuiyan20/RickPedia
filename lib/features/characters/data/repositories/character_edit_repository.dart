import 'package:hive/hive.dart';
import '../models/character.dart';
import '../models/character_edit.dart';

class CharacterEditRepository {
  static const String _boxName = 'character_edits';

  Future<Box<CharacterEdit>> _getEditsBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<CharacterEdit>(_boxName);
    }
    return await Hive.openBox<CharacterEdit>(_boxName);
  }

  Future<void> saveEdit(CharacterEdit edit) async {
    final box = await _getEditsBox();
    await box.put(edit.characterId, edit);
  }

  Future<CharacterEdit?> getEdit(int characterId) async {
    final box = await _getEditsBox();
    return box.get(characterId);
  }

  Future<Character> getMergedCharacter(Character original) async {
    final edit = await getEdit(original.id);

    if (edit == null) {
      return original;
    }

    return Character(
      id: original.id,
      name: edit.editedName ?? original.name,
      status: edit.editedStatus ?? original.status,
      species: edit.editedSpecies ?? original.species,
      image: original.image,
      location: edit.editedLocation ?? original.location,
      type: edit.editedType ?? original.type,
      gender: edit.editedGender ?? original.gender,
      origin: edit.editedOrigin ?? original.origin,
      isFavorite: original.isFavorite,
    );
  }

  Future<void> deleteEdit(int characterId) async {
    final box = await _getEditsBox();
    await box.delete(characterId);
  }
}
