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
                color: gradientColors.first.withValues(alpha: 0.4),
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
      builder: (_, _) {
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
                  colors: [color.withValues(alpha: 0.3), Colors.transparent],
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
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
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
                        // soundService.playSpotify();
                        _showWorkingonSoundDialog(context);
                      },
                    ),

                    const Spacer(),

                    _buildCreditsCard(),

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

  Future<dynamic> _showWorkingonSoundDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Warning '),
          content: Column(
            mainAxisSize: .min,
            children: [
              Text(
                'you are working on this feature, maybe coming soon',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: MyTheme.blue),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Ok',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: .bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}

Widget _buildCreditsCard() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 24.w),
    padding: EdgeInsets.all(18.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(MyTheme.radiusLarge),

      gradient: LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.15),
          Colors.white.withValues(alpha: 0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),

      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 25,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.05),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [MyTheme.blue, MyTheme.red]),
              ),
              child: CircleAvatar(
                radius: 22.r,
                backgroundColor: Colors.black,
                backgroundImage: AssetImage('images/ahmed.jpg'),
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "أحمد عماد صادق",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "شعبة حاسب • تصميم الألعاب التعليمية",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 14.h),

        Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),

        SizedBox(height: 12.h),

        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_rounded, color: Colors.white, size: 16.sp),
                SizedBox(width: 6.w),
                Text(
                  "تحت إشراف",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            Text(
              "د/ دنيا عبدالحميد الدخاخني",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              "د/ دعاء هيكل",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
