import 'package:json_annotation/json_annotation.dart';
part 'character.g.dart';

@JsonSerializable()

class Character{

  Character(this.name,this.url,this.actor,this.description);

  String name;
  String url;
  String actor;
  String description;

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}
