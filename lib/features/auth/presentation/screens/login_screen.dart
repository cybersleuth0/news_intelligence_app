import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../news/presentation/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    // In a real app, you would authenticate here.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Stitch Colors (From HTML Tailwind config)
    const primaryColor = Color(0xFF3713EC); 
    final bgColor = isDark ? const Color(0xFF131022) : const Color(0xFFF6F6F8);
    final cardBgColor = isDark ? const Color(0xFF0F172A).withValues(alpha: 0.5) : Colors.white; // dark:bg-slate-900/50
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0); // dark:border-slate-800
    final textColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A); // dark:text-slate-100
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569); // dark:text-slate-400
    final inputBgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC); // dark:bg-slate-900
    final linkColor = isDark ? primaryColor : primaryColor;
    
    // Abstract Background Colors (From HTML abstract background pattern)
    // <div class="absolute top-[-10%] ... bg-primary/20 blur-[120px] rounded-full"></div>
    final blob1Color = primaryColor.withValues(alpha: 0.2); 
    // <div class="absolute bottom-[-10%] ... bg-primary/10 blur-[120px] rounded-full"></div>
    final blob2Color = primaryColor.withValues(alpha: 0.1); 

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Abstract Background Pattern Component
          Positioned(
            top: -MediaQuery.of(context).size.height * 0.1,
            left: -MediaQuery.of(context).size.width * 0.1,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: blob1Color,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -MediaQuery.of(context).size.height * 0.1,
            right: -MediaQuery.of(context).size.width * 0.1,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: blob2Color,
                ),
              ),
            ),
          ),
          // Top Decorative line
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    primaryColor.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400), // max-w-md
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo and Header Section
                    Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12), // rounded-xl
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.insights,
                              size: 36,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24), // mb-6
                        Text(
                          'NewsIQ',
                          style: TextStyle(
                            fontSize: 30, // text-3xl
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            letterSpacing: -0.5, // tracking-tight
                          ),
                        ),
                        const SizedBox(height: 8), // mt-2
                        Text(
                          'Access institutional-grade market intelligence',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32), // space-y-8
                    
                    // Login Form Card
                    Container(
                      padding: const EdgeInsets.all(32), // p-8
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(12), // rounded-xl
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20, // shadow-xl approx
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Work Email
                          Text(
                            'Work Email',
                            style: TextStyle(
                              fontSize: 14, // text-sm
                              fontWeight: FontWeight.w500, // font-medium
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 8), // mb-2
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: inputBgColor,
                              hintText: 'name@company.com',
                              hintStyle: const TextStyle(color: Color(0xFF64748B)),
                              prefixIcon: const Icon(Icons.mail_outline, color: Color(0xFF94A3B8)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8), // rounded-lg
                                borderSide: BorderSide(color: borderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: primaryColor, width: 2), // ring-2 ring-primary/50 equivalent visual focus effect...
                              ),
                            ),
                          ),
                          const SizedBox(height: 24), // space-y-6

                          // Password Label & Forgot
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {}, // Forgot password action
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    fontSize: 12, // text-xs
                                    fontWeight: FontWeight.w600, // font-semibold
                                    color: linkColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8), // mb-2
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: inputBgColor,
                              hintText: '••••••••',
                              hintStyle: const TextStyle(color: Color(0xFF64748B)),
                              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF94A3B8)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: const Color(0xFF94A3B8),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: primaryColor, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Remember Me
                          Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (val) {
                                    setState(() {
                                      _rememberMe = val ?? false;
                                    });
                                  },
                                  activeColor: primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), // rounded
                                  side: BorderSide(color: borderColor), // border-slate-300
                                ),
                              ),
                              const SizedBox(width: 8), // ml-2
                              Expanded(
                                child: Text(
                                  'Stay signed in for 30 days',
                                  style: TextStyle(
                                    fontSize: 14, // text-sm
                                    color: subtitleColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Login btn
                          ElevatedButton(
                            onPressed: _signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14), // py-3.5
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8), // rounded-lg
                              ),
                              elevation: 1, // shadow-sm
                            ),
                            child: const Text(
                              'Sign in to Dashboard',
                              style: TextStyle(
                                fontSize: 14, // text-sm
                                fontWeight: FontWeight.w600, // font-semibold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Footer Info
                    Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: subtitleColor,
                            ),
                            children: [
                              TextSpan(
                                text: 'Contact sales for a demo',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: linkColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 24,
                          runSpacing: 8,
                          children: [
                            Text(
                              'Privacy Policy',
                              style: TextStyle(fontSize: 12, color: subtitleColor),
                            ),
                            Text(
                              'Terms of Service',
                              style: TextStyle(fontSize: 12, color: subtitleColor),
                            ),
                            Text(
                              'Security',
                              style: TextStyle(fontSize: 12, color: subtitleColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
