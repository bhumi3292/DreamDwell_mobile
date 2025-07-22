class ChatQueryEntity {
  final String query;
  final List<ChatHistoryEntity> history;

  ChatQueryEntity({
    required this.query,
    required this.history,
  });
}

class ChatHistoryEntity {
  final String role; // 'user' or 'model'
  final String text;

  const ChatHistoryEntity({
    required this.role,
    required this.text,
  });
} 