import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tic_tac_toe_game_game/pages/pick.dart';
import 'package:tic_tac_toe_game_game/pages/settings.dart';
import 'package:tic_tac_toe_game_game/services/provider.dart';
import 'package:tic_tac_toe_game_game/services/sound.dart';
import 'package:tic_tac_toe_game_game/theme/theme.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  final soundService = locator<SoundService>();

  late AnimationController _floatingController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotationController);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Widget _buildGlassButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    required List<Color> gradientColors,
  }) {
    return GestureDetector(
      onTap: () async {
        // await soundService.playClick();
        onTap();
      },
      child: AnimatedScale(
        scale: 1,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 65.h,
          width: 280.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MyTheme.radiusLarge),
            gradient: LinearGradient(colors: gradientColors),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withOpacity(0.4),
                blurRadius: 20.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 26.sp),
                SizedBox(width: 10.w),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔥 Floating Shapes
  Widget _floatingShape(double size, Color color, double top, double left) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (_, __) {
        return Positioned(
          top: top,
          left: left,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Container(
              width: size.w,
              height: size.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [color.withOpacity(0.3), Colors.transparent],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
          ),
        ),
        child: Stack(
          children: [
            _floatingShape(200, Colors.white, 80, -50),
            _floatingShape(150, MyTheme.blue, 400, 300),
            _floatingShape(180, MyTheme.red, 200, 250),

            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const SettingsPage(),
                            ),
                          );
                        },
                      ),
                    ),

                    AnimatedBuilder(
                      animation: _floatingAnimation,
                      builder: (_, child) => Transform.translate(
                        offset: Offset(0, _floatingAnimation.value),
                        child: child,
                      ),
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (_, child) => Transform.scale(
                          scale: _pulseAnimation.value,
                          child: child,
                        ),
                        child: CircleAvatar(
                          radius: 60.r,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Image.asset('images/logo2.png'),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Text(
                      "Tic Tac Toe",
                      style: TextStyle(
                        fontSize: 42.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      "Challenge the AI",
                      style: TextStyle(color: Colors.white70),
                    ),

                    SizedBox(height: 30.h),

                    _buildGlassButton(
                      text: "PLAY NOW",
                      icon: Icons.play_arrow,
                      gradientColors: const [
                        Color(0xFF667eea),
                        Color(0xFF764ba2),
                      ],
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (_) => const PickPage()),
                        );
                      },
                    ),

                    SizedBox(height: 16.h),

                    _buildGlassButton(
                      text: "PLAY MUSIC",
                      icon: Icons.music_note,
                      gradientColors: const [
                        Color(0xFFf093fb),
                        Color(0xFFf5576c),
                      ],
                      onTap: () {
                        soundService.playSpotify();
                      },
                    ),

                    const Spacer(),

                    _infoCard(
                      "أحمد عماد صادق",
                      "شعبة حاسب • تصميم الألعاب التعليمية",
                    ),

                    SizedBox(height: 12.h),

                    _infoCard(
                      "تحت إشراف",
                      "د/ دنيا عبدالحميد الدخاخني\nد/ دعاء هيكل",
                      isTitle: true,
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String subtitle, {bool isTitle = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(MyTheme.radiusLarge),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isTitle ? 16.sp : 18.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}
