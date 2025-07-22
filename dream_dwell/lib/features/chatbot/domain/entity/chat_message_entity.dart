class ChatMessageEntity {
  final String id;
  final String text;
  final String sender; // 'user' or 'bot'
  final DateTime? timestamp;

  const ChatMessageEntity({
    required this.id,
    required this.text,
    required this.sender,
    this.timestamp,
  });
} 