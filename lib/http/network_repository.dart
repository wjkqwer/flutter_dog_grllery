import 'package:dio/dio.dart';
import 'package:flutter_dog_gallery/http/api.dart';
import 'package:flutter_dog_gallery/model/dog_image_entity.dart';

import '../model/breed.dart';
import '../model/favorite_image.dart';
import '../model/vote_image.dart';

class NetworkRepository {
  final Dio _dio;
  static final _instance = NetworkRepository._();
  final String subId="taylor";

  NetworkRepository._() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: rootUrl,
      connectTimeout: Duration(seconds: 30),
      sendTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 60),
    );
  }

  //factory 对应java/kotlin中的静态方法，dart是单行线语言，不需要同步判断
  factory NetworkRepository() {
    return _instance;
  }

  //搜索图片(x-api-key是因为dog api要求),breedId
  Future<List<DogImageEntity>> searchImages({required int limit, int? breedId}) async {
    final response = await _dio.get(apiSearch,
        queryParameters: {"limit": limit,"mime_types":"jpg", "size": "med", "breed_ids": breedId},
        options: Options(headers: {
          "x-api-key": apiKey,
          "Content-Type": "application/json"
        }));
    if (response.statusCode == 200) {
      final List<dynamic> list = response.data ?? [];
      return list
          .map((e) => DogImageEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }

  //收藏
  Future<bool> addToFavorites({required String imageId}) async {
    final response = await _dio.post(apiFavorites,
        data: {"image_id": imageId,"sub_id":subId},
        options: Options(headers: {
          "x-api-key": apiKey,
          "Content-Type": "application/json"
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //点赞/点踩
  Future<bool> voteImage(
      {required String imageId, required bool isVote}) async {
    final response = await _dio.post(apiVotes,
        data: {"image_id": imageId, "value": isVote ? 1 : 0,"sub_id": subId},
        options: Options(headers: {
          "x-api-key": apiKey,
          "Content-Type": "application/json"
        }));
    return response.statusCode == 201;
  }

  //获取宠物种类列表
  Future<List<Breed>> getBreeds(
      {required int pageNumber, required int pageSize}) async {
    final response = await _dio.get(apiBreeds,
        queryParameters: {"limit": pageSize, "page": pageNumber},
        options: Options(headers: {
          "x-api-key": apiKey,
          "Content-Type": "application/json"
        }));
    if (response.statusCode == 200) {
      final List<dynamic> list = response.data ?? [];
      return list
          .map((e) => Breed.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<FavoriteImage>> getFavoriteImage() async {
    final response = await _dio.get(apiFavorites,
        queryParameters: {"sub_id": subId},
        options: Options(headers: {
          "x-api-key": apiKey,
          "Content-Type": "application/json"
        }));
    if (response.statusCode == 200) {
      final List<dynamic> list = response.data;
      return list
          .map((e) => FavoriteImage.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<VoteImage>> getVoteImage() async {
    final response = await _dio.get(apiVotes,
        queryParameters: {"sub_id": subId},
        options: Options(headers: {
          "x-api-key": apiKey,
          "Content-Type": "application/json"
        }));
    if (response.statusCode == 200) {
      final List<dynamic> list = response.data;
      return list
          .map((e) => VoteImage.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }
}
