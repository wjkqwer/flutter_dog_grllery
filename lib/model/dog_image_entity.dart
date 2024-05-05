import 'package:json_annotation/json_annotation.dart';

part 'dog_image_entity.g.dart';

@JsonSerializable()
class DogImageEntity {
  final String id;
  final String url;

  DogImageEntity({required this.id, required this.url});

  factory DogImageEntity.fromJson(Map<String, dynamic> json) =>
      _$DogImageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DogImageEntityToJson(this);
}
