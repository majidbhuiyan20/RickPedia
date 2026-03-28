import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/character.dart';
import '../../data/repositories/favorites_repository.dart';

final favoritesRepositoryProvider = Provider((ref) {
  return FavoritesRepository();
});

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Character>>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(repository);
});

class FavoritesNotifier extends StateNotifier<List<Character>> {
  final FavoritesRepository _repository;

  FavoritesNotifier(this._repository) : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    final favorites = await _repository.getFavorites();
    state = favorites;
  }

  Future<void> toggleFavorite(Character character) async {
    await _repository.toggleFavorite(character);
    final isFav = await _repository.isFavorite(character.id);

    if (isFav) {
      // Only add if not already in the list
      if (!state.any((c) => c.id == character.id)) {
        state = [...state, character.copyWith(isFavorite: true)];
      }
    } else {
      state = state.where((c) => c.id != character.id).toList();
    }
  }

  Future<void> addFavorite(Character character) async {
    await _repository.addFavorite(character);
    if (!state.any((c) => c.id == character.id)) {
      state = [...state, character.copyWith(isFavorite: true)];
    }
  }

  Future<void> removeFavorite(Character character) async {
    await _repository.removeFavorite(character);
    state = state.where((c) => c.id != character.id).toList();
  }

  Future<void> refreshFavorites() async {
    final favorites = await _repository.getFavorites();
    state = favorites;
  }
}

extension CharacterCopy on Character {
  Character copyWith({
    int? id,
    String? name,
    String? status,
    String? species,
    String? image,
    String? location,
    String? type,
    String? gender,
    String? origin,
    bool? isFavorite,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      image: image ?? this.image,
      location: location ?? this.location,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      origin: origin ?? this.origin,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
