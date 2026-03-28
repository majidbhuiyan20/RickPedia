import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 0)
class Character extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final String? location;

  @HiveField(6)
  final String? type;

  @HiveField(7)
  final String? gender;

  @HiveField(8)
  final String? origin;

  @HiveField(9)
  final bool isFavorite;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    this.location,
    this.type,
    this.gender,
    this.origin,
    this.isFavorite = false,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      image: json['image'] as String,
      location: json['location']?['name'] as String?,
      type: json['type'] as String?,
      gender: json['gender'] as String?,
      origin: json['origin']?['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'image': image,
      'location': location,
      'type': type,
      'gender': gender,
      'origin': origin,
      'isFavorite': isFavorite,
    };
  }
}
