import 'package:hive_flutter/hive_flutter.dart';
import '../../features/news/data/models/article_model.dart';

class HiveHelper {
  static const String favoritesBox = 'favorites';
  static const String authBox = 'auth';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SourceModelAdapter());
    Hive.registerAdapter(ArticleModelAdapter());
    await Hive.openBox<ArticleModel>(favoritesBox);
    await Hive.openBox(authBox);
  }
}