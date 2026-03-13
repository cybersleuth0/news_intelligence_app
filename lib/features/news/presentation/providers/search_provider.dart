import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/article_model.dart';
import 'news_provider.dart';

final searchProvider = AutoDisposeAsyncNotifierProvider<SearchNotifier, List<ArticleModel>>(SearchNotifier.new);

class SearchNotifier extends AutoDisposeAsyncNotifier<List<ArticleModel>> {
  @override
  Future<List<ArticleModel>> build() async {
    return []; // Start with an empty list
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(newsRepositoryProvider).searchArticles(query);
    });
  }
}