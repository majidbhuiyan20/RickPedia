// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_edit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterEditAdapter extends TypeAdapter<CharacterEdit> {
  @override
  final int typeId = 1;

  @override
  CharacterEdit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterEdit(
      characterId: fields[0] as int,
      editedName: fields[1] as String?,
      editedStatus: fields[2] as String?,
      editedSpecies: fields[3] as String?,
      editedType: fields[4] as String?,
      editedGender: fields[5] as String?,
      editedOrigin: fields[6] as String?,
      editedLocation: fields[7] as String?,
      editedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterEdit obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.characterId)
      ..writeByte(1)
      ..write(obj.editedName)
      ..writeByte(2)
      ..write(obj.editedStatus)
      ..writeByte(3)
      ..write(obj.editedSpecies)
      ..writeByte(4)
      ..write(obj.editedType)
      ..writeByte(5)
      ..write(obj.editedGender)
      ..writeByte(6)
      ..write(obj.editedOrigin)
      ..writeByte(7)
      ..write(obj.editedLocation)
      ..writeByte(8)
      ..write(obj.editedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterEditAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
