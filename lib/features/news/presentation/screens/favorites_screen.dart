import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
import 'article_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const primaryColor = Color(0xFF3713EC);
    final bgColor = isDark ? const Color(0xFF131022) : const Color(0xFFF6F6F8);
    final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
    final mutedTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? primaryColor.withValues(alpha: 0.2) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: 0.8),
            border: Border(bottom: BorderSide(color: borderColor)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    'Saved Articles',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder for balance
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Article List
          Expanded(
            child: favorites.isEmpty
                ? _buildEmptyState(context, primaryColor, textColor, mutedTextColor)
                : ListView.builder(
                    itemCount: favorites.length,
                    padding: const EdgeInsets.only(bottom: 24, top: 16),
                    itemBuilder: (context, index) {
                      final article = favorites[index];
                      return Dismissible(
                        key: Key(article.url ?? index.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          ref.read(favoritesProvider.notifier).toggleFavorite(article);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Article removed from saved')),
                          );
                        },
                        background: Container(
                          color: Colors.red[600],
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ArticleDetailScreen(article: article),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: isDark ? primaryColor.withValues(alpha: 0.1) : const Color(0xFFE2E8F0)),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: article.urlToImage != null
                                    ? Image.network(
                                        article.urlToImage!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 80,
                                          height: 80,
                                          color: isDark ? primaryColor.withValues(alpha: 0.2) : Colors.grey[200],
                                          child: const Icon(Icons.broken_image, color: Colors.grey),
                                        ),
                                      )
                                    : Container(
                                        width: 80,
                                        height: 80,
                                        color: isDark ? primaryColor.withValues(alpha: 0.2) : Colors.grey[200],
                                        child: const Icon(Icons.newspaper, color: Colors.grey),
                                      ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (article.source.name ?? 'News').toUpperCase(),
                                        style: const TextStyle(
                                          color: primaryColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        article.title ?? 'No Title',
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
                                          Flexible(
                                            child: Text(
                                              article.author ?? 'Unknown',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: mutedTextColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          if (article.publishedAt != null) ...[
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
                                              article.publishedAt!.substring(0, 10),
                                              style: TextStyle(
                                                color: mutedTextColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color primaryColor, Color textColor, Color mutedTextColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.bookmark,
            size: 48,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'No saved articles yet',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap the bookmark icon on any article to save it for later.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: mutedTextColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Explore News', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
