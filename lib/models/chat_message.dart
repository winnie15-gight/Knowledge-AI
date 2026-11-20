class ChatMessage {
  final int? id;
  final String role;
  final String content;
  final DateTime createdAt;
  final bool isPending;

  ChatMessage({
    this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.isPending = false,
  });

  bool get isUser => role == 'user';

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      role: json['role'] ?? 'assistant',
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
