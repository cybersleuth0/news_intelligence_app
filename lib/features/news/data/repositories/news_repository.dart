import 'package:dio/dio.dart';
import '../models/article_model.dart';

class NewsRepository {
  final Dio _dio;

  NewsRepository(this._dio);

  Future<List<ArticleModel>> getTopHeadlines({String? category, int page = 1, String? query}) async {
    try {
      final response = await _dio.get('top-headlines', queryParameters: {
        'country': 'us',
        if (category != null && category != 'All') 'category': category.toLowerCase(),
        if (query != null) 'q': query,
        'page': page,
        'pageSize': 20,
      });

      if (response.statusCode == 200) {
        final newsData = NewsDataModel.fromJson(response.data);
        return newsData.articles;
      } else {
        throw Exception('Failed to load news');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'An error occurred');
    }
  }

  Future<List<ArticleModel>> searchArticles(String query, {int page = 1}) async {
    try {
      final response = await _dio.get('everything', queryParameters: {
        'q': query,
        'page': page,
        'pageSize': 20,
        'sortBy': 'publishedAt',
      });

      if (response.statusCode == 200) {
        final newsData = NewsDataModel.fromJson(response.data);
        return newsData.articles;
      } else {
        throw Exception('Failed to search articles');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'An error occurred');
    }
  }
}