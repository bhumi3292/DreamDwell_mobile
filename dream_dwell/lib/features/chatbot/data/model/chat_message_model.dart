import 'package:dream_dwell/features/chatbot/domain/entity/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required super.id,
    required super.text,
    required super.sender,
    super.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: json['text'] ?? '',
      sender: json['sender'] ?? 'bot',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sender': sender,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      text: entity.text,
      sender: entity.sender,
      timestamp: entity.timestamp,
    );
  }

  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      text: text,
      sender: sender,
      timestamp: timestamp,
    );
  }
} 