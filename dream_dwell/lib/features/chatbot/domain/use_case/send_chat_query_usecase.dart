import 'package:dream_dwell/features/chatbot/domain/entity/chat_message_entity.dart';
import 'package:dream_dwell/features/chatbot/domain/entity/chat_query_entity.dart';
import 'package:dream_dwell/features/chatbot/domain/repository/chatbot_repository.dart';

class SendChatQueryUseCase {
  final ChatbotRepository repository;

  SendChatQueryUseCase({required this.repository});

  Future<ChatMessageEntity> call(ChatQueryEntity query) async {
    return await repository.sendChatQuery(query);
  }
} 