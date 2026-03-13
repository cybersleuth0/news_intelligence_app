import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<String> _categories = ['All (12)', 'Technology', 'Politics', 'Science'];
  int _selectedCategoryIndex = 0;

  final List<Map<String, String>> _articles = [
    {
      'id': '1',
      'title': 'How AI is Reshaping the Global Software Landscape',
      'category': 'Technology',
      'source': 'The Verge',
      'time': '3h ago',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuADTaOFNTqfq5v0M-05tTwmey1qYQJuXwdnMKOxFqB0sozARwX6Mp5zzrqyHH6zcAV3zNlLGxr9ZPThJ-bt_xanlYOzDG5nQDLTX5zanKOQJTkd2Tm6mezDVjW67vumpvgq3slcTTZBuRcnNyTi3oApboyZvM07VSzSbnoX8-i0OMuDEQGyMCwlvuw5jDx3S5SBDv9m2lNBF40llJ3foQafJ7Coz2IFV4nRtavC310ma4HNmYtxY0s9RrZpljUL-veRA5x0lmP-Dn4m',
    },
    {
      'id': '2',
      'title': 'New Insights from the Webb Telescope Challenge Big Bang Theories',
      'category': 'Science',
      'source': 'Science Daily',
      'time': 'Yesterday',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDOU-vycIcU36JXsJ8VEPTLpkOw5Ti5xHQyFrNB8kgy4KXmUBf1HyKZkKdpZGaQqoEOwjjbh1pqoZLPdPy-ShEd8aLZxAX9R7q_pYVFVsPQtYc8E9Sgj6hM-qq7s5qq04y1YTdf3Mnh43w00mxxpOJAsR41zQ0zKfxwpmRd4p3ZznFpx6swtNoH2XemzDWVuKAPpSzTZBedDSFY9bmZe1Ssa1bj8-Dw6G0B-tyniVWtEtgjAdV-roUQw_rehwRg6YqWatjG6Oi8T4TL',
    },
    {
      'id': '3',
      'title': 'Global Markets Braced for Upcoming Interest Rate Decisions',
      'category': 'Economy',
      'source': 'Bloomberg',
      'time': '2 days ago',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuC113JO4ZQ-YOKMn6f_hcq-tMTDvpGZrSm_vRq1AscDRBFfBTHMMSRIiyEw20mExKBAttbVUjgmvtYDwwX83hGGOYnbJtqIUnh87bcy5r7iKulZG38xbg3S0kYUnykqpH0t0f_A2RYgYajR_XXOBIqRO09cTcpYHfjIbwNrWcZB3YB0lAYYftCLhsh_ablA0Pdz1xnFD2oNIyeqT5Of53dv9XmZPrNuVaLAXWnijpppImXi1CKdxdsf2IccRObJg_r2aA8xw9ma69ps',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Stitch Colors (From HTML Tailwind config)
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
                  IconButton(
                    icon: Icon(Icons.more_vert, color: textColor),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Category Tabs
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: isDark ? primaryColor.withValues(alpha: 0.1) : const Color(0xFFE2E8F0))),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final isSelected = _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 24),
                    padding: const EdgeInsets.only(top: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? primaryColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                        color: isSelected ? primaryColor : mutedTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Article List
          Expanded(
            child: _articles.isEmpty
                ? _buildEmptyState(primaryColor, textColor, mutedTextColor)
                : ListView.builder(
                    itemCount: _articles.length,
                    padding: const EdgeInsets.only(bottom: 24),
                    itemBuilder: (context, index) {
                      final article = _articles[index];
                      return Dismissible(
                        key: Key(article['id']!),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            _articles.removeAt(index);
                          });
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
                                child: Image.network(
                                  article['imageUrl']!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 80,
                                    height: 80,
                                    color: isDark ? primaryColor.withValues(alpha: 0.2) : Colors.grey[200],
                                    child: const Icon(Icons.broken_image, color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article['category']!.toUpperCase(),
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          article['source']!,
                                          style: TextStyle(
                                            color: mutedTextColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
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
                                          article['time']!,
                                          style: TextStyle(
                                            color: mutedTextColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
    );
  }

  Widget _buildEmptyState(Color primaryColor, Color textColor, Color mutedTextColor) {
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
