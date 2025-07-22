import 'package:equatable/equatable.dart';
import 'package:dream_dwell/features/chatbot/domain/entity/chat_message_entity.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object?> get props => [];
}

class ChatbotInitial extends ChatbotState {
  const ChatbotInitial();
}

class ChatbotLoading extends ChatbotState {
  const ChatbotLoading();
}

class ChatbotLoaded extends ChatbotState {
  final List<ChatMessageEntity> messages;
  final bool isVisible;
  final bool isMinimized;
  final bool isLoading;

  const ChatbotLoaded({
    required this.messages,
    this.isVisible = false,
    this.isMinimized = false,
    this.isLoading = false,
  });

  ChatbotLoaded copyWith({
    List<ChatMessageEntity>? messages,
    bool? isVisible,
    bool? isMinimized,
    bool? isLoading,
  }) {
    return ChatbotLoaded(
      messages: messages ?? this.messages,
      isVisible: isVisible ?? this.isVisible,
      isMinimized: isMinimized ?? this.isMinimized,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [messages, isVisible, isMinimized, isLoading];
}

class ChatbotError extends ChatbotState {
  final String message;

  const ChatbotError({required this.message});

  @override
  List<Object?> get props => [message];
} 