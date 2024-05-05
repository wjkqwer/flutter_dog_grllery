import 'package:json_annotation/json_annotation.dart';
import 'dog_image_entity.dart';

part 'favorite_image.g.dart';

@JsonSerializable(explicitToJson: true)
class FavoriteImage {
  final int id;
  final DogImageEntity image;

  FavoriteImage({required this.id, required this.image});

  factory FavoriteImage.fromJson(Map<String, dynamic> json) =>
      _$FavoriteImageFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteImageToJson(this);
}
