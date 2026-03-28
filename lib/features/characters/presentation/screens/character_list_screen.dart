import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/character.dart';
import '../providers/character_provider.dart';
import '../providers/merged_character_provider.dart';
import '../providers/search_filter_provider.dart';
import '../widgets/character_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/search_filter_widget.dart';

class CharacterListScreen extends ConsumerStatefulWidget {
  const CharacterListScreen({super.key});

  @override
  ConsumerState<CharacterListScreen> createState() =>
      _CharacterListScreenState();
}

class _CharacterListScreenState extends ConsumerState<CharacterListScreen>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  double _lastScrollPosition = 0;
  bool _isRestoringScroll = false;
  int _lastCharacterCount = 0;
  bool _loadingTriggered = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Ignore scroll events during restoration
    if (_isRestoringScroll) return;

    // Store current scroll position
    _lastScrollPosition = _scrollController.position.pixels;

    // Load more characters - trigger when within 1000 pixels of bottom
    // Debounce: only trigger if we haven't already triggered a load
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 1500) {
      if (!_loadingTriggered) {
        final state = ref.read(characterListProvider);
        if (state.hasMorePages && !state.isLoading) {
          _loadingTriggered = true;
          ref.read(characterListProvider.notifier).fetchCharacters().then((_) {
            _loadingTriggered = false;
          });
        }
      }
    }
  }

  void _restoreScrollPosition() {
    // Only restore if we have valid scroll position and not currently loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _lastScrollPosition > 0 &&
          _lastScrollPosition < _scrollController.position.maxScrollExtent) {
        _isRestoringScroll = true;
        _scrollController.jumpTo(_lastScrollPosition);
        _isRestoringScroll = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final characterState = ref.watch(characterListProvider);
    final mergedCharactersAsync = ref.watch(mergedCharacterListProvider);
    final filterState = ref.watch(searchFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: const CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh from first page
          _lastScrollPosition = 0;
          await ref
              .read(characterListProvider.notifier)
              .refreshCharacters();
        },
        child: CustomScrollView(
          controller: _scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            // Search bar as SliverAppBar that hides on scroll
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: AppColors.primaryColor,
              elevation: 0,
              toolbarHeight: 80,
              flexibleSpace: const FlexibleSpaceBar(
                background: SearchFilterWidget(),
                collapseMode: CollapseMode.parallax,
              ),
            ),

            // Character grid with filters applied
            if (characterState.characters.isEmpty && characterState.isLoading)
              SliverFillRemaining(
                child: const Center(child: CircularProgressIndicator()),
              )
            else if (characterState.error != null &&
                characterState.characters.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        characterState.error ?? 'Error loading characters',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(characterListProvider.notifier)
                              .refreshCharacters();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else
              mergedCharactersAsync.when(
                loading: () => SliverFillRemaining(
                  child: const Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${error.toString()}',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                data: (mergedCharacters) {
                  // Apply filters and search to merged characters
                  final filteredCharacters = ref.watch(
                    filteredCharactersProvider(mergedCharacters),
                  );

                  // Only restore scroll position if new characters were added
                  if (filteredCharacters.length > _lastCharacterCount) {
                    _lastCharacterCount = filteredCharacters.length;
                    _restoreScrollPosition();
                  } else if (filteredCharacters.length < _lastCharacterCount) {
                    // Reset if list was cleared (e.g., filter changed)
                    _lastCharacterCount = filteredCharacters.length;
                    _lastScrollPosition = 0;
                  }

                  return _buildCharacterGridSliver(
                    context,
                    filteredCharacters,
                    filterState,
                    ref,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterGridSliver(
    BuildContext context,
    List<Character> characters,
    SearchFilterState filterState,
    WidgetRef ref,
  ) {
    if (characters.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No characters found',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverGrid(
      key: ValueKey(characters.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == characters.length) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final character = characters[index];
          return CharacterCard(character: character);
        },
        childCount: characters.length +
            (ref.watch(characterListProvider).isLoading ? 1 : 0),
      ),
    );
  }
}

