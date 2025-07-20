import 'package:equatable/equatable.dart';
import 'package:dream_dwell/features/chatbot/domain/entity/chat_query_entity.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object?> get props => [];
}

class SendChatMessage extends ChatbotEvent {
  final String message;
  final List<ChatHistoryEntity> history;

  const SendChatMessage({
    required this.message,
    required this.history,
  });

  @override
  List<Object?> get props => [message, history];
}

class InitializeChatbot extends ChatbotEvent {
  const InitializeChatbot();
}

class ClearChatHistory extends ChatbotEvent {
  const ClearChatHistory();
}

class ToggleChatbotVisibility extends ChatbotEvent {
  const ToggleChatbotVisibility();
}

class MinimizeChatbot extends ChatbotEvent {
  const MinimizeChatbot();
}

class MaximizeChatbot extends ChatbotEvent {
  const MaximizeChatbot();
} 