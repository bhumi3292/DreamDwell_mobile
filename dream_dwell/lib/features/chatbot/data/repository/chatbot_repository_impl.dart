import 'package:dream_dwell/features/chatbot/data/data_source/chatbot_data_source.dart';
import 'package:dream_dwell/features/chatbot/domain/entity/chat_message_entity.dart';
import 'package:dream_dwell/features/chatbot/domain/entity/chat_query_entity.dart';
import 'package:dream_dwell/features/chatbot/domain/repository/chatbot_repository.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotDataSource remoteDataSource;

  ChatbotRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ChatMessageEntity> sendChatQuery(ChatQueryEntity query) async {
    return await remoteDataSource.sendChatQuery(query);
  }

  @override
  Future<List<ChatMessageEntity>> getChatHistory() async {
    return await remoteDataSource.getChatHistory();
  }

  @override
  Future<void> clearChatHistory() async {
    await remoteDataSource.clearChatHistory();
  }
} 