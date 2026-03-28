import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/character.dart';
import '../../data/models/character_edit.dart';
import '../../data/repositories/character_edit_repository.dart';

final characterEditRepositoryProvider = Provider((ref) {
  return CharacterEditRepository();
});

final characterEditProvider = FutureProvider.family<Character?, int>((ref, characterId) async {
  final repository = ref.watch(characterEditRepositoryProvider);
  return null;
});

class EditNotifier extends StateNotifier<CharacterEdit?> {
  final CharacterEditRepository _repository;
  final int _characterId;

  EditNotifier(this._repository, this._characterId) : super(null) {
    _initialize();
  }

  Future<void> _initialize() async {
    final edit = await _repository.getEdit(_characterId);
    state = edit;
  }

  Future<void> updateEdit({
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
    String? origin,
    String? location,
  }) async {
    final updatedEdit = CharacterEdit(
      characterId: _characterId,
      editedName: name,
      editedStatus: status,
      editedSpecies: species,
      editedType: type,
      editedGender: gender,
      editedOrigin: origin,
      editedLocation: location,
      editedAt: DateTime.now(),
    );

    await _repository.saveEdit(updatedEdit);
    state = updatedEdit;
  }

  Future<void> deleteEdit() async {
    await _repository.deleteEdit(_characterId);
    state = null;
  }

  Future<Character> getMergedCharacter(Character original) async {
    return await _repository.getMergedCharacter(original);
  }
}

final editProviderFamily =
    StateNotifierProvider.family<EditNotifier, CharacterEdit?, int>((ref, characterId) {
  final repository = ref.watch(characterEditRepositoryProvider);
  return EditNotifier(repository, characterId);
});
