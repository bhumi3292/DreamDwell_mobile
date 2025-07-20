import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dream_dwell/features/chatbot/presentation/bloc/chatbot_event.dart';
import 'package:dream_dwell/features/chatbot/presentation/bloc/chatbot_state.dart';
import 'package:dream_dwell/features/chatbot/domain/entity/chat_message_entity.dart';
import 'package:dream_dwell/features/chatbot/domain/entity/chat_query_entity.dart';
import 'package:dream_dwell/features/chatbot/domain/use_case/send_chat_query_usecase.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final SendChatQueryUseCase _sendChatQueryUseCase;

  ChatbotBloc({required SendChatQueryUseCase sendChatQueryUseCase})
      : _sendChatQueryUseCase = sendChatQueryUseCase,
        super(const ChatbotInitial()) {
    on<InitializeChatbot>(_onInitializeChatbot);
    on<SendChatMessage>(_onSendChatMessage);
    on<ClearChatHistory>(_onClearChatHistory);
    on<ToggleChatbotVisibility>(_onToggleChatbotVisibility);
    on<MinimizeChatbot>(_onMinimizeChatbot);
    on<MaximizeChatbot>(_onMaximizeChatbot);
  }

  void _onInitializeChatbot(
    InitializeChatbot event,
    Emitter<ChatbotState> emit,
  ) {
    print('=== INITIALIZING CHATBOT ===');
    final initialMessage = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Namaste! I\'m DreamBot, your friendly guide at DreamDwell. How can I help you find your perfect space or assist with your property today?',
      sender: 'bot',
      timestamp: DateTime.now(),
    );

    emit(ChatbotLoaded(
      messages: [initialMessage],
      isVisible: false, // Back to normal - hidden by default
      isMinimized: false,
      isLoading: false,
    ));
    print('Chatbot initialized with isVisible: false');
    print('=== END INITIALIZING CHATBOT ===');
  }

  Future<void> _onSendChatMessage(
    SendChatMessage event,
    Emitter<ChatbotState> emit,
  ) async {
    print('=== SEND CHAT MESSAGE DEBUG ===');
    print('Event message: "${event.message}"');
    print('Event history length: ${event.history.length}');
    print('Current state type: ${state.runtimeType}');
    
    if (state is ChatbotLoaded) {
      final currentState = state as ChatbotLoaded;
      print('Current state is ChatbotLoaded');
      print('Current messages count: ${currentState.messages.length}');
      
      // Add user message
      final userMessage = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: event.message,
        sender: 'user',
        timestamp: DateTime.now(),
      );

      final updatedMessages = [...currentState.messages, userMessage];
      print('Added user message, total messages: ${updatedMessages.length}');
      
      emit(currentState.copyWith(
        messages: updatedMessages,
        isLoading: true,
      ));
      print('Emitted loading state');

      try {
        // Create query entity
        final query = ChatQueryEntity(
          query: event.message,
          history: event.history,
        );
        print('Created query entity with query: "${query.query}"');

        // Send query to API
        print('Calling _sendChatQueryUseCase...');
        final botResponse = await _sendChatQueryUseCase(query);
        print('Received bot response: "${botResponse.text}"');
        
        // Add bot response
        final finalMessages = [...updatedMessages, botResponse];
        print('Added bot response, final messages count: ${finalMessages.length}');
        
        emit(currentState.copyWith(
          messages: finalMessages,
          isLoading: false,
        ));
        print('Emitted final state with bot response');
      } catch (e) {
        print('Error in _onSendChatMessage: $e');
        // Add error message
        final errorMessage = ChatMessageEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: 'Sorry, I encountered an error. Please try again.',
          sender: 'bot',
          timestamp: DateTime.now(),
        );

        final finalMessages = [...updatedMessages, errorMessage];
        print('Added error message, final messages count: ${finalMessages.length}');
        
        emit(currentState.copyWith(
          messages: finalMessages,
          isLoading: false,
        ));
        print('Emitted error state');
      }
    } else {
      print('State is not ChatbotLoaded: ${state.runtimeType}');
    }
    print('=== END SEND CHAT MESSAGE DEBUG ===');
  }

  void _onClearChatHistory(
    ClearChatHistory event,
    Emitter<ChatbotState> emit,
  ) {
    if (state is ChatbotLoaded) {
      final currentState = state as ChatbotLoaded;
      
      final initialMessage = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Namaste! I\'m DreamBot, your friendly guide at DreamDwell. How can I help you find your perfect space or assist with your property today?',
        sender: 'bot',
        timestamp: DateTime.now(),
      );

      emit(currentState.copyWith(
        messages: [initialMessage],
      ));
    }
  }

  void _onToggleChatbotVisibility(
    ToggleChatbotVisibility event,
    Emitter<ChatbotState> emit,
  ) {
    print('=== TOGGLE CHATBOT VISIBILITY ===');
    if (state is ChatbotLoaded) {
      final currentState = state as ChatbotLoaded;
      print('Current isVisible: ${currentState.isVisible}');
      final newVisibility = !currentState.isVisible;
      print('New isVisible: $newVisibility');
      
      emit(currentState.copyWith(
        isVisible: newVisibility,
        isMinimized: false, // Reset minimized state when toggling visibility
      ));
      print('State updated');
    } else {
      print('State is not ChatbotLoaded: ${state.runtimeType}');
    }
    print('=== END TOGGLE CHATBOT VISIBILITY ===');
  }

  void _onMinimizeChatbot(
    MinimizeChatbot event,
    Emitter<ChatbotState> emit,
  ) {
    if (state is ChatbotLoaded) {
      final currentState = state as ChatbotLoaded;
      emit(currentState.copyWith(
        isMinimized: true,
      ));
    }
  }

  void _onMaximizeChatbot(
    MaximizeChatbot event,
    Emitter<ChatbotState> emit,
  ) {
    if (state is ChatbotLoaded) {
      final currentState = state as ChatbotLoaded;
      emit(currentState.copyWith(
        isMinimized: false,
      ));
    }
  }
} 