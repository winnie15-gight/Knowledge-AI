import '../models/chat_message.dart';
import '../models/preferences.dart';
import 'api_service.dart';

class ChatService {
  static Future<List<ChatMessage>> getMessages() async {
    final res = await ApiService.get('/api/messages');
    final list = res['messages'] as List? ?? [];
    return list.map((item) => ChatMessage.fromJson(item)).toList();
  }

  static Future<String> sendMessage(String text) async {
    final res = await ApiService.post('/api/chat', {'message': text});
    return res['reply'] as String;
  }

  static Future<void> clearHistory() async {
    await ApiService.post('/clear-history', {});
  }

  static Future<TutorPreferences> getPreferences() async {
    final res = await ApiService.get('/api/settings');
    return TutorPreferences.fromJson(res['preferences']);
  }

  static Future<void> updatePreferences(TutorPreferences prefs) async {
    await ApiService.post('/api/settings', prefs.toJson());
  }

  static Future<void> submitFeedback({
    required String category,
    required int rating,
    required String message,
    String? name,
    String? email,
  }) async {
    await ApiService.post('/api/feedback', {
      'category': category,
      'rating': rating,
      'message': message,
      'name': name ?? '',
      'email': email ?? '',
    });
  }
}
