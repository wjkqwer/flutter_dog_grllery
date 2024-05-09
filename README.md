# dog_gallery

### 组件
    - PageView 类似viewpage
    - IndexedStack 类似viewpage，但是不能手势切换页面

### 库
    - 流式布局      flutter_staggered_grid_view:    https://pub.dev/packages/flutter_staggered_grid_view
    - 数据持久化    shared_preferences:             https://pub.dev/packages/shared_preferences
    - 网络访问      dio:                            https://pub-web.flutter-io.cn/packages/dio
    -             json_serializable              map转对象(使用json_serializable，执行下面一句，添加依赖)
                                                 flutter pub add json_annotation dev:build_runner dev:json_serializable
                                                在User类中添加 part 'user.g.dart';  @JsonSerializable()
                                                如果user类中还有子对象，使用@JsonSerializable(explicitToJson: true)，否则子对象字段会有问题
                                                执行：flutter pub run build_runner build --delete-conflicting-outputs 生成user.g.dart
