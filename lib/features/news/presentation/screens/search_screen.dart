import 'package:flutter/material.dart';
import 'dart:ui';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _shimmerController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Stitch Colors (From HTML Tailwind config)
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
                              color: _isSearching ? primaryColor.withValues(alpha: 0.5) : Colors.transparent,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Icon(Icons.search,
                                  color: _isSearching ? primaryColor : mutedTextColor, size: 20),
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
                                  onChanged: (val) {
                                    setState(() {
                                      _isSearching = val.isNotEmpty;
                                    });
                                  },
                                ),
                              ),
                              if (_isSearching || true) // Always show like HTML mockup for perfection, or conditional? The HTML mockup shows it. 
                                GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {
                                      _isSearching = false;
                                    });
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildEmptyState(isDark, primaryColor, textColor, mutedTextColor),
            _buildSearchResults(isDark, primaryColor, textColor, mutedTextColor, shimmerBaseColor),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Color primaryColor, Color textColor, Color mutedTextColor) {
    return Padding(
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
    );
  }

  Widget _buildSuggestionChip(String label, Color primaryColor) {
    return Container(
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
    );
  }

  Widget _buildSearchResults(bool isDark, Color primaryColor, Color textColor, Color mutedTextColor, Color shimmerBaseColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECENT RESULTS',
            style: TextStyle(
              color: mutedTextColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 24),
          
          // Shimmer Card Example
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerBlock(width: 96, height: 96, borderRadius: 8, baseColor: shimmerBaseColor, primaryColor: primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    _buildShimmerBlock(width: double.infinity, height: 16, borderRadius: 4, baseColor: shimmerBaseColor, primaryColor: primaryColor),
                    const SizedBox(height: 8),
                    _buildShimmerBlock(width: 150, height: 16, borderRadius: 4, baseColor: shimmerBaseColor, primaryColor: primaryColor),
                    const SizedBox(height: 12),
                    _buildShimmerBlock(width: 80, height: 12, borderRadius: 4, baseColor: shimmerBaseColor, primaryColor: primaryColor),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Loaded Article Card 1
          _buildResultCard(
            isDark: isDark,
            primaryColor: primaryColor,
            textColor: textColor,
            mutedTextColor: mutedTextColor,
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDr3AUjtMT86S757AzzWM3wiLdw2tN3WDwb1Q9SSza_pc8AlNG_cMdDM9TCkPKPoxgPw0Wf8Qi8g77T9CM5icHjJ0_u6lb-6CE9ozFo2jEF6ZXBJsCDwpOXLy3eWHcMfY2cda_44sVGlKQhfjA_mgGSa2kQpSRMrVLYfokorIIhci4pUXf3TT3qxJhHzEl6P1msIyEAIEXLrAnae83jEmSy6RxQkDxPqoND79KkeVP58U40LC1xhnBo5lJvb5df1tZzNxTLwfTNeQUo',
            category: 'Tech',
            title: 'Quantum Computing Breakthrough: Researchers Achieve Stable Qubit State at Room Temp',
            source: 'Global Science Daily',
            timeAgo: '5m ago',
          ),
          const SizedBox(height: 24),
          
          // Loaded Article Card 2
          _buildResultCard(
            isDark: isDark,
            primaryColor: primaryColor,
            textColor: textColor,
            mutedTextColor: mutedTextColor,
            imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBkavcLn5riwDYx-TTtXT3zWDXbyftXwqfFCZYgsI1kf2_5kKFMrddu69DhsRwrie2rIQmpDTktOp6WCssFTNkuU7LcKTxOEofpQzyIVCzq09sZb5binzD5NYcml5l4GYm9w5BboCMclLJTWLFVZonbjwBgHIhIP1eJEUwX33VrHbHoVTGI4MMZniIfaO67v_fi_DCVpoe18bdMCdatLvAi_u2BiI4S5FxLg3r71kMIkXlUIQsl_xWXmK0CLDJIKacL8vDAYZrT-krY',
            category: 'World',
            title: 'New International Space Treaty Signed by 45 Nations to Regulate Lunar Mining',
            source: 'World Report Online',
            timeAgo: '2h ago',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required bool isDark,
    required Color primaryColor,
    required Color textColor,
    required Color mutedTextColor,
    required String imageUrl,
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
          child: Image.network(
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
                  Text(
                    source,
                    style: TextStyle(
                      color: mutedTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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

  Widget _buildShimmerBlock({
    required double width,
    required double height,
    required double borderRadius,
    required Color baseColor,
    required Color primaryColor,
  }) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.0, 0.5, 1.0],
              colors: [
                baseColor,
                primaryColor.withValues(alpha: 0.1),
                baseColor,
              ],
              transform: GradientRotation(_shimmerController.value * 2 * 3.14159),
            ),
          ),
        );
      },
    );
  }
}
