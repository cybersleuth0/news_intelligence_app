import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui';
import '../providers/search_provider.dart';
import 'article_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasInput = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const primaryColor = Color(0xFF3713EC);
    final bgColor = isDark ? const Color(0xFF131022) : const Color(0xFFF6F6F8);
    final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
    final mutedTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? primaryColor.withValues(alpha: 0.1) : const Color(0xFFE2E8F0);
    final shimmerBaseColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor.withValues(alpha: 0.8),
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: mutedTextColor),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark ? primaryColor.withValues(alpha: 0.1) : const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _hasInput ? primaryColor.withValues(alpha: 0.5) : Colors.transparent,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Icon(Icons.search,
                                  color: _hasInput ? primaryColor : mutedTextColor, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: TextStyle(color: textColor, fontSize: 16),
                                  decoration: InputDecoration(
                                    hintText: 'Search for news, topics...',
                                    hintStyle: TextStyle(color: mutedTextColor, fontSize: 16),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onSubmitted: (val) {
                                    ref.read(searchProvider.notifier).search(val);
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      _hasInput = val.isNotEmpty;
                                    });
                                  },
                                ),
                              ),
                              if (_hasInput)
                                GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {
                                      _hasInput = false;
                                    });
                                    ref.read(searchProvider.notifier).search('');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, size: 14, color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: searchAsync.when(
        data: (articles) {
          if (articles.isEmpty) {
            return _buildEmptyState(isDark, primaryColor, textColor, mutedTextColor);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                  child: _buildResultCard(
                    isDark: isDark,
                    primaryColor: primaryColor,
                    textColor: textColor,
                    mutedTextColor: mutedTextColor,
                    imageUrl: article.urlToImage,
                    category: article.source.name ?? 'News',
                    title: article.title ?? 'No Title',
                    source: article.author ?? 'Unknown',
                    timeAgo: article.publishedAt != null ? article.publishedAt!.substring(0, 10) : '',
                  ),
                ),
              );
            },
          );
        },
        loading: () => _buildLoadingState(shimmerBaseColor, primaryColor, mutedTextColor),
        error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: textColor))),
      ),
    );
  }

  Widget _buildLoadingState(Color shimmerBaseColor, Color primaryColor, Color mutedTextColor) {
    final highlightColor = Theme.of(context).brightness == Brightness.dark 
        ? const Color(0xFF334155) 
        : Colors.grey[100]!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SEARCHING...',
            style: TextStyle(
              color: mutedTextColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Shimmer.fromColors(
                  baseColor: shimmerBaseColor,
                  highlightColor: highlightColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Container(width: double.infinity, height: 16, color: Colors.white),
                            const SizedBox(height: 8),
                            Container(width: 150, height: 16, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Color primaryColor, Color textColor, Color mutedTextColor) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.travel_explore,
                size: 72,
                color: primaryColor.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Search for any topic',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Discover the latest stories from around the world instantly.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mutedTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildSuggestionChip('#TechTrends', primaryColor),
                _buildSuggestionChip('#GlobalPolitics', primaryColor),
                _buildSuggestionChip('#ClimateAction', primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String label, Color primaryColor) {
    return GestureDetector(
      onTap: () {
        _searchController.text = label.replaceAll('#', '');
        setState(() => _hasInput = true);
        ref.read(searchProvider.notifier).search(_searchController.text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required bool isDark,
    required Color primaryColor,
    required Color textColor,
    required Color mutedTextColor,
    required String? imageUrl,
    required String category,
    required String title,
    required String source,
    required String timeAgo,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageUrl != null 
            ? Image.network(
                imageUrl,
                width: 96,
                height: 96,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 96,
                  height: 96,
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              )
            : Container(
                width: 96,
                height: 96,
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                child: const Icon(Icons.newspaper, color: Colors.grey),
              ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  if (timeAgo.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: mutedTextColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: mutedTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.newspaper, size: 14, color: mutedTextColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      source,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: mutedTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}