import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tic_tac_toe_game_game/theme/theme.dart';

class AlertService {
  late AlertStyle _resultAlertStyle;
  AlertStyle get resultAlertStyle => _resultAlertStyle;

  late AlertStyle _settingsAlertStyle;
  AlertStyle get settingsAlertStyle => _settingsAlertStyle;

  AlertService() {
    _resultAlertStyle = AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      titleStyle: const TextStyle(
        color: MyTheme.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 25,
      ),
      descStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: MyTheme.textSecondary,
      ),
      animationDuration: MyTheme.animationNormal,
      buttonAreaPadding: const EdgeInsets.all(12),
      overlayColor: Colors.black.withValues(alpha: 0.7),
      constraints: const BoxConstraints(maxHeight: 200, maxWidth: 250),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MyTheme.radiusLarge),
      ),
    );

    _settingsAlertStyle = AlertStyle(
      animationType: AnimationType.fromBottom,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      titleStyle: const TextStyle(
        color: MyTheme.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 25,
      ),
      buttonAreaPadding: const EdgeInsets.all(12),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MyTheme.radiusLarge),
      ),
    );
  }
}
