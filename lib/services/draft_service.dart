import 'package:shared_preferences/shared_preferences.dart';

class DraftService {
  static Future<void> saveDraft({
    required String title,
    required String description,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('draft_title', title);
    await prefs.setString('draft_description', description);
  }

  static Future<Map<String, String>> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'title': prefs.getString('draft_title') ?? '',
      'description': prefs.getString('draft_description') ?? '',
    };
  }

  static Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('draft_title');
    await prefs.remove('draft_description');
  }
}