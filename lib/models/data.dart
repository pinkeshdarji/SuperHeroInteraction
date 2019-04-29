import 'package:json_annotation/json_annotation.dart';
import 'character.dart';
part 'data.g.dart';

@JsonSerializable()

class Data{

  Data(this.characters);

  List<Character> characters;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
