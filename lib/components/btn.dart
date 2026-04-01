import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game_game/theme/theme.dart';

class Btn extends StatelessWidget {
  final List<Color>? gradient;
  final Color? color;
  final double? height;
  final double? width;
  final GestureTapCallback? onTap;
  final double borderRadius;
  final Widget? child;

  const Btn({
    super.key,
    this.gradient,
    this.color,
    this.onTap,
    this.child,
    this.borderRadius = 12,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: MyTheme.animationNormal,
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color,
          gradient: gradient != null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient!,
                )
              : null,
          boxShadow: MyTheme.cardShadow,
        ),
        child: Center(child: child),
      ),
    );
  }
}
