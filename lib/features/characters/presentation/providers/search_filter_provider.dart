import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/character.dart';
import './merged_character_provider.dart';

/// State for search and filter functionality
class SearchFilterState {
  final String searchQuery;
  final String? statusFilter;
  final String? speciesFilter;

  SearchFilterState({
    this.searchQuery = '',
    this.statusFilter,
    this.speciesFilter,
  });

  SearchFilterState copyWith({
    String? searchQuery,
    String? statusFilter,
    String? speciesFilter,
  }) {
    return SearchFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      speciesFilter: speciesFilter ?? this.speciesFilter,
    );
  }

  void clear() {
    searchQuery;
    statusFilter;
    speciesFilter;
  }
}

/// Provider for search and filter state
final searchFilterProvider =
    StateNotifierProvider<SearchFilterNotifier, SearchFilterState>((ref) {
  return SearchFilterNotifier();
});

/// Notifier for managing search and filter state
class SearchFilterNotifier extends StateNotifier<SearchFilterState> {
  SearchFilterNotifier() : super(SearchFilterState());

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateStatusFilter(String? status) {
    state = state.copyWith(statusFilter: status);
  }

  void updateSpeciesFilter(String? species) {
    state = state.copyWith(speciesFilter: species);
  }

  void clearFilters() {
    state = SearchFilterState();
  }

  bool hasActiveFilters() {
    return state.searchQuery.isNotEmpty ||
        state.statusFilter != null ||
        state.speciesFilter != null;
  }
}

/// Provider for available filter options
final availableStatusProvider = Provider<List<String>>((ref) {
  return ['Alive', 'Dead', 'unknown'];
});

final availableSpeciesProvider = Provider<List<String>>((ref) {
  return [
    'Human',
    'Alien',
    'Humanoid',
    'Poopybutthole',
    'Mythological Creature',
    'Animal',
    'Robot',
    'Cronenberg',
    'Disease'
  ];
});

/// Provider for filtered characters
final filteredCharactersProvider =
    Provider.family<List<Character>, List<Character>>((ref, characters) {
  final filters = ref.watch(searchFilterProvider);

  List<Character> filtered = characters;

  // Apply search filter
  if (filters.searchQuery.isNotEmpty) {
    filtered = filtered
        .where((character) => character.name
            .toLowerCase()
            .contains(filters.searchQuery.toLowerCase()))
        .toList();
  }

  // Apply status filter
  if (filters.statusFilter != null && filters.statusFilter!.isNotEmpty) {
    filtered = filtered
        .where((character) =>
            character.status.toLowerCase() ==
            filters.statusFilter!.toLowerCase())
        .toList();
  }

  // Apply species filter
  if (filters.speciesFilter != null && filters.speciesFilter!.isNotEmpty) {
    filtered = filtered
        .where((character) =>
            character.species.toLowerCase() ==
            filters.speciesFilter!.toLowerCase())
        .toList();
  }

  return filtered;
});

/// Provider for comprehensive search across ALL characters
/// This searches the entire character dataset, not just displayed ones
final comprehensiveSearchProvider =
    FutureProvider.family<List<Character>, List<Character>>(
        (ref, allCharacters) async {
  final filters = ref.watch(searchFilterProvider);

  List<Character> filtered = allCharacters;

  // Apply search filter
  if (filters.searchQuery.isNotEmpty) {
    filtered = filtered
        .where((character) => character.name
            .toLowerCase()
            .contains(filters.searchQuery.toLowerCase()))
        .toList();
  }

  // Apply status filter
  if (filters.statusFilter != null && filters.statusFilter!.isNotEmpty) {
    filtered = filtered
        .where((character) =>
            character.status.toLowerCase() ==
            filters.statusFilter!.toLowerCase())
        .toList();
  }

  // Apply species filter
  if (filters.speciesFilter != null && filters.speciesFilter!.isNotEmpty) {
    filtered = filtered
        .where((character) =>
            character.species.toLowerCase() ==
            filters.speciesFilter!.toLowerCase())
        .toList();
  }

  return filtered;
});

/// Provider for comprehensive search on all cached characters
final comprehensiveSearchResultsProvider = FutureProvider<List<Character>>((ref) async {
  final allMergedCharacters = await ref.watch(allMergedCachedCharactersProvider.future);
  final filters = ref.watch(searchFilterProvider);

  List<Character> filtered = allMergedCharacters;

  // Apply search filter
  if (filters.searchQuery.isNotEmpty) {
    filtered = filtered
        .where((character) => character.name
            .toLowerCase()
            .contains(filters.searchQuery.toLowerCase()))
        .toList();
  }

  // Apply status filter
  if (filters.statusFilter != null && filters.statusFilter!.isNotEmpty) {
    filtered = filtered
        .where((character) =>
            character.status.toLowerCase() ==
            filters.statusFilter!.toLowerCase())
        .toList();
  }

  // Apply species filter
  if (filters.speciesFilter != null && filters.speciesFilter!.isNotEmpty) {
    filtered = filtered
        .where((character) =>
            character.species.toLowerCase() ==
            filters.speciesFilter!.toLowerCase())
        .toList();
  }

  return filtered;
});
