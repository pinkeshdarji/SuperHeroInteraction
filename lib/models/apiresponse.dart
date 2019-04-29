import 'package:json_annotation/json_annotation.dart';
import 'data.dart';

part 'apiresponse.g.dart';

@JsonSerializable()

class Apiresponse{

  Apiresponse(this.success,this.message,this.data);

  bool success;
  String message;
  Data data;


  factory Apiresponse.fromJson(Map<String, dynamic> json) => _$ApiresponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiresponseToJson(this);
}