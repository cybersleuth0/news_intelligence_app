import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/article_model.dart';
import '../../data/repositories/news_repository.dart';

final newsRepositoryProvider = Provider((ref) => NewsRepository(DioClient.instance));

final categoryProvider = StateProvider<String>((ref) => 'All');

final newsFeedProvider = AsyncNotifierProvider<NewsFeedNotifier, List<ArticleModel>>(() {
  return NewsFeedNotifier();
});

class NewsFeedNotifier extends AsyncNotifier<List<ArticleModel>> {
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  Future<List<ArticleModel>> build() async {
    _currentPage = 1;
    _hasMore = true;
    final category = ref.watch(categoryProvider);
    return _fetchNews(category: category);
  }

  Future<List<ArticleModel>> _fetchNews({String? category, int page = 1}) async {
    return ref.read(newsRepositoryProvider).getTopHeadlines(category: category, page: page);
  }

  Future<void> loadMore() async {
    if (state.isLoading || !_hasMore) return;

    final category = ref.read(categoryProvider);
    final nextPage = _currentPage + 1;
    
    try {
      final moreNews = await _fetchNews(category: category, page: nextPage);
      if (moreNews.isEmpty) {
        _hasMore = false;
      } else {
        _currentPage = nextPage;
        state = AsyncData([...state.value ?? [], ...moreNews]);
      }
    } catch (e) {
      // Don't change state to error to keep showing existing items, 
      // maybe use a separate state for pagination error if needed.
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      _currentPage = 1;
      _hasMore = true;
      final category = ref.read(categoryProvider);
      return _fetchNews(category: category);
    });
  }
}