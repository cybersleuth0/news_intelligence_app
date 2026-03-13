import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/article_model.dart';
import '../providers/favorites_provider.dart';

class ArticleDetailScreen extends ConsumerWidget {
  final ArticleModel article;
  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.any((element) => element.url == article.url);
    
    const primaryColor = Color(0xFF3713EC);
    final bgColor = isDark ? const Color(0xFF131022) : const Color(0xFFF6F6F8);
    final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
    final mutedTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Stack(
              children: [
                // Hero Image Section
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (article.urlToImage != null)
                        Image.network(
                          article.urlToImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: primaryColor.withValues(alpha: 0.2),
                            child: const Icon(Icons.broken_image, color: primaryColor, size: 48),
                          ),
                        )
                      else
                        Container(
                          color: primaryColor.withValues(alpha: 0.2),
                          child: const Icon(Icons.newspaper, color: primaryColor, size: 48),
                        ),
                      // Gradient Overlay for Readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              bgColor,
                              bgColor.withValues(alpha: 0.2),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      // Top Controls (Back and Favorite)
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildGlassButton(Icons.arrow_back, isDark, onTap: () {
                              Navigator.of(context).pop();
                            }),
                            _buildGlassButton(
                              isFavorite ? Icons.favorite : Icons.favorite_border, 
                              isDark, 
                              color: isFavorite ? Colors.red : Colors.white,
                              onTap: () {
                                ref.read(favoritesProvider.notifier).toggleFavorite(article);
                              }
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Article Content
                Padding(
                  padding: const EdgeInsets.only(top: 336),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            (article.source.name ?? 'NEWS').toUpperCase(),
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Title
                        Text(
                          article.title ?? 'No Title',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Meta Info
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal: BorderSide(color: borderColor),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.person, color: primaryColor),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.author ?? 'Unknown Author',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      article.publishedAt != null 
                                          ? article.publishedAt!.substring(0, 10)
                                          : 'Unknown Date',
                                      style: TextStyle(
                                        color: mutedTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.share, color: mutedTextColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Article Body
                        Text(
                          article.description ?? 'No description available.',
                          style: TextStyle(
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            fontSize: 18,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          article.content ?? '',
                          style: TextStyle(
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            fontSize: 18,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Fixed Bottom Action Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    bgColor,
                    bgColor.withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (article.url != null) {
                        final uri = Uri.parse(article.url!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                      shadowColor: primaryColor.withValues(alpha: 0.5),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Read Full Article',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.open_in_new, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton(IconData icon, bool isDark, {required VoidCallback onTap, Color color = Colors.white}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            color: (isDark ? const Color(0xFF131022) : const Color(0xFFF6F6F8))
                .withValues(alpha: 0.4),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }
}
