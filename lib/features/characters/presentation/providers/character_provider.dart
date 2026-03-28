import 'dart:async';
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
  DateTime? _lastRequestTime;
  int _retryCount = 0;
  Timer? _retryTimer;
  static const int _minRequestIntervalMs = 3000; // Minimum 3 second delay between requests

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

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    final cachedPage = await _repository.getCachedPageNumber();
    state = state.copyWith(currentPage: cachedPage);
    if (state.characters.isEmpty) {
      await fetchCharacters();
    }
  }

  Future<void> fetchCharacters() async {
    if (state.isLoading || !state.hasMorePages) return;

    // Cancel any pending retry timer
    _retryTimer?.cancel();

    // Rate limiting: enforce minimum delay between requests
    final now = DateTime.now();
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = now.difference(_lastRequestTime!);
      if (timeSinceLastRequest.inMilliseconds < _minRequestIntervalMs) {
        await Future.delayed(
          Duration(milliseconds: _minRequestIntervalMs - timeSinceLastRequest.inMilliseconds),
        );
      }
    }

    state = state.copyWith(isLoading: true, error: null);
    _lastRequestTime = DateTime.now();

    try {
      final newCharacters = await _repository.getCharacters(state.currentPage);
      _retryCount = 0; // Reset retry count on success

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
      final errorMsg = e.toString();
      
      // Check for rate limiting error (429)
      if (errorMsg.contains('429')) {
        // Implement exponential backoff for rate limiting
        _retryCount++;
        final backoffMs = (2000 * (_retryCount * _retryCount)).clamp(0, 30000); // Max 30 second backoff
        
        // Schedule retry using Timer (can be cancelled)
        _retryTimer = Timer(Duration(milliseconds: backoffMs), () {
          if (!state.isLoading && state.hasMorePages) {
            fetchCharacters();
          }
        });
      }
      
      state = state.copyWith(
        isLoading: false,
        error: errorMsg,
        hasMorePages: true,
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
