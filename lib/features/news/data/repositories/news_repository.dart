import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../models/article_model.dart';

class NewsRepository {
  final Dio _dio;

  NewsRepository(this._dio);

  Future<List<ArticleModel>> getTopHeadlines({String? category, int page = 1, String? query}) async {
    try {
      final response = await _dio.get('top-headlines', queryParameters: {
        'country': 'us',
        if (category != null && category != 'All') 'category': category.toLowerCase(),
        'q': query,
        'page': page,
        'pageSize': 20,
      });

      if (response.statusCode == 200) {
        final newsData = NewsDataModel.fromJson(response.data);
        return newsData.articles;
      } else {
        throw ServerFailure('Failed to load news: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.unknown) {
        throw NetworkFailure();
      }
      throw ServerFailure(e.message ?? 'An error occurred');
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
        throw ServerFailure('Failed to search articles: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.unknown) {
        throw NetworkFailure();
      }
      throw ServerFailure(e.message ?? 'An error occurred');
    }
  }
}