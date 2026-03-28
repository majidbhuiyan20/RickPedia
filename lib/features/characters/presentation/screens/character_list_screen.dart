import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/character_provider.dart';
import '../widgets/character_card.dart';
import '../widgets/custom_app_bar.dart';

class CharacterListScreen extends ConsumerStatefulWidget {
  const CharacterListScreen({super.key});

  @override
  ConsumerState<CharacterListScreen> createState() =>
      _CharacterListScreenState();
}

class _CharacterListScreenState extends ConsumerState<CharacterListScreen> {
  late ScrollController _scrollController;

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
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final state = ref.read(characterListProvider);
      if (state.hasMorePages && !state.isLoading) {
        ref.read(characterListProvider.notifier).fetchCharacters();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final characterState = ref.watch(characterListProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: const CustomAppBar(),
      body: characterState.characters.isEmpty && characterState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : characterState.error != null && characterState.characters.isEmpty
              ? Center(
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
                )
              : RefreshIndicator(
                  onRefresh: () {
                    return ref
                        .read(characterListProvider.notifier)
                        .refreshCharacters();
                  },
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    padding: const EdgeInsets.all(8),
                    itemCount: characterState.characters.length +
                        (characterState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == characterState.characters.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final character = characterState.characters[index];
                      return CharacterCard(character: character);
                    },
                  ),
                ),
    );
  }
}

