import 'package:dream_dwell/features/chatbot/domain/entity/chat_query_entity.dart';

class ChatQueryModel extends ChatQueryEntity {
  ChatQueryModel({
    required super.query,
    required super.history,
  });

  factory ChatQueryModel.fromJson(Map<String, dynamic> json) {
    return ChatQueryModel(
      query: json['query'] ?? '',
      history: (json['history'] as List<dynamic>?)
              ?.map((item) => ChatHistoryModel.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'history': history.map((item) => (item as ChatHistoryModel).toJson()).toList(),
    };
  }

  factory ChatQueryModel.fromEntity(ChatQueryEntity entity) {
    return ChatQueryModel(
      query: entity.query,
      history: entity.history,
    );
  }
}

class ChatHistoryModel extends ChatHistoryEntity {
  ChatHistoryModel({
    required super.role,
    required super.text,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryModel(
      role: json['role'] ?? '',
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'text': text,
    };
  }
} 