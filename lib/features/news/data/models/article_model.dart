import 'package:hive_flutter/hive_flutter.dart';

class SourceModel {
  String? id;
  String? name;
  SourceModel({required this.id, required this.name});
  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(id: json["id"], name: json["name"]);
  }
}

class ArticleModel {
  String? author;
  String? content;
  String? description;
  String? publishedAt;
  SourceModel source;
  String? title;
  String? url;
  String? urlToImage;

  ArticleModel({
    required this.author,
    required this.content,
    required this.description,
    required this.publishedAt,
    required this.source,
    required this.title,
    required this.url,
    required this.urlToImage,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      author: json["author"],
      content: json["content"],
      description: json["description"],
      publishedAt: json["publishedAt"],
      source: SourceModel.fromJson(json["source"]),
      title: json["title"],
      url: json["url"],
      urlToImage: json["urlToImage"],
    );
  }
}

class NewsDataModel {
  String? status;
  int? totalResults;
  List<ArticleModel> articles;

  NewsDataModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsDataModel.fromJson(Map<String, dynamic> json) {
    List<ArticleModel> articles = [];
    for (Map<String, dynamic> eachnews in json["articles"]) {
      articles.add(ArticleModel.fromJson(eachnews));
    }
    return NewsDataModel(
      status: json["status"],
      totalResults: json["totalResults"],
      articles: articles,
    );
  }
}

// ─── Hive Adapters ───────────────────────────────────────

class SourceModelAdapter extends TypeAdapter<SourceModel> {
  @override
  final int typeId = 1;

  @override
  SourceModel read(BinaryReader reader) {
    return SourceModel(
      id: reader.readString(),
      name: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, SourceModel obj) {
    writer.writeString(obj.id ?? '');
    writer.writeString(obj.name ?? '');
  }
}

class ArticleModelAdapter extends TypeAdapter<ArticleModel> {
  @override
  final int typeId = 0;

  @override
  ArticleModel read(BinaryReader reader) {
    return ArticleModel(
      author: reader.readString(),
      content: reader.readString(),
      description: reader.readString(),
      publishedAt: reader.readString(),
      source: SourceModel(
        id: reader.readString(),
        name: reader.readString(),
      ),
      title: reader.readString(),
      url: reader.readString(),
      urlToImage: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, ArticleModel obj) {
    writer.writeString(obj.author ?? '');
    writer.writeString(obj.content ?? '');
    writer.writeString(obj.description ?? '');
    writer.writeString(obj.publishedAt ?? '');
    writer.writeString(obj.source.id ?? '');
    writer.writeString(obj.source.name ?? '');
    writer.writeString(obj.title ?? '');
    writer.writeString(obj.url ?? '');
    writer.writeString(obj.urlToImage ?? '');
  }
}