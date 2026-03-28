import 'package:hive/hive.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/exceptions/api_exception.dart';
import '../models/character.dart';

class CharacterRepository {
  static const String _charactersBoxName = 'characters';
  static const String _pageNumberBoxName = 'pageNumber';

  final ApiClient _apiClient;

  CharacterRepository(this._apiClient);

  Future<List<Character>> getCharacters(int page) async {
    try {
      final data = await _apiClient.get(
        endpoint: '/character',
        queryParameters: {'page': page},
      );

      final List<dynamic> results = data['results'] as List<dynamic>;
      final characters =
          results.map((json) => Character.fromJson(json as Map<String, dynamic>)).toList();

      await _saveCharactersLocally(characters);
      await _savePageNumber(page);

      return characters;
    } on NetworkException {
      return _getCachedCharacters();
    }
  }

  Future<void> _saveCharactersLocally(List<Character> characters) async {
    final box = await Hive.openBox<Character>(_charactersBoxName);
    await box.addAll(characters);
  }

  Future<void> _savePageNumber(int page) async {
    final box = await Hive.openBox<int>(_pageNumberBoxName);
    await box.put('current', page);
  }

  Future<List<Character>> _getCachedCharacters() async {
    final box = await Hive.openBox<Character>(_charactersBoxName);
    return box.values.toList();
  }

  Future<int> getCachedPageNumber() async {
    final box = await Hive.openBox<int>(_pageNumberBoxName);
    return box.get('current', defaultValue: 1) ?? 1;
  }

  Future<void> clearCache() async {
    final box = await Hive.openBox<Character>(_charactersBoxName);
    await box.clear();
  }
}
