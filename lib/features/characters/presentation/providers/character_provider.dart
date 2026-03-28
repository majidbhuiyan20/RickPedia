import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/character.dart';
import '../../data/repositories/character_repository.dart';

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  final apiClient = ApiClient();
  return CharacterRepository(apiClient);
});

final characterListProvider =
    StateNotifierProvider<CharacterListNotifier, CharacterListState>((ref) {
  final repository = ref.watch(characterRepositoryProvider);
  return CharacterListNotifier(repository);
});

class CharacterListState {
  final List<Character> characters;
  final int currentPage;
  final bool isLoading;
  final bool hasMorePages;
  final String? error;

  CharacterListState({
    required this.characters,
    required this.currentPage,
    required this.isLoading,
    required this.hasMorePages,
    this.error,
  });

  CharacterListState copyWith({
    List<Character>? characters,
    int? currentPage,
    bool? isLoading,
    bool? hasMorePages,
    String? error,
  }) {
    return CharacterListState(
      characters: characters ?? this.characters,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      error: error ?? this.error,
    );
  }
}

class CharacterListNotifier extends StateNotifier<CharacterListState> {
  final CharacterRepository _repository;

  CharacterListNotifier(this._repository)
      : super(CharacterListState(
          characters: [],
          currentPage: 1,
          isLoading: false,
          hasMorePages: true,
          error: null,
        )) {
    _initialize();
  }

  Future<void> _initialize() async {
    final cachedPage = await _repository.getCachedPageNumber();
    state = state.copyWith(currentPage: cachedPage);
    if (state.characters.isEmpty) {
      await fetchCharacters();
    }
  }

  Future<void> fetchCharacters() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final newCharacters = await _repository.getCharacters(state.currentPage);

      if (newCharacters.isEmpty) {
        state = state.copyWith(
          hasMorePages: false,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          characters: [...state.characters, ...newCharacters],
          currentPage: state.currentPage + 1,
          isLoading: false,
          hasMorePages: true,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshCharacters() async {
    await _repository.clearCache();
    state = CharacterListState(
      characters: [],
      currentPage: 1,
      isLoading: false,
      hasMorePages: true,
      error: null,
    );
    await fetchCharacters();
  }
}
