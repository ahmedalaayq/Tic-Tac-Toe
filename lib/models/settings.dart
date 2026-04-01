import 'package:flutter/material.dart';
import 'statistics.dart';

/// Represents app settings
class Settings {
  final bool soundEnabled;
  final bool musicEnabled;
  final bool hapticsEnabled;
  final double volume;
  final ThemeMode themeMode;
  final DifficultyLevel defaultDifficulty;

  const Settings({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.hapticsEnabled = true,
    this.volume = 0.7,
    this.themeMode = ThemeMode.system,
    this.defaultDifficulty = DifficultyLevel.medium,
  });

  /// Creates a copy with updated values
  Settings copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    bool? hapticsEnabled,
    double? volume,
    ThemeMode? themeMode,
    DifficultyLevel? defaultDifficulty,
  }) {
    return Settings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      volume: volume ?? this.volume,
      themeMode: themeMode ?? this.themeMode,
      defaultDifficulty: defaultDifficulty ?? this.defaultDifficulty,
    );
  }

  /// Creates Settings from JSON
  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      musicEnabled: json['musicEnabled'] as bool? ?? true,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      volume: (json['volume'] as num?)?.toDouble() ?? 0.7,
      themeMode: _themeModeFromString(json['themeMode'] as String?),
      defaultDifficulty: json['defaultDifficulty'] != null
          ? DifficultyLevel.fromJson(json['defaultDifficulty'] as String)
          : DifficultyLevel.medium,
    );
  }

  /// Converts Settings to JSON
  Map<String, dynamic> toJson() {
    return {
      'soundEnabled': soundEnabled,
      'musicEnabled': musicEnabled,
      'hapticsEnabled': hapticsEnabled,
      'volume': volume,
      'themeMode': _themeModeToString(themeMode),
      'defaultDifficulty': defaultDifficulty.toJson(),
    };
  }

  static ThemeMode _themeModeFromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  @override
  String toString() {
    return 'Settings(soundEnabled: $soundEnabled, musicEnabled: $musicEnabled, hapticsEnabled: $hapticsEnabled, volume: $volume, themeMode: $themeMode, defaultDifficulty: $defaultDifficulty)';
  }
}
