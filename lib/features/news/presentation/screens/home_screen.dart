import 'package:flutter/material.dart';
import 'dart:ui'; // Required for ImageFilter.blur
import 'article_detail_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Business',
    'Technology',
    'Sports',
    'Health',
    'Science'
  ];

  final List<Map<String, String>> _newsArticles = [
    {
      'category': 'Technology',
      'title': 'AI Breakthrough: New Model Mimics Human Reasoning Patterns',
      'source': 'TechCrunch',
      'time': '2h ago',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDEpLJvOS7Q8yrZPRARiO3mzP2zce56vVYtHb_aTacoPIhH6bUojJ0iSogUxoX0OhBu9Nvvw1NKuoRO8KYQMa5lrwYMCtvCnEy1HxCH4uwzpmZznJIGxo8yqGujIrEKaROkbfu8sTt7L6k4xQFMxjODgNupYP55UGXs05jytDmgdOJoPSMxzdRstjosR6IGrenDmoYylconoa_SLyocwJQW2E0mkrh_XZGi3FkUA-82Vu8FPX0O2y3owH09REuBPou3P34zcFNAXsNh',
    },
    {
      'category': 'Business',
      'title': 'Global Markets Reach Record Highs Amid Economic Optimism',
      'source': 'Bloomberg',
      'time': '4h ago',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDAuOgq7FyTo-91TMJnE3nEVs17L0qIwpm7GlDQwvnbCp9gOvgBJBi2GtgSylK-TBNzbE0d_0CdcuQLb7SX8R6FkLIhFgZaRx4Sc2bhbI1ItSG1Oop1nZHCln0YxVL-IRK0TsjkjKLfW9kKtLg0Zk9xHWlxN1WDzpL9IuKV5VviJqJk5KreoPBUfcptYn5TICEHsd9iYI3zHEUHhmbmVE5IB8mS3NHfHli3YylWKOoSh-EQrUf-f1x7zStT_s8o3Ijjv7_3uiS-tpOl',
    },
    {
      'category': 'Sports',
      'title': 'National Championship Finals: Underdog Secures Historic Victory',
      'source': 'ESPN',
      'time': '5h ago',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD9_pmfv4VYBifz59yJORmaLRP6bliZXJ2_FA7IxemAKNnF43-LvlvCMpNeebNAlt6f81xh1a7x7kPPZ5w6UmLVl-G9jf10xPG4HGMwGw72BCZsUOc4IBMtfMNytSIUxTmrixa1jDWWD4MsXwjimNC3tcAYBU2-ZnY6nTMI5C9eel-IHRmcTdZCUFl7-caaztB-kHAeLnfMKYG5AH3twwHngUrKcInw_YRnFzmrchChktTAd_3zJUSx8HjlyqU_LZ6O-xrksP4Z4un5',
    },
    {
      'category': 'Science',
      'title': 'Deep Sea Discovery: New Species Found Near Hydrothermal Vents',
      'source': 'National Geographic',
      'time': '8h ago',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDMA8FsU1TyvwwoNN-cyujIrH0lR1fVbje04Q5Cc4lg8e3jJYronhQHIF33IXLiL5Wro2H3GO7edNxd9t2pJIBqoDL54nsd6r5IXuK-sbqNHtknijxCU4PqUGEg-gSz69LoYzalsZLXbUayyy7MejnUHwKNeqrgFdMi_z68VYLeMCnFrcS3_veCncgS7j_hm9Zv1a_ZVTeRACFl9fym2ErCsWY0U3amJw2pNlB5VYF5nWzu4iw6N9iyJ1w3oo0_NbIthM183PmV15rt',
    },
    {
      'category': 'Health',
      'title': 'New Study Reveals Benefits of Plant-Based Diets for Longevity',
      'source': 'Healthline',
      'time': '12h ago',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAO2BPHOWZiGLEXGxUv0iS0wq2gww4V4SO9B1ofP7dOh5jNinir2o-ct4jBP3Kg44z3EVktQ8TiQ9fZmj7UyLY2w6xxzNgZymHMjs9Hb4ZJGuerynrmUvJo0uVFasYZice3LilvlTEFN9Y6l98vC0CWwZiRungWWQIPramVvXo_W40rGrRT19l0wIENXXd6ZYCxS1QpqwqfQMxjsCl4l5Hv_lxzY4o-l8jVig25wp9VvsqydhOD7iUafOrcYT8U0nO0tudl58Oyn43V',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Stitch Colors (From HTML Tailwind config)
    const primaryColor = Color(0xFF3713EC);
    final bgColor = isDark ? const Color(0xFF131022) : const Color(0xFFF6F6F8);
    final bgHeaderColor = isDark ? const Color(0xFF131022).withValues(alpha: 0.8) : const Color(0xFFF6F6F8).withValues(alpha: 0.8);
    final borderColor = isDark ? primaryColor.withValues(alpha: 0.2) : const Color(0xFFE2E8F0);
    final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
    final mutedTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    
    // Custom Colors from HTML specific to Home screen
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
                  onPressed: () {},
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
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
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
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              itemCount: _newsArticles.length,
              itemBuilder: (context, index) {
                final article = _newsArticles[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to the Article Detail Screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ArticleDetailScreen(),
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
                          child: Image.network(
                            article['imageUrl']!,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 96,
                              height: 96,
                              color: Colors.grey[800],
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Article Content
                        Expanded(
                          child: SizedBox(
                            height: 96, // Match image height constraint
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article['category']!.toUpperCase(),
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      article['title']!,
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
                                      article['source']!,
                                      style: TextStyle(
                                        color: mutedTextColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
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
                                      article['time']!,
                                      style: TextStyle(
                                        color: mutedTextColor,
                                        fontSize: 11,
                                      ),
                                    ),
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
