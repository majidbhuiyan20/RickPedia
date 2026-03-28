import 'package:hive/hive.dart';

part 'character_edit.g.dart';

@HiveType(typeId: 1)
class CharacterEdit extends HiveObject {
  @HiveField(0)
  final int characterId;

  @HiveField(1)
  final String? editedName;

  @HiveField(2)
  final String? editedStatus;

  @HiveField(3)
  final String? editedSpecies;

  @HiveField(4)
  final String? editedType;

  @HiveField(5)
  final String? editedGender;

  @HiveField(6)
  final String? editedOrigin;

  @HiveField(7)
  final String? editedLocation;

  @HiveField(8)
  final DateTime editedAt;

  CharacterEdit({
    required this.characterId,
    this.editedName,
    this.editedStatus,
    this.editedSpecies,
    this.editedType,
    this.editedGender,
    this.editedOrigin,
    this.editedLocation,
    required this.editedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'characterId': characterId,
      'editedName': editedName,
      'editedStatus': editedStatus,
      'editedSpecies': editedSpecies,
      'editedType': editedType,
      'editedGender': editedGender,
      'editedOrigin': editedOrigin,
      'editedLocation': editedLocation,
      'editedAt': editedAt.toIso8601String(),
    };
  }
}
