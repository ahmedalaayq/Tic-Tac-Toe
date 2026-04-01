import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/statistics.dart';
import '../models/settings.dart';
import '../models/move.dart';
import '../models/cell_state.dart';

/// Service for persisting game data using SharedPreferences
class StorageService {
  static const String _keyGameState = 'game_state';
  static const String _keyStatistics = 'statistics';
  static const String _keySettings = 'settings';
  static const String _keyAchievements = 'achievements';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Factory constructor to create StorageService asynchronously
  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Game State Management

  /// Saves the current game state
  Future<void> saveGameState({
    required List<Move> moves,
    required CellState currentPlayer,
    required int xScore,
    required int oScore,
  }) async {
    try {
      final gameState = {
        'moves': moves.map((m) => m.toJson()).toList(),
        'currentPlayer': currentPlayer.toJson(),
        'xScore': xScore,
        'oScore': oScore,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _prefs.setString(_keyGameState, jsonEncode(gameState));
    } catch (e) {
      // Log error but don't throw - graceful degradation
      print('Error saving game state: $e');
    }
  }

  /// Loads the saved game state
  Future<Map<String, dynamic>?> loadGameState() async {
    try {
      final jsonString = _prefs.getString(_keyGameState);
      if (jsonString == null) {
        return null;
      }

      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate data structure
      if (!_validateGameState(data)) {
        await clearGameState();
        return null;
      }

      return data;
    } catch (e) {
      // Log error and return null - use default state
      print('Error loading game state: $e');
      await clearGameState();
      return null;
    }
  }

  /// Clears the saved game state
  Future<void> clearGameState() async {
    try {
      await _prefs.remove(_keyGameState);
    } catch (e) {
      print('Error clearing game state: $e');
    }
  }

  /// Validates game state data structure
  bool _validateGameState(Map<String, dynamic> data) {
    try {
      // Check required fields exist
      if (!data.containsKey('moves') ||
          !data.containsKey('currentPlayer') ||
          !data.containsKey('xScore') ||
          !data.containsKey('oScore')) {
        return false;
      }

      // Validate moves is a list
      if (data['moves'] is! List) {
        return false;
      }

      // Validate scores are numbers
      if (data['xScore'] is! int || data['oScore'] is! int) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Statistics Management

  /// Saves player statistics
  Future<void> saveStatistics(Statistics stats) async {
    try {
      await _prefs.setString(_keyStatistics, jsonEncode(stats.toJson()));
    } catch (e) {
      print('Error saving statistics: $e');
    }
  }

  /// Loads player statistics
  Future<Statistics> loadStatistics() async {
    try {
      final jsonString = _prefs.getString(_keyStatistics);
      if (jsonString == null) {
        return const Statistics();
      }

      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return Statistics.fromJson(data);
    } catch (e) {
      print('Error loading statistics: $e');
      return const Statistics();
    }
  }

  // Settings Management

  /// Saves app settings
  Future<void> saveSettings(Settings settings) async {
    try {
      await _prefs.setString(_keySettings, jsonEncode(settings.toJson()));
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  /// Loads app settings
  Future<Settings> loadSettings() async {
    try {
      final jsonString = _prefs.getString(_keySettings);
      if (jsonString == null) {
        return const Settings();
      }

      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return Settings.fromJson(data);
    } catch (e) {
      print('Error loading settings: $e');
      return const Settings();
    }
  }

  // Achievements Management

  /// Saves achievements
  Future<void> saveAchievements(List<String> unlockedAchievements) async {
    try {
      await _prefs.setStringList(_keyAchievements, unlockedAchievements);
    } catch (e) {
      print('Error saving achievements: $e');
    }
  }

  /// Loads achievements
  Future<List<String>> loadAchievements() async {
    try {
      return _prefs.getStringList(_keyAchievements) ?? [];
    } catch (e) {
      print('Error loading achievements: $e');
      return [];
    }
  }

  // Clear All Data

  /// Clears all stored data
  Future<void> clearAll() async {
    try {
      await _prefs.clear();
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }
}
