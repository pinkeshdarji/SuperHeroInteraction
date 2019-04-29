// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apiresponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Apiresponse _$ApiresponseFromJson(Map<String, dynamic> json) {
  return Apiresponse(
      json['success'] as bool,
      json['message'] as String,
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ApiresponseToJson(Apiresponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data
    };
