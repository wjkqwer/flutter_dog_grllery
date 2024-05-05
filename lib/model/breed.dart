import 'package:json_annotation/json_annotation.dart';

import 'dog_image_entity.dart';

part 'breed.g.dart';

//类中还有子对象，使用@JsonSerializable(explicitToJson: true)，否则子对象字段会有问题
@JsonSerializable(explicitToJson: true)
class Breed {
  final int id;
  final String name;
  @JsonKey(name: "bred_for")
  final String? bredFor;
  final String? temperament;
  @JsonKey(name: "life_span")
  final String lifeSpan;
  final DogImageEntity image;

  const Breed(
      {required this.id,
      required this.name,
      required this.bredFor,
      required this.temperament,
      required this.lifeSpan,
      required this.image});

  factory Breed.fromJson(Map<String, dynamic> json) => _$BreedFromJson(json);

  Map<String, dynamic> toJson() => _$BreedToJson(this);
}
