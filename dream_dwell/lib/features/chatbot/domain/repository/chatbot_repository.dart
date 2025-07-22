import 'package:dream_dwell/features/chatbot/domain/entity/chat_message_entity.dart';
import 'package:dream_dwell/features/chatbot/domain/entity/chat_query_entity.dart';

abstract class ChatbotRepository {
  Future<ChatMessageEntity> sendChatQuery(ChatQueryEntity query);
  Future<List<ChatMessageEntity>> getChatHistory();
  Future<void> clearChatHistory();
} 