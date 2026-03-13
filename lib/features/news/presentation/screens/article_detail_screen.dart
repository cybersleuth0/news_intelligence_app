import 'dart:ui';
import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Stitch Colors (From HTML Tailwind config)
    const primaryColor = Color(0xFF3713EC);
    final bgColor = isDark ? const Color(0xFF131022) : const Color(0xFFF6F6F8);
    final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A);
    final mutedTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    
    const heroImageUrl = 'https://lh3.googleusercontent.com/aida-public/AB6AXuDbGEvx7ZHkSQMd8Siq1RiJplN6Xe41MHeWg0esF6KwCMu9JSiHusvz2IrA0Nu3Iq7JFiVvWx9NPJzJlnZv4a87sy2C29iZTyd6xtTMXeTslHlPn57rV5-OTC1p8ZSYfheUHDq-hnuXkdxWnQeCyzcdPRaROQb8lOdtdoMw2RejbnBBz3hEFoFFSWsFOpWji6twAwRpI0QxAL_yseCUUMk4DA4SH-CsLPxLmqCdUR_feIuUXyZmuY0FCofbpnBwWEuIBjXcqBhqkKl-';
    const authorImageUrl = 'https://lh3.googleusercontent.com/aida-public/AB6AXuB_wF6NCXBIrHSnO3WuurIgBOZQTUp2aYprwAwQyLhC6xkUMkiyJNRyvgJ-wHG2nl28U2eYRGVhuLWqxa-FfhFUkKQTCBFixMnIYtGhyIkxZmTnWvVSgIFqeGSDIkJm_KRpymUesBkf45MQhml0GIIVbrD45zSquZBQzcJd71oxnXPGX91K0-Tb8Q1dHidgQq7BDQ1o94SZjbs2VHTabx3-9mOJ9B5YtXw9qEdzmrjX0d9pv2FcZEEjzaPskFHgDHvb0b6nz4Euck8Y';

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // Space for fixed bottom button
            child: Stack(
              children: [
                // Hero Image Section
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        heroImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: primaryColor.withValues(alpha: 0.2),
                          child: const Icon(Icons.broken_image, color: primaryColor, size: 48),
                        ),
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
                            _buildGlassButton(Icons.favorite_border, isDark, onTap: () {}),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Article Content (Overlaps the Hero Image by 64px)
                Padding(
                  padding: const EdgeInsets.only(top: 336), // 400 - 64
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
                          child: const Text(
                            'TECHNOLOGY',
                            style: TextStyle(
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
                          'The Future of Sustainable Energy: Innovations and Challenges in 2024',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 28, // Matches text-3xl roughly
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    authorImageUrl,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 40,
                                      height: 40,
                                      color: Colors.grey,
                                      child: const Icon(Icons.person, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Global News Network',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'By Sarah Jenkins • Oct 24, 2023',
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
                          'As the world grapples with the escalating climate crisis, the transition to sustainable energy sources has moved from a peripheral concern to a central global priority. Recent breakthroughs in solar cell efficiency and long-duration battery storage are reshaping the landscape of power generation.',
                          style: TextStyle(
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            fontSize: 18,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'However, significant hurdles remain in infrastructure modernization and political willpower. The integration of renewable sources into aging power grids requires not just new technology, but a fundamental shift in how we conceive of energy distribution. Decentralized microgrids are emerging as a viable solution for remote areas, while urban centers look toward massive offshore wind farms.',
                          style: TextStyle(
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            fontSize: 18,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Blockquote
                        Container(
                          padding: const EdgeInsets.only(left: 24, top: 24, bottom: 24, right: 16),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.05),
                            border: const Border(
                              left: BorderSide(color: primaryColor, width: 4),
                            ),
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                          ),
                          child: Text(
                            '"The next decade will determine whether we can successfully decouple economic growth from carbon emissions."',
                            style: TextStyle(
                              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        Text(
                          'Experts suggest that while the technology exists, the pace of adoption must triple to meet global targets. Investment in green hydrogen and advanced nuclear reactors continues to grow, offering hope for hard-to-abate sectors like heavy industry and shipping.',
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
                    onPressed: () {},
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

  Widget _buildGlassButton(IconData icon, bool isDark, {required VoidCallback onTap}) {
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
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}
