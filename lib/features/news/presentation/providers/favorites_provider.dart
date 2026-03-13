import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/utils/hive_helper.dart';
import '../../data/models/article_model.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<ArticleModel>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<List<ArticleModel>> {
  final Box<ArticleModel> _box = Hive.box<ArticleModel>(HiveHelper.favoritesBox);

  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  void _loadFavorites() {
    state = _box.values.toList();
  }

  Future<void> toggleFavorite(ArticleModel article) async {
    final key = article.url;
    if (key == null || key.isEmpty) return;

    if (_box.containsKey(key)) {
      await _box.delete(key);
    } else {
      await _box.put(key, article);
    }
    _loadFavorites();
  }

  bool isFavorite(String? url) {
    if (url == null) return false;
    return _box.containsKey(url);
  }
}