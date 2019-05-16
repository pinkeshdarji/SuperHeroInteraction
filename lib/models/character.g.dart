// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) {
  return Character(
      json['name'] as String,
      json['url'] as String,
      json['actor'] as String,
      json['description'] as String,
      json['background'] as String);
}

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'actor': instance.actor,
      'description': instance.description,
      'background': instance.background
    };
