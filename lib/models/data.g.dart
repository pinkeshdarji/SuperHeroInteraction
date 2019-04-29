// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data((json['characters'] as List)
      ?.map((e) =>
          e == null ? null : Character.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$DataToJson(Data instance) =>
    <String, dynamic>{'characters': instance.characters};
