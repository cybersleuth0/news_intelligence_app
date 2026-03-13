import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../../data/models/article_model.dart';
import '../providers/news_provider.dart';
import 'article_detail_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  final List<String> _categories = [
    'All',
    'Business',
    'Technology',
    'Sports',
    'Health',
    'Science'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(newsFeedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsAsync = ref.watch(newsFeedProvider);
    final selectedCategory = ref.watch(categoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Stitch Colors (From HTML Tailwind config)
    const primaryColor = Color(0xFF3713EC);
    final bgColor = isDark ? const Color(0xFF131022) : const Color(0xFFF6F6F8);
    final bgHeaderColor = isDark ? const Color(0xFF131022).withValues(alpha: 0.8) : const Color(0xFFF6F6F8).withValues(alpha: 0.8);
    final borderColor = isDark ? primaryColor.withValues(alpha: 0.2) : const Color(0xFFE2E8F0);
    final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
    final mutedTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    
    final cardBgColor = isDark ? primaryColor.withValues(alpha: 0.05) : Colors.white;
    final cardBorderColor = isDark ? primaryColor.withValues(alpha: 0.1) : const Color(0xFFE2E8F0);
    
    final unselectedChipBgColor = isDark ? primaryColor.withValues(alpha: 0.1) : const Color(0xFFE2E8F0);
    final unselectedChipTextColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              backgroundColor: bgHeaderColor,
              elevation: 0,
              centerTitle: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(color: borderColor, height: 1.0),
              ),
              title: const Text(
                'NewsIQ',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    );
                  },
                  icon: Icon(Icons.search, color: isDark ? Colors.white : Colors.black87),
                  splashRadius: 20,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              children: _categories.map((category) {
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      ref.read(categoryProvider.notifier).state = category;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : unselectedChipBgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : unselectedChipTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // News Feed
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(newsFeedProvider.notifier).refresh(),
              child: newsAsync.when(
                data: (articles) => ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                  itemCount: articles.length + (newsAsync.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == articles.length) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ));
                    }
                    final article = articles[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailScreen(article: article),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: cardBorderColor),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Article Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: article.urlToImage != null 
                                ? Image.network(
                                    article.urlToImage!,
                                    width: 96,
                                    height: 96,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 96,
                                      height: 96,
                                      color: Colors.grey[800],
                                      child: const Icon(Icons.broken_image, color: Colors.grey),
                                    ),
                                  )
                                : Container(
                                    width: 96,
                                    height: 96,
                                    color: Colors.grey[800],
                                    child: const Icon(Icons.newspaper, color: Colors.grey),
                                  ),
                            ),
                            const SizedBox(width: 16),
                            // Article Content
                            Expanded(
                              child: SizedBox(
                                height: 96,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (article.source.name ?? 'News').toUpperCase(),
                                          style: const TextStyle(
                                            color: primaryColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
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
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          article.author ?? 'Unknown',
                                          style: TextStyle(
                                            color: mutedTextColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (article.publishedAt != null) ...[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
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
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: mutedTextColor,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home)),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.search)),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.favorite_border)),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person_outline)),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 1) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const SearchScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            } else if (index == 2) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const FavoritesScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            } else if (index == 3) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
