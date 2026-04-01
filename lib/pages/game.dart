import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tic_tac_toe_game_game/components/board.dart';
import 'package:tic_tac_toe_game_game/components/o.dart';
import 'package:tic_tac_toe_game_game/components/x.dart';
import 'package:tic_tac_toe_game_game/pages/pick.dart';
import 'package:tic_tac_toe_game_game/pages/settings.dart';
import 'package:tic_tac_toe_game_game/services/board.dart';
import 'package:tic_tac_toe_game_game/services/provider.dart';
import 'package:tic_tac_toe_game_game/theme/theme.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> with TickerProviderStateMixin {
  final boardService = locator<BoardService>();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          boardService.newGame();
        }
      },
      child: Scaffold(
        backgroundColor: MyTheme.background,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(gradient: MyTheme.primaryGradient),
          child: SafeArea(
            child: StreamBuilder<MapEntry<int, int>>(
              stream: boardService.score$,
              builder: (context, AsyncSnapshot<MapEntry<int, int>> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                final int xScore = snapshot.data!.key;
                final int oScore = snapshot.data!.value;

                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            // Player score section
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 16.h,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  _buildScoreBadge(xScore, 40.w),
                                  Expanded(child: Container()),
                                  groupValue == 'X'
                                      ? X(35.w, 10)
                                      : O(35.w, MyTheme.blue),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                    ),
                                    child: Text(
                                      'Player',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        shadows: const [
                                          Shadow(
                                            color: Color(0x40000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Board section
                            const Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[Board()],
                            ),

                            // Computer score section
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 16.h,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  groupValue == 'X'
                                      ? O(35.w, MyTheme.blue)
                                      : X(35.w, 10),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                    ),
                                    child: Text(
                                      'Computer',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        shadows: const [
                                          Shadow(
                                            color: Color(0x40000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  _buildScoreBadge(oScore, 40.w),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom action buttons
                      Container(
                        height: 70.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildActionButton(
                              icon: Icons.home_rounded,
                              onPressed: () {
                                boardService.newGame();
                                Navigator.of(
                                  context,
                                ).popUntil((route) => route.isFirst);
                              },
                              size: 40.w,
                            ),
                            SizedBox(width: 16.w),
                            _buildActionButton(
                              icon: Icons.refresh_rounded,
                              onPressed: () {
                                boardService.newGame();
                              },
                              size: 40.w,
                            ),
                            SizedBox(width: 16.w),
                            _buildActionButton(
                              icon: Icons.settings_rounded,
                              onPressed: () {
                                boardService.newGame();
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => const SettingsPage(),
                                  ),
                                );
                              },
                              size: 40.w,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBadge(int score, double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: MyTheme.elevatedShadow,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '$score',
          style: TextStyle(
            color: MyTheme.textPrimary,
            fontSize: size * 0.45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required double size,
  }) {
    return Container(
      height: size + 10.h,
      width: size + 10.w,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(MyTheme.radiusMedium),
        boxShadow: MyTheme.cardShadow,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(MyTheme.radiusMedium),
          child: Center(
            child: Icon(icon, color: MyTheme.gradientMiddle, size: size),
          ),
        ),
      ),
    );
  }
}
